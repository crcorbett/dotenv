# Lint, Review, and Migration

## Contents

- [Establish the boundary](#establish-the-boundary)
- [Static restrictions](#static-restrictions)
- [Structural tests](#structural-tests)
- [Review sequence](#review-sequence)
- [Migration inventory](#migration-inventory)
- [Recommended migration order](#recommended-migration-order)
- [Incremental strictness](#incremental-strictness)
- [Review blockers](#review-blockers)
- [Completion evidence](#completion-evidence)

## Establish the boundary

Define owned TypeScript paths and exact exceptions:

- application/package source: strict;
- tests: strict, with deterministic test APIs;
- host adapters: narrow allowed bridge;
- generated/vendor: excluded by exact path;
- configuration files: classify individually;
- migrations: strict for I/O and errors even if historical data shapes are plain.

Do not disable a rule repository-wide for one host constraint.

## Static restrictions

Use lint/architecture tests to forbid or restrict:

- `async` functions and `new Promise`;
- raw `fetch`;
- direct environment access;
- `console.*`;
- ambient time/random/timers;
- unchecked JSON;
- `any` and unsafe assertions;
- `Effect.run*` outside runtime files;
- provider SDK imports outside approved live adapters;
- generic raw client exports;
- mutable globals;
- native Map/Set in domain paths;
- package imports of application runtimes.

Rules should report the approved alternative and exact adapter path policy.

## Structural tests

Add tests that inspect:

- package exports;
- forbidden dependency direction;
- service operation error/requirement shape where TypeScript assertions are practical;
- runtime file locations;
- receipt Schemas;
- provider client privacy;
- application Layer ownership.

Prefer enforcement that fails with a semantic message over a fragile snapshot.

## Review sequence

Review changed code in this order:

1. external Schemas and brands;
2. error vocabulary;
3. service contract;
4. live/test Layers;
5. runtime boundary;
6. concurrency/lifetime;
7. observability;
8. tests;
9. exports and file ownership.

This catches architectural leaks before line-level style.

## Migration inventory

Search and classify:

- Promise/async chains;
- throws and catch-all handling;
- raw environment/config;
- raw JSON and assertions;
- raw HTTP/SDK clients;
- nullable domain values;
- mutable collections/state;
- timer/retry/polling loops;
- event callbacks;
- console logging;
- repeated runtime execution.

Build a table:

| Seam | Current behaviour | Target Effect owner | Error/Schema | Test | Risk |
| --- | --- | --- | --- | --- | --- |

Migrate by semantic seam, not by global mechanical replacement.

## Recommended migration order

1. Add Schemas/brands at ingress.
2. Define tagged errors.
3. Define service contract.
4. Wrap live transport/SDK in a Layer.
5. Add memory/test Layer and contract tests.
6. Move orchestration into a flat Effect program.
7. move execution to one application boundary;
8. replace time/state/concurrency primitives;
9. add structured observability;
10. restrict old escape hatches;
11. remove deprecated exports.

Keep compatibility adapters temporary, private, and tracked for removal. Do not publish both a strict service and a permanent raw client.

## Incremental strictness

For a large codebase:

- make changed packages strict first;
- forbid new violations on the diff;
- add architecture checks around new boundaries;
- convert call sites in coherent slices;
- keep a counted debt list with owner/removal condition;
- prevent the compatibility surface from expanding.

Do not claim the repository is fully strict while unclassified escape hatches remain.

## Review blockers

Block the change when:

- expected failure is thrown or converted to defect;
- external data is asserted rather than decoded;
- SDK/raw client crosses the service boundary;
- public operations have accidental requirements;
- package owns a runtime;
- time/concurrency/resource lifetime is unmanaged;
- secrets can reach logs/errors/receipts;
- success-only tests omit material failure/interruption;
- a broad exception weakens unrelated code.

## Completion evidence

Report:

- changed owned paths;
- strict searches and classified exceptions;
- typecheck/lint/test results;
- Layer/contract tests;
- runtime boundary;
- skipped live integration;
- remaining debt and non-claims.
