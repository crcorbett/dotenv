# Schemas and Brands

## Contents

- [Decode once](#decode-once)
- [Encode owned output](#encode-owned-output)
- [Domain brands](#domain-brands)
- [Exact structures](#exact-structures)
- [Transformations](#transformations)
- [Versioned durable data](#versioned-durable-data)
- [Provider responses](#provider-responses)
- [Schema-tagged errors](#schema-tagged-errors)
- [Tests](#tests)

## Decode once

Treat all external values as `unknown` until Schema decodes them:

- environment and platform bindings;
- HTTP/RPC/queue input;
- provider SDK responses;
- database rows;
- JSON files;
- Alchemy state and outputs;
- workflow payloads;
- browser storage;
- durable receipts.

Decode at the first trusted boundary. Do not pass `unknown` inward for a later caller to handle.

## Encode owned output

Use Schema encoding for:

- provider requests owned by the application;
- HTTP/RPC responses;
- persisted state;
- cache values;
- messages/events;
- workflow outputs;
- receipts.

Encoding proves the outbound contract and prevents accidental runtime objects, Causes, secrets, or non-serialisable values from leaking.

## Domain brands

Brand values that are semantically distinct despite sharing a primitive:

- account/project/tenant IDs;
- email address;
- absolute URL and redirect URI;
- dataset/dashboard ID;
- stage;
- source revision;
- money/currency;
- bounded count;
- timestamp and duration.

Do not accept arbitrary strings and rely on parameter names to protect identity.

Brand at decode/construction. Avoid a public `as Brand` escape hatch.

## Exact structures

Use exact object Schemas where unknown keys indicate drift or unsafe input. Decide deliberately whether unknown keys are rejected, stripped, or preserved; do not accept the library default without considering the boundary.

Represent closed alternatives as:

- literal unions;
- tagged unions;
- nullable/optional input that decodes into Option when absence is semantic.

Use a discriminant field for plans, receipts, messages, and errors.

## Transformations

Use Schema transformations when encoded and domain representations differ:

- ISO timestamp ↔ domain instant;
- redacted encoded secret ↔ Redacted value;
- string identifier ↔ brand;
- nullable input ↔ Option;
- provider enum ↔ domain tagged union.

Keep transformations total in each declared direction or expose decode failure explicitly.

## Versioned durable data

Include an explicit schema version in persisted state, events, and receipts. Define migrations as decoded transformations:

```text
unknown
  -> version discriminator
  -> old Schema decode
  -> migration Effect
  -> current domain
  -> current Schema encode
```

Do not mutate historical evidence to resemble the new version.

## Provider responses

Provider SDK typings are not runtime validation.

1. call the private SDK/HttpClient;
2. treat response as untrusted;
3. select the minimal fields;
4. decode through an owned Schema;
5. map codec failure to a tagged provider-payload error;
6. return domain values only.

This protects against SDK looseness and provider drift.

## Schema-tagged errors

Use the installed Effect version's Schema-tagged error class when errors cross serialisation boundaries. Keep fields bounded and safe. For purely internal errors, a non-Schema tagged data class may be sufficient.

Do not serialise arbitrary `Error`, stack traces, SDK errors, or Causes.

## Tests

For each material Schema, test:

- representative valid decode;
- every refinement failure;
- unknown/missing field policy;
- encode/decode round-trip where applicable;
- redaction;
- old-version migration;
- provider drift;
- maximum sizes and bounded collections.

Use property-based testing for identifiers, codecs, and round-trips where valuable.
