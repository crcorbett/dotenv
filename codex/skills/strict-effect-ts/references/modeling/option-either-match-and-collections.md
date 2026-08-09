# Option, Either, Match, and Collections

## Option

Use Option when absence is a valid semantic state after ingress:

- optional lookup result;
- optional configuration branch;
- cache miss;
- optional provider field once decoded;
- optional previous value.

Do not allow `null | undefined` to spread through the domain. Decode nullable input once into Option or reject it.

Use a typed not-found error instead when absence is exceptional for the operation. The service contract decides; do not convert every failure into Option.

## Either

Use Either for a synchronous pure computation that has a typed expected alternative and does not need Effect requirements, concurrency, interruption, or observability.

Use Effect when the computation:

- performs I/O;
- depends on services;
- is asynchronous;
- needs retry/timeout;
- owns resources;
- participates in a larger Effect workflow.

Do not shuttle between Either and Effect repeatedly without a boundary reason.

## Match

Use exhaustive Match or equivalent exhaustive tagged-union handling for:

- domain states;
- provider resource kinds;
- plan classes;
- error recovery;
- workflow results;
- serialised messages.

Do not add a default branch that hides a new tag. If a provider introduces an unknown string, fail Schema decoding before the domain Match.

## Collections

Choose by semantics:

- `ReadonlyArray`: ordered, JSON-friendly bounded data;
- `Chunk`: immutable efficient sequences in Effect workflows/streams;
- `HashMap`: immutable key/value domain state;
- `HashSet`: immutable uniqueness;
- `SortedMap`/`SortedSet`: stable ordering when the installed package supports the needed contract;
- native `Map`/`Set`: only inside a measured, encapsulated implementation.

Use collection APIs for immutable updates. Do not expose a mutable collection from a service.

## Boundedness

Decode maximum lengths for external arrays/maps. Avoid collecting an unbounded Stream into memory.

For provider inventories and receipts:

- page/stream provider results;
- sort on a stable safe key when deterministic output matters;
- cap receipt entries;
- report total/count/truncation;
- avoid serialising raw items.

## Equality and hashing

Use branded/stable identifiers as keys. If domain equality is richer than reference equality, choose an Effect data type or implement the installed equality/hash protocol deliberately.

Do not use JSON stringification as a general equality or map-key strategy.

## Traversal

Use Effect collection traversal when each element performs an Effect:

- choose explicit concurrency;
- preserve/recover failures deliberately;
- retain stable result ordering if the contract needs it;
- encode rate limit/backpressure.

Do not write `Promise.all(array.map(async ...))`. Do not default to unbounded concurrency.

## Tests

Test:

- absence versus failure semantics;
- exhaustive tagged matches;
- duplicate handling;
- stable ordering;
- bounds/truncation;
- concurrency and failure policy for Effect traversal.
