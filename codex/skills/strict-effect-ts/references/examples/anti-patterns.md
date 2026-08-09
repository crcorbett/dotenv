# Anti-patterns

## Contents

- [Effect-shaped Promise code](#effect-shaped-promise-code)
- [Runtime in a package](#runtime-in-a-package)
- [Raw client service](#raw-client-service)
- [Accidental requirements](#accidental-requirements)
- [Typed cast boundary](#typed-cast-boundary)
- [Primitive soup](#primitive-soup)
- [Nullable domain](#nullable-domain)
- [Throw inside Effect](#throw-inside-effect)
- [Catch-all Cause collapse](#catch-all-cause-collapse)
- [Ambient Config](#ambient-config)
- [Console telemetry](#console-telemetry)
- [Native timer retry](#native-timer-retry)
- [Promise all](#promiseall)
- [Detached work](#detached-work)
- [Global Map cache](#global-map-cache)
- [Fake streaming](#fake-streaming)
- [Success-only test](#success-only-test)
- [Mega Layer](#mega-layer)
- [Effect ceremony](#effect-ceremony)

## Effect-shaped Promise code

**Smell:** Effect wraps one large `tryPromise`, while orchestration remains an async SDK workflow.

**Correction:** keep only the SDK call at `tryPromise`; model branching, retry, timeout, concurrency, and errors as Effect.

## Runtime in a package

**Smell:** `service.ts` calls `Effect.runPromise`.

**Correction:** return Effect and execute at the application/framework/CLI boundary.

## Raw client service

**Smell:** service exposes `client`, `request`, or `withClient(callback)`.

**Correction:** expose named domain operations; keep client private to `live.layer.ts`.

## Accidental requirements

**Smell:** every caller must provide HttpClient, Config, and SDK services to use a domain service.

**Correction:** build those dependencies into the live Layer; close public operation requirements.

## Typed cast boundary

**Smell:** `response as ProviderResponse`.

**Correction:** decode unknown provider output through an owned Schema and map codec failure.

## Primitive soup

**Smell:** project ID, user ID, dataset ID, and redirect URI are strings.

**Correction:** Schema-decode branded domain values at ingress.

## Nullable domain

**Smell:** `?.` and `??` appear throughout business logic.

**Correction:** decode nullable input once and use Option or a not-found error.

## Throw inside Effect

**Smell:** `Effect.sync(() => { throw new DomainError() })`.

**Correction:** use `Effect.fail` for expected error; reserve defects for impossible invariants.

## Catch-all Cause collapse

**Smell:** every Cause becomes `UnknownError`.

**Correction:** recover expected tags exhaustively and preserve defects/interruption.

## Ambient Config

**Smell:** each operation reads `process.env`.

**Correction:** acquire Config in the live Layer/application root and close it into the service.

## Console telemetry

**Smell:** `console.error(error)` in recovery.

**Correction:** structured Effect log with safe error tag/fields; defect reporter for unexpected Cause.

## Native timer retry

**Smell:** recursive `setTimeout` polling.

**Correction:** Clock + Schedule + typed read operation + terminal-state Match.

## Promise.all

**Smell:** unbounded provider calls via `Promise.all`.

**Correction:** Effect traversal with explicit concurrency, ordering, and failure policy.

## Detached work

**Smell:** handler fires a Promise/fibre and returns.

**Correction:** join/scope/supervise it or attach it to the host completion lifecycle.

## Global Map cache

**Smell:** module-level mutable Map stores provider/domain results forever.

**Correction:** scoped Cache/service with capacity, expiry, invalidation, and tests.

## Fake streaming

**Smell:** SDK response is fully buffered before constructing Stream.

**Correction:** preserve incremental source, backpressure, Scope, and cancellation; prove early observation.

## Success-only test

**Smell:** one happy-path test with a mocked function.

**Correction:** contract Layer plus decode failure, tagged errors, timeout/retry, interruption, cleanup, and observability safety.

## Mega Layer

**Smell:** one global Layer imports every domain and provider, making unit composition impossible.

**Correction:** domain Layers with explicit dependencies, composed only at application roots.

## Effect ceremony

**Smell:** pure constants/functions wrapped in services and Effects with no semantic benefit.

**Correction:** keep total deterministic leaves plain; use Effect for actual failure/dependency/lifetime/concurrency.
