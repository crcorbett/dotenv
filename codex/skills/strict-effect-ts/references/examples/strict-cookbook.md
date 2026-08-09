# Strict Cookbook

Examples use the Effect v4 beta style observed in the reviewed repositories, which were pinned around beta.98–beta.102. Later betas can rename APIs. Confirm every import and declaration against the installed version. In particular, those reviewed betas expose `Schema.TaggedErrorClass`, while newer upstream source exposes `Schema.TaggedError`; copy the architecture, not the spelling.

## Contents

- [Schema error service](#schema-error-service)
- [Live Layer](#live-layer)
- [Provider Promise boundary](#provider-promise-boundary)
- [Nullable ingress](#nullable-ingress)
- [Config and secret](#config-and-secret)
- [Bounded traversal](#bounded-traversal)
- [Retry and timeout](#retry-and-timeout)
- [Scoped resource](#scoped-resource)
- [Queue worker](#queue-worker)
- [CLI runtime](#cli-runtime)
- [Framework Promise bridge](#framework-promise-bridge)
- [Effect with Alchemy](#effect-with-alchemy)

## Schema, error, service

```ts
import { Context, Effect, Schema } from "effect"

export const AccountId = Schema.String.pipe(/* installed brand/refinement API */)
export type AccountId = typeof AccountId.Type

export const Account = Schema.Struct({
  id: AccountId,
  displayName: Schema.String
})
export type Account = typeof Account.Type

export class AccountNotFound extends Schema.TaggedErrorClass<AccountNotFound>()(
  "AccountNotFound",
  { id: AccountId }
) {}

export class AccountsUnavailable
  extends Schema.TaggedErrorClass<AccountsUnavailable>()(
    "AccountsUnavailable",
    { operation: Schema.String }
  ) {}

export interface AccountsContract {
  readonly load: (
    id: AccountId
  ) => Effect.Effect<Account, AccountNotFound | AccountsUnavailable>
}

export class Accounts extends Context.Service<Accounts, AccountsContract>()(
  "@acme/accounts/Accounts"
) {}
```

Keep Schemas, errors, and service in their conventional files in real code.

The error declaration above is intentionally version-specific to the reviewed betas. Use the installed Schema tagged-error constructor and preserve the same closed, Schema-backed fields.

## Live Layer

```ts
import { Effect, Layer, Schema } from "effect"

const decodeProviderAccount = Schema.decodeUnknownEffect(ProviderAccount)

const makeAccounts = Effect.gen(function* () {
  const transport = yield* AccountsTransport

  const load: AccountsContract["load"] = (id) =>
    Effect.gen(function* () {
      const response = yield* transport.getAccount(id)
      return yield* decodeProviderAccount(response)
    }).pipe(
      Effect.mapError(mapAccountsError),
      Effect.withSpan("Accounts.load", {
        attributes: { "account.id": id }
      })
    )

  return Accounts.of({ load })
})

export const AccountsLive = Layer.effect(Accounts, makeAccounts)
```

The transport, Config, and SDK are private Layer dependencies. Adjust decode and span APIs to the installed version.

## Provider Promise boundary

```ts
const callSdk = (id: AccountId) =>
  Effect.tryPromise({
    try: (signal) => sdk.accounts.get({ id, signal }),
    catch: () =>
      new AccountsUnavailable({ operation: "load" })
  })
```

Place this in `live.layer.ts` or a private adapter, not at each call site. Decode the result immediately.

## Nullable ingress

```ts
const OptionalNickname = Schema.NullOr(Schema.String).pipe(
  /* transform to Option using the installed Schema API */
)
```

Once decoded, use Option matching. Do not keep `string | null` throughout the domain.

## Config and secret

```ts
const makeProvider = Effect.gen(function* () {
  const endpoint = yield* ProviderEndpointConfig
  const token = yield* ProviderTokenConfig // redacted

  return Provider.of({
    query: (input) =>
      queryProvider(endpoint, token, input)
  })
})
```

Represent the concrete Config values using the installed Config/Schema APIs. Unwrap the token only inside the request boundary.

## Bounded traversal

```ts
const loadMany = (ids: ReadonlyArray<AccountId>) =>
  Effect.forEach(ids, loadAccount, {
    concurrency: 8
  })
```

Choose failure and ordering policy explicitly. Use serial concurrency for provider mutations that require read-after-write.

## Retry and timeout

```ts
const resilientRead = readProvider.pipe(
  Effect.retry(retryTransientSchedule),
  Effect.timeout(providerTimeout),
  Effect.mapError(mapReadError)
)
```

The schedule must filter typed retryable failures. Never retry permission or validation errors.

## Scoped resource

```ts
const withClient = Effect.acquireRelease(
  makeClient,
  (client) => closeClient(client).pipe(Effect.orElseSucceed(() => undefined))
)
```

Use the installed scoped API and keep the client private. Do not expose a generic `withClient(callback)` service.

## Queue worker

```text
Layer acquires bounded Queue
  -> supervised scoped worker fibre takes jobs
  -> named service operation processes each job
  -> shutdown interrupts worker and closes Queue
```

Test with a Deferred/barrier rather than sleep.

## CLI runtime

```ts
const program = Effect.gen(function* () {
  const command = yield* decodeArguments
  return yield* runCommand(command)
})

// Only the root host file uses the installed Bun runtime bridge.
```

Map typed failure to exit status at the root. Packages return Effect.

## Framework Promise bridge

```ts
export const loader = (hostInput: HostLoaderInput): Promise<EncodedLoaderData> =>
  appRuntime.runPromise(
    decodeLoaderInput(hostInput).pipe(
      Effect.flatMap(loadRouteData),
      Effect.flatMap(encodeLoaderData)
    )
  )
```

This Promise exists only because the host requires it. Reuse one application runtime and wire host cancellation.

## Effect with Alchemy

```text
alchemy.run.ts
  -> decode stage and authority
  -> provide state/provider Layers
  -> run named stack Effect
  -> resolve/encode safe outputs
```

Provider Resources own read/diff/reconcile/delete. Use `$alchemy-iac` for lifecycle and proof.
