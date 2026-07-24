# Repository audit workflow

Use this sequence for every whole-repository harness audit.

## Phase 1: bind the audit

Create `audit-scope.json` from the supplied template. Record the exact target
revision and worktree state, lifecycle phase, claimed jobs, representative
journeys, accepted outcomes, proof boundaries, corpus selections, inspection
and mutation authority, exclusions, non-claims, and stop conditions.

Do not treat an intentionally unbootstrapped scaffold, qualified exception,
deferred provider check, or declared non-claim as a defect unless the default
route misstates it or omits the required transition.

## Phase 2: account for the corpus

Inventory root instructions, repository-local skills, every repository-owned
readable `docs/**` and `README*`, manifests, lock/runtime/tooling config,
workflows, active planning, history, evidence, and representative code. Record
generated, dependency, vendored, binary, cache, inaccessible, and out-of-scope
exclusions.

File counts prove accounting only. Deep-read current, canonical, affected,
contradictory, generated-owner, and evidence-critical material.

## Phase 3: trace whole jobs

For each representative job, follow:

```text
request
  -> routing and current owner
  -> reproduction and boundary model
  -> tool discovery/invocation/recovery
  -> implementation or analysis
  -> claim-matched proof
  -> review/CI/delivery
  -> accepted outcome or explicit terminal state
```

Static inspection supports a structural finding. Execute a journey only when
safe, authorized, and necessary for the claim. Record unrun journeys.

## Phase 4: record findings

Populate `audit-findings.json`. Use stable IDs, fixed priorities, the complete
impact surface map, concrete evidence, earliest correction, duplicated
machinery to retire, proof, authority, limitations, and non-claims. Also record
strong foundations as `preserve` entries.

The human report is a consequence-ordered view over this register.

## Phase 5: accept and hand off

Stop for user acceptance unless implementation was already authorized. Record
each finding as `accepted`, `rejected`, `deferred`, or `optional`. Generate an
accepted-finding crosswalk only from accepted IDs.

Use `prd-writer` to map accepted findings to requirements and tasks,
`prd-review` to reconcile the plan in place, and `prd-implementer` to deliver
small dependency-aware slices. Never implement rejected, deferred, or optional
findings without later explicit acceptance.

## Phase 6: stop proportionally

For ordinary repositories, stop after important accepted corrections, normal
repository checks, affected journeys, and one fresh review. Comparative harness
evaluation is separate work and applies only to a general claim that an
intervention changes future worker behavior.
