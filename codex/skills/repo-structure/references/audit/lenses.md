# Audit lenses

Apply every lens. Use `not_applicable` only with inspected evidence.

| Lens | Required questions | Primary invariant IDs |
|---|---|---|
| Whole job | Is one trajectory accountable through acceptance, delivery, and closure? | `HC-OUTCOME-001` |
| Context and routing | Is each claim owned once and retrievable just in time? | `HC-CTX-001`, `HC-CTX-002` |
| Repository teaching | Do code, types, tests, examples, docs, lint, and skills teach one continuation? | `HC-REPO-001` |
| Domain and boundaries | Are uncertainty, identifiers, config, errors, clients, Effects, packages, and UI owned at the right boundary? | `HC-BOUNDARY-001` |
| Tools | Can capabilities be discovered, invoked, interpreted, recovered, repaired, and verified? | `HC-TOOL-001` |
| Docs and operations | Do document classes, skills, and runbooks own distinct claims? | `HC-DOC-001` |
| Proof and delivery | Does evidence prove the exact artifact, journey, environment, and delivery claim? | `HC-PROOF-001` |
| Authority and safety | Are capability, identity, authority, approval, readback, rollback, and escalation separate? | `HC-AUTH-001` |
| Feedback and controls | Do repeated failures reach the earliest enforceable owner and retire duplication? | `HC-FEEDBACK-001` |
| Dependencies | Are capability, trust, compatibility, upgrade, incident, removal, and replacement obligations owned? | `HC-DEPENDENCY-001` |
| Automation | Are continuous loops settled, observable, bounded, convergent, proved, and recoverable? | `HC-AUTO-001` |
| Evidence and lifecycle | Are non-success states retained without polluting current context? | `HC-EVIDENCE-001` |
| Maintenance | Does every harness element justify its owner, cost, review, retirement, and disconfirming evidence? | `HC-LIFETIME-001` |
| Evaluation | Are worker-effect claims epoch-bound and measured by accepted outcome and human attention? | `HC-EPOCH-001`, `HC-METRIC-001` |

## Fixed implementation surface map

Every finding classifies all of these surfaces:

```text
docs
readmes
architecture_standards
runbooks
proof_evidence
skills
lint_config_ci
spec_tasks
tests_fixtures
config_exports
lifecycle
release_rollback
critical_journeys
```

Each value is `change_required`, `preserve`, or `not_applicable` with evidence.
Unknown is not not-applicable.
