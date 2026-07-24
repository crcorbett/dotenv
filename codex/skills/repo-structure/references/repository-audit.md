# Repository audit

This compatibility entrypoint routes to the structured audit contract under
[`audit/`](audit/workflow.md). Read the sibling
[`repository harness contract`](../../docs-maintainer/references/repository-harness-contract.md)
first. Both contracts are local and require no external methodology lookup.

For every whole-repository audit, load:

1. [`workflow.md`](audit/workflow.md);
2. [`corpus-and-journeys.md`](audit/corpus-and-journeys.md);
3. [`lenses.md`](audit/lenses.md);
4. [`findings-and-acceptance.md`](audit/findings-and-acceptance.md); and
5. [`variation-and-stopping.md`](audit/variation-and-stopping.md).

Start from the JSON templates under `assets/audit/`:

- `audit-scope.template.json`;
- `audit-findings.template.json`; and
- `accepted-findings.template.json`.

Validate them with:

```bash
python3 scripts/validate_audit_artifacts.py \
  --scope /path/to/audit-scope.json \
  --findings /path/to/audit-findings.json \
  --crosswalk /path/to/accepted-findings.json \
  --profile /path/to/repository-harness-profile.json
```

The human report is a consequence-ordered projection of the structured
findings. It must not become a competing owner.
