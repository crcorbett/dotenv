# HTTP, RPC, and Serialisation

## Outbound HTTP

Use Effect Platform HttpClient or a private provider adapter.

For each operation:

1. construct path/query/header/body from branded domain input;
2. encode body with Schema;
3. keep credentials redacted until the request boundary;
4. set timeout and redirect policy explicitly;
5. classify transport/status failures;
6. decode response body with Schema;
7. scope streaming bodies;
8. add span and safe attributes.

Do not use global `fetch` in domain code. If a host supplies fetch, provide it as the platform HttpClient Layer.

## Status handling

Map status/code to a closed domain vocabulary. Do not accept every 2xx response without decoding. Do not turn every non-2xx into one string error.

Handle redirects intentionally:

- follow when the operation contract permits;
- inspect manually for redirect proof/auth flows;
- reject unexpected cross-origin redirects;
- never log sensitive Location query values.

## Inbound HTTP

At the route boundary:

- decode path, query, headers, cookies, and body;
- enforce size limits;
- construct a named domain operation;
- map tagged errors exhaustively to protocol errors;
- encode response through Schema;
- set headers/cookies through typed protocol facilities;
- run through the application runtime.

Do not pass a raw Request into the domain service.

## RPC

Define RPC procedures from shared Schemas and tagged serialisable errors. Keep transport details out of the domain service.

Require:

- request/response Schema;
- error Schema;
- authentication/authorisation boundary;
- deadline/cancellation propagation;
- versioning;
- payload limits;
- observability safe fields.

Do not expose arbitrary Effect Causes or class instances over RPC.

## Serialisation

Values crossing a process/runtime/hydration boundary must be encoded.

Watch:

- Dates/instants;
- Option/Either;
- branded values;
- big integers;
- Maps/Sets/Chunks;
- tagged errors;
- URLs;
- Redacted;
- binary data;
- cyclic values.

Never assume JSON.stringify preserves domain semantics. Use Schema transformations and a versioned envelope.

## Streaming HTTP/RPC

Use Stream for actual incremental bodies/messages. Scope the response body and propagate cancellation. Define framing, maximum frame size, decode failure, heartbeat, and reconnection.

Do not buffer a full stream into text/JSON and still claim streaming.

## Testing

Provide controlled HttpClient/fetch Layers. Assert:

- encoded request;
- secret header redaction;
- redirect policy;
- status/error mapping;
- invalid JSON/body;
- cancellation and body finalisation;
- retry policy;
- serialisation round-trip;
- no live network in unit tests.
