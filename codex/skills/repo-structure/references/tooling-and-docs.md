# Tooling and documentation

The generated ordered gate is format check, Oxlint, repository policy-rule
tests, development and production Knip, TypeScript, Vitest, then Turbo build.
`tools/oxlint` owns policy rules and
positive/negative fixtures for source-condition order, runtime execution,
generic client escape hatches, Layer root exports, and resolved app/package
workspace boundaries. `repository/no-relative-workspace-imports` rejects a
relative import when its resolved target belongs to another `apps/*` or
`packages/*` workspace. Keep project-specific lint here; the generic
anti-slop plugin must remain portable across single-package and monorepo
repositories.

The TanStack app's `check-types` script invokes Vite once before `tsc` so the
framework generates `routeTree.gen.ts`; generated route output is never stored
as a template.

Documentation must include root/app/package READMEs; architecture pages for
package ownership, Effect services, frontend composition, testing/quality, and
tooling; product-spec and exec-plan indexes; and a portable local
docs-maintainer with its own repository owner/check profile. Validate links,
commands, export paths, metadata, and stale paths—not only presence. The
scaffold also includes one repository harness profile, structured audit
scope/findings/acceptance templates, fixed schemas, a deterministic validator,
and an active bootstrap plan. The profile is the only repository-specific
variation surface; audit reports are views over structured records.

The repository skill baseline copies complete canonical skill folders. A
content-addressed render receipt binds each copied tree while excluding only the
declared generated repository profiles. `.claude/skills/**` entries must be
exact relative links to `.agents/skills/**`; copied mirrors fail validation.

The governance validator checks unique semantic owners, lifecycle and
retirement metadata, local links, critical-journey oracles, automation and
feedback controls, canonical skill-tree digests, Claude links, compatibility
provenance, config digests, lockfile phase, limitations, and non-claims. It also
validates the harness profile. The audit validator enforces target identity,
corpus scope, stable invariant/finding IDs, all impact surfaces, decision
states, and accepted-finding crosswalk integrity.
Receipts are bounded envelopes; detailed output is stored by path/digest rather
than embedded without limit. Failed and inconclusive evidence is preserved
outside default navigation with provenance.

Knip has development and production graphs. CI runs the same ordered gate after
`bun install --frozen-lockfile`; the first generated lockfile is intentionally
created by the user during bootstrap.
