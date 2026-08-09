# State, Collections, and Caches

## State selection

Choose the narrowest primitive:

- immutable local value for pure transformation;
- `Ref` for atomic synchronous Effect-managed state;
- synchronised/ref variant when updates require effects;
- subscription ref for observable current state;
- STM/TRef for composable multi-variable transactions;
- Queue/PubSub for communication rather than shared mutable state;
- Cache for keyed effectful memoisation with policy;
- scoped resource for state tied to a lifetime.

Inspect installed Effect exports; names and modules can change across versions.

## No mutable globals

Reject module-level mutable objects, arrays, Maps, Sets, clients, counters, or caches in shared packages.

Application-level state belongs in a Layer so:

- construction is explicit;
- lifetime is scoped;
- tests can substitute it;
- concurrent access policy is visible;
- shutdown can clear resources.

## Ref

Use Ref for small atomic state such as:

- last safe provider cursor;
- in-memory test inventory;
- bounded operation observations;
- feature state;
- counters where Metric is not the right semantic store.

Keep updates pure and atomic. Do not read-modify-write using separate operations when lost updates matter.

## STM

Use STM when multiple pieces of state must change atomically or operations may retry based on transactional conditions.

Examples:

- reserve capacity and enqueue work together;
- move an item between two collections;
- update resource inventory plus index;
- coordinate a bounded pool.

Do not introduce STM for a single simple value.

## Domain collections

Use immutable Effect collections for domain state where they express equality, hashing, ordering, and persistent updates. Use ReadonlyArray for bounded ordered serialisable values.

Native Map/Set may remain:

- within a private performance-critical implementation;
- when a host API requires them;
- in total leaf code where mutation does not escape.

Document and test the containment. Never expose a mutable reference.

## Cache

Define:

- key Schema/brand;
- lookup Effect and error;
- capacity;
- expiry using Effect time;
- invalidation;
- concurrent miss behaviour;
- negative-cache policy;
- observability;
- scope/shutdown.

Do not use a plain global Map as a cache. Do not cache secrets, provider errors, or unbounded payloads without explicit policy.

## Context-local state

Use Effect context/fibre-local facilities for request correlation or scoped annotations when supported by the installed version. Do not use ambient global variables for request identity.

## Tests

Test:

- atomic concurrent updates;
- scoped isolation;
- cache hit/miss/expiry with TestClock;
- invalidation;
- bounded capacity;
- failure caching policy;
- no state leakage between test Layers;
- immutable collection behaviour.
