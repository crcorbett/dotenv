# Files and Packages

## Contents

- [Standard service layout](#standard-service-layout)
- [Larger domain layout](#larger-domain-layout)
- [Application layout](#application-layout)
- [Infrastructure layout](#infrastructure-layout)
- [Naming](#naming)
- [Public exports](#public-exports)
- [Dependency direction](#dependency-direction)
- [Package checks](#package-checks)

## Standard service layout

```text
src/
  schemas.ts
  errors.ts
  service.ts
  live.layer.ts
  memory.layer.ts
  index.ts
```

Use:

- `schemas.ts`: boundary/domain Schemas, brands, encoded types;
- `errors.ts`: closed tagged expected errors;
- `service.ts`: Context service and named operation signatures;
- `live.layer.ts`: real transport/SDK/storage/config wiring;
- `memory.layer.ts`: deterministic implementation of the same contract;
- `index.ts`: deliberate public exports only.

Do not create all files for a trivial module. Colocate a coherent small service until one of these becomes an independently meaningful owner.

## Larger domain layout

```text
src/
  schemas.ts
  errors.ts
  service.ts
  live.layer.ts
  memory.layer.ts
  operations/
    create-account.ts
    load-account.ts
  transports/
    http.layer.ts
    sdk.layer.ts
  persistence/
    service.ts
    live.layer.ts
  observability/
    metrics.ts
    attributes.ts
```

Extract operation modules when they own substantial policy, not one function call.

## Application layout

```text
apps/<app>/src/
  config/
    schemas.ts
  runtime/
    server.runtime.ts
    client.runtime.ts
  services/
  routes/
  observability/
    logging.layer.ts
    tracing.layer.ts
    metrics.layer.ts
```

The application composes Layers and owns runtime execution. Workspace packages remain runtime-free.

## Infrastructure layout

For Alchemy:

```text
packages/infrastructure/src/
  schemas.ts
  errors.ts
  service.ts
  live.layer.ts
  memory.layer.ts
  providers/
  stacks/
alchemy.run.ts
```

Use `$alchemy-iac` for provider ownership and proof conventions.

## Naming

Prefer:

- `service.ts`, not `client.ts`, for the domain contract;
- `live.layer.ts`, not `impl.ts`, for live dependency wiring;
- `memory.layer.ts` or a semantic fake name, not `mock.ts` when it is a valid contract implementation;
- `errors.ts`, not `exceptions.ts`;
- `schemas.ts`, not `types.ts` for data with runtime shape;
- `*.runtime.ts` for an application execution boundary;
- `*.adapter.ts` only for a narrow host/provider translation;
- semantic owners instead of `utils.ts`, `helpers.ts`, `common.ts`, or `shared.ts`.

## Public exports

Export:

- Schemas and branded domain types;
- tagged errors callers may handle;
- service tags/contracts;
- Layer constructors intended for application composition;
- pure domain functions.

Keep private:

- raw SDK clients;
- transport response types;
- Config providers and secret values;
- internal retry schedules;
- runtime handles;
- provider DTOs;
- arbitrary constructors that bypass Schema.

## Dependency direction

```text
application runtime
  -> live Layers
  -> service contracts
  -> domain Schemas/errors
```

Domain modules must not import the application runtime. A service contract must not import its live Layer. Test Layers implement the contract without importing Production configuration.

## Package checks

Enforce:

- explicit exports map;
- no import-time environment access;
- no package-owned runtime;
- no raw provider package in public declaration output;
- tests against public contract;
- circular dependency checks;
- Effect version aligned with workspace policy.
