# Corpus and journey accounting

## Required corpus groups

Record each group with selection rule, count, inventory artifact, and explicit
exclusions:

1. root agent guidance and skill routes;
2. repository-local skills and compatibility links;
3. root, app, and package READMEs;
4. all repository-owned readable docs;
5. active SPECs, tasks, plans, and decisions;
6. completed, failed, superseded, and inconclusive evidence;
7. manifests, lockfile, workspaces, exports, config, and generators;
8. lint, format, typecheck, test, build, Knip, CI, release, and deployment;
9. runbooks, authority, proof, journeys, feedback, controls, epochs, and
   effectiveness; and
10. representative domain, adapter, service, package, route, and component code.

Exclude dependency, build, cache, binary, vendored, generated-output, and
inaccessible trees by named rule. Generated sources and their generators remain
in scope.

## Deep-read classification

Every deep-read item uses one class:

- `current`;
- `canonical`;
- `affected`;
- `contradictory`;
- `generated_owner`;
- `historical_evidence`; or
- `trajectory_evidence`.

History and collaboration logs may explain repeated steering or failed
handoffs. They never override current repository owners.

## Representative journey selection

Choose a small set spanning the repository's real purpose:

- primary consumer success;
- important validation or error path;
- package/API/SDK integration where applicable;
- browser or UI behavior where applicable;
- provider or operator workflow where applicable; and
- release, deployment, rollback, or recovery where the repository promises it.

Each journey must have an oracle that rejects a plausible false green. Unit
tests are supporting evidence; journeys prove consumer or operator outcomes.
