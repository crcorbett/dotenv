# Findings and acceptance

## Finding rules

Every finding includes:

- stable ID and invariant IDs;
- `important_correction` or `optional_improvement`;
- behavior or invariant at risk;
- concrete path/line or artifact evidence;
- current lifecycle phase or accepted local decision;
- earliest semantic owner;
- reason existing proof did not catch the problem;
- root correction and duplicated machinery to retire;
- complete fixed surface map;
- required verification and critical journeys;
- authority or decision required;
- limitations and non-claims; and
- decision state.

Order findings by consequence:

1. data loss, security, authority, release integrity, compatibility, and
   materially false documentation;
2. missing domain ownership, real-system proof, recovery, or operability;
3. recurring incoherence, incomplete migrations, duplicated controls, and
   maintenance burden; then
4. optional ergonomics and polish.

Do not emit maturity scores. Do not split one root cause into many cosmetic
findings. Do not hide an unknown behind `not_applicable`.

## Decision states

| State | Meaning | Implementation eligibility |
|---|---|---|
| `proposed` | Audit finding awaiting user decision | No |
| `accepted` | User accepted the correction and scope | Yes |
| `rejected` | User declined it | No |
| `deferred` | Valid but intentionally postponed with owner/resume trigger | No |
| `optional` | Non-essential improvement retained outside scope | No |

Stable IDs never change when decision state changes.

## Accepted finding crosswalk

Every accepted finding maps to at least one SPEC requirement and one task.
Every task names the owning paths, correction, complete surface impact,
verification, proof, and dependencies. Rejected, deferred, optional, and
unknown IDs must not appear in implementation scope.

When implementation evidence changes a finding, edit the audit register, SPEC,
and task artifact in the same slice. Do not leave the correction only in a
handoff comment.
