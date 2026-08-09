# Cloudflare

## Contents

- [Ownership decisions](#ownership-decisions)
- [File ownership](#file-ownership)
- [Worker and asset semantics](#worker-and-asset-semantics)
- [Routes zones and domains](#routes-zones-and-domains)
- [Bindings and storage](#bindings-and-storage)
- [Secrets](#secrets)
- [Observability](#observability)
- [State](#state)
- [Readback checklist](#readback-checklist)

## Ownership decisions

Declare which system owns each Cloudflare lifecycle:

- Worker or static-asset deployment;
- routes and custom domains;
- DNS/zone configuration;
- R2, D1, KV, Durable Objects, Queues, or Secrets Store;
- environment secrets and bindings;
- logs, metrics, traces, and observability destinations;
- remote state infrastructure.

Do not assume Alchemy owns all Cloudflare resources because it owns one Worker.

## File ownership

For a small graph:

```text
src/lib/build/cloudflare.ts
```

For a substantial graph:

```text
src/lib/build/cloudflare/
  stack.ts
  website.ts
  worker.ts
  storage.ts
  routes.ts
  secrets.ts
  observability.ts
```

Keep stage/config Schemas outside provider declarations when other providers share them.

## Worker and asset semantics

Make asset routing policy explicit. In particular, distinguish asset-first and Worker-first behaviour and test the intended choice. A deployed Worker and green CI do not prove that static assets return the correct content type or bypass the Worker.

Test:

- root document;
- hashed CSS and JavaScript assets;
- missing assets;
- API paths;
- redirects;
- cache headers;
- content types;
- route precedence.

Record compatibility date, compatibility flags, runtime limits, module format, and bundler inputs in a stable typed owner. Keep application and deployment configuration aligned through one contract or an invariant test.

## Routes, zones, and domains

Treat a zone or domain as foreign unless this repository creates and owns it.

- Read the target zone before applying routes.
- Adopt only under explicit authority.
- Default adopted zones and routes to retain.
- Restrict Production route adoption to the Production stage.
- Reject a route whose account/zone does not match the authority record.
- Read back the route pattern and bound Worker after apply.
- Prove the public host independently.

Do not infer route correctness from a Worker URL.

## Bindings and storage

Model each binding as typed desired state:

- binding name;
- resource kind;
- physical resource identity;
- stage/environment;
- creation/adoption policy;
- removal policy.

Assert that application code and deployment configuration use the same binding names. For Durable Objects, include class name, migration/tag policy, and deployment sequencing. For R2/D1/KV, make data retention explicit and default destructive deletion to forbidden until authorised.

## Secrets

Prefer provider-managed secret references or Secrets Store bindings over plaintext workflow values.

- Acquire credentials through redacted Config.
- Validate secret binding names and stage.
- Never emit values in plans, logs, outputs, or receipts.
- Separate credential issuance from resource apply.
- Read back metadata or binding presence, never the secret.
- Revoke disposable credentials after lifecycle proof.

## Observability

Cloudflare platform observability and application telemetry are separate sources.

For Cloudflare-native logs or destinations:

- identify Worker/service/environment/stage;
- define retention and sampling;
- read back the destination/binding;
- query the downstream provider.

For Effect OTLP export:

- keep endpoint/token in a redacted binding;
- decode the binding at application ingress;
- attach one exporter Layer to the runtime;
- preserve `waitUntil` or the host completion mechanism;
- test transport wiring;
- query Axiom independently before claiming ingestion.

## State

If Cloudflare backs Alchemy state, document bootstrap and recovery. Do not create a circular dependency between the state backend and the graph it stores. Use a separate bootstrap stack or a tested provider-supported mechanism where necessary.

## Readback checklist

After apply, query the Cloudflare API for:

- account and zone identity;
- Worker/script/service name;
- deployment/version identifier where available;
- routes/domains;
- bindings and safe resource IDs;
- compatibility settings;
- observability configuration;
- storage resource presence.

Then run the public route/asset journey. Report any unavailable readback as a non-claim.
