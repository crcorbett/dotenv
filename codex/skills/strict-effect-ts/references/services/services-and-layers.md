# Services and Layers

## Contents

- [Contract first](#contract-first)
- [Named operations](#named-operations)
- [Close public requirements](#close-public-requirements)
- [Layer construction](#layer-construction)
- [Layer dependency direction](#layer-dependency-direction)
- [Layer names](#layer-names)
- [Memory test Layers](#memorytest-layers)
- [Layer construction failures](#layer-construction-failures)
- [Avoid over-layering](#avoid-over-layering)
- [Tests](#tests)

## Contract first

A service exposes domain capabilities, not an implementation technology.

```ts
interface AccountsContract {
  readonly load: (
    id: AccountId
  ) => Effect.Effect<Account, AccountNotFound | AccountsUnavailable>

  readonly create: (
    input: CreateAccount
  ) => Effect.Effect<Account, InvalidAccount | AccountsUnavailable>
}
```

Use the installed Effect version's Context service/tag API. Give tags globally unique stable identifiers according to repository policy.

## Named operations

Prefer:

- `loadAccount`;
- `createRedirectUri`;
- `queryDataset`;
- `readDeployment`.

Reject:

- `request<T>(options)`;
- `execute<T>(callback)`;
- `withClient(fn)`;
- `raw`;
- `sdk`.

A caller should express domain intent without knowing URL paths, SDK methods, or credentials.

## Close public requirements

Public service operations should normally return:

```text
Effect<Success, DomainError, never>
```

The service Layer acquires transport, persistence, Config, Clock, or provider SDK requirements while constructing the implementation. This prevents dependency details leaking to every caller.

Keep a requirement public only when it is intentionally part of composition, such as a generic policy module designed to work over a caller-supplied service.

## Layer construction

Construct implementations in `live.layer.ts`:

1. acquire dependencies;
2. derive private helpers;
3. define named operations with exact contract types;
4. add spans/log annotations at semantic operations;
5. return the service implementation;
6. expose a Layer.

Avoid side effects during module import.

## Layer dependency direction

If `AccountsLive` needs `AccountsStore` and `IdentityProvider`, its Layer input contains those services. Compose them at the application root.

Do not:

- provide dependencies inside every operation;
- import `AccountsStoreLive` from `service.ts`;
- make `AccountsLive` read process environment itself if Config can be layered;
- rebuild expensive clients per call.

## Layer names

Use:

- `AccountsLive`;
- `AccountsMemory`;
- `AccountsTest` when it is test-specific;
- `AccountsHttpLive` only if multiple live transports coexist.

`live.layer.ts` may export multiple closely related Layers, but avoid a global mega-Layer with unrelated domains.

## Memory/test Layers

Implement the identical service contract. A memory Layer may expose a separate control service for:

- seeding state;
- observing calls;
- injecting failure;
- advancing a simulated provider state.

Do not add testing-only methods to the Production service contract.

Make state immutable/Effect-managed and tests scoped so suites cannot leak state.

## Layer construction failures

If configuration or SDK construction can fail, express it in the Layer error channel and prove application startup handles it. Do not throw during import or constructor evaluation.

Once a runtime is successfully built, public service operations may be closed over those dependencies.

## Avoid over-layering

Do not create:

- a service for a pure stateless function;
- a Layer that only wraps a static constant with no composition value;
- one service per SDK method;
- a separate Layer for every helper.

Use services for substitutable capabilities, dependency boundaries, state/lifetime, provider isolation, or observability policy.

## Tests

Test:

- contract through memory and controlled live adapter;
- Layer builds with valid Config;
- Layer fails with typed error for invalid Config/client construction;
- public operation requirements are intentional;
- provider client is not publicly exported;
- dependencies are constructed once per intended scope.
