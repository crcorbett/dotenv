# Primary Sources and Version Policy

## Installed version wins

The reviewed repositories use changing Effect v4 beta versions. API names, module paths, Context/service construction, platform packages, and unstable modules can change.

Before implementing:

1. inspect `package.json` and the lockfile;
2. inspect installed `effect` exports and declaration files;
3. inspect installed platform/unstable modules;
4. consult matching official documentation/source;
5. compile and test the chosen API.

Do not paste v3 examples or examples from another v4 beta without verification.

Recent v4 betas demonstrate why this is mandatory:

- reviewed beta.98–beta.102 packages identify `Effect-TS/effect-smol` and expose `Schema.TaggedErrorClass`;
- newer beta package metadata identifies `Effect-TS/effect`, whose current source exposes `Schema.TaggedError`;
- both repositories remain accessible, so a GitHub search without the pinned package version can select the wrong generation.

Inspect the installed `effect/package.json`, `Schema.d.ts` or source, lockfile, and matching changelog/migration guide. Keep all Effect ecosystem packages on the compatible version family required by that installation.

## Official Effect sources

- [Effect website](https://effect.website/)
- [Effect introduction](https://effect.website/docs/getting-started/introduction/)
- [Configuration](https://effect.website/docs/configuration)
- [Layers](https://effect.website/docs/requirements-management/layers)
- [Logging](https://effect.website/docs/observability/logging)
- [Tracing](https://effect.website/docs/observability/tracing)
- [Metrics](https://effect.website/docs/observability/metrics)
- [API reference routing](https://effect.website/docs/additional-resources/api-reference)
- [Current Effect source repository](https://github.com/Effect-TS/effect)
- [Earlier Effect v4 beta source repository](https://github.com/Effect-TS/effect-smol)

Follow official documentation links for the installed platform, Schema, Stream, Scope, Schedule, testing, and persistence packages.

## Secondary repository research

DeepWiki guidance for [Effect-TS/effect](https://deepwiki.com/Effect-TS/effect) and [Effect-TS/effect-smol](https://deepwiki.com/Effect-TS/effect-smol) informed the vanilla-TypeScript mapping and cross-domain architecture. Treat it as secondary explanatory material. It can lag an API rename: resolve disagreements through the installed package, pinned source, changelog, and official documentation.

## Reviewed practice

The policy incorporates recurring repository patterns:

- Context services with named semantic operations;
- public operations closed over live requirements;
- `service.ts`, `live.layer.ts`, `memory.layer.ts`, `errors.ts`, and `schemas.ts`;
- Schema-tagged serialisable errors;
- SDK clients private to Layers;
- Effect Platform HttpClient/process/filesystem integration;
- Config/Redacted at the application boundary;
- flat Effect programs and exhaustive Match;
- deterministic test Layers;
- application-owned runtimes;
- Effect logging/tracing/metrics with provider query proof.

## Deliberate corrections to generic guidance

This skill is stricter than generic migration advice:

- raw Promise, fetch, environment, timer, console, mutable collection, and SDK use are confined to named host/provider adapters;
- exporter transport success is not backend ingestion proof;
- a memory Layer is not live provider proof;
- provider typings never replace runtime Schema decoding;
- pure total leaf TypeScript remains valid and should not be wrapped ceremonially.
