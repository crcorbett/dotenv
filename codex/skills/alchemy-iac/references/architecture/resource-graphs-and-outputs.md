# Resource Graphs and Outputs

## Contents

- [Keep graph construction deterministic](#keep-graph-construction-deterministic)
- [Logical names and physical names](#logical-names-and-physical-names)
- [Dependencies](#dependencies)
- [Outputs are lazy values](#outputs-are-lazy-values)
- [Resources versus Actions](#resources-versus-actions)
- [Return a bounded stack contract](#return-a-bounded-stack-contract)
- [Graph tests](#graph-tests)

## Keep graph construction deterministic

The desired-state graph should depend only on decoded configuration, stage, authority, and explicit prior outputs. Avoid:

- network calls hidden in module initialisation;
- ambient environment reads below the root;
- current wall-clock time in logical names;
- random physical names without a persisted identity;
- ordering based on object key enumeration from unchecked input;
- provider discovery that silently changes desired state.

Represent repeated resources as a typed, stable catalogue. Sort when provider order affects plans or receipts.

## Logical names and physical names

Give every Alchemy resource a stable logical name. Treat physical names as provider identity.

- A logical rename can detach or replace state.
- A physical rename can create a second provider resource.
- Reusing a logical name for a different semantic resource can corrupt reconciliation.

Test both identities. Never derive either from an unvalidated user string.

## Dependencies

Express dependencies through resource Outputs or explicit graph composition. Do not rely on source-file order alone.

Keep dependency direction clear:

```text
decoded config
  -> provider/state Layers
  -> durable resources
  -> scoped credentials/bindings
  -> runtime deployment
  -> dashboards/readback
```

Avoid cycles such as a Worker required to create the state that is required to create that Worker unless the provider documents and tests a bootstrap path.

## Outputs are lazy values

Treat Alchemy Outputs as graph values, not ordinary strings.

- Compose Outputs using the installed Alchemy API.
- Pass them directly to resources that understand Outputs.
- Resolve them only at an explicit application/receipt boundary.
- Do not serialise unresolved Outputs to JSON, logs, workflow outputs, or durable receipts.
- Do not compare an unresolved Output with a primitive.
- Do not hide resolution inside a generic utility.

When a downstream non-Alchemy API requires a primitive, create a named action or boundary that resolves, decodes, uses, and safely records the result.

## Resources versus Actions

Use a **Resource** for durable provider state with lifecycle:

- read;
- diff;
- create/reconcile;
- delete or retain;
- optional list/import/adopt.

Use an **Action** for a bounded operation whose result should rerun when its input changes but which does not represent an independently managed durable object. Examples include credential qualification, provider capacity preflight, or a post-deploy verification query.

Do not use an Action to hide an unmanaged durable resource. Do not force a one-shot diagnostic into a Resource.

## Return a bounded stack contract

Return:

- safe resource IDs;
- URLs;
- dataset or project names;
- stage/source identity;
- verification handles needed by the next explicit step.

Do not return:

- raw provider clients;
- credentials;
- full provider response objects;
- runtime handles;
- state internals;
- unresolved values that a workflow will naïvely JSON-encode.

Define an output Schema when outputs cross a process or workflow boundary.

## Graph tests

Provider-free tests should assert:

- stable logical names;
- stage-isolated physical names;
- expected resource kinds and counts;
- dependency edges;
- removal policies;
- route/binding identity;
- absence of Production resources in proof graphs;
- plan classification;
- safe encoded output.

These tests prove graph policy, not live provider state. Pair them with isolated apply and readback for provider claims.
