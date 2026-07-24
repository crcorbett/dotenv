# Repository variation and stopping

Load the repository harness profile before classifying deviations.

## Valid variation

Paths, commands, jobs, journeys, environments, providers, release models,
lifecycle phase, exclusions, and qualified exceptions may differ. The profile
must name the narrower replacement, evidence, owner, review trigger, and
retirement condition.

Existing behavior alone is not evidence that a variation is valid. A
repository-specific convention must still preserve the shared invariant.

## Invalid variation

Do not vary:

- semantic owner and truth precedence;
- finding priorities or decision states;
- impact surface categories;
- authority and approval separation;
- claim-to-proof and artifact identity;
- failed-work retention;
- accepted-finding handoff;
- feedback and automation admission; or
- proportional stopping.

## Stop conditions

Stop and report the smallest unresolved decision when:

- the target revision or worktree identity cannot be established;
- current owners conflict and evidence cannot resolve authority;
- a required generated owner or real command is unknown;
- a consequential claim crosses ungranted provider or mutation authority;
- proof would expose secrets or cross an unapproved environment;
- a runbook lacks rollback or escalation;
- corpus accounting is materially incomplete; or
- the repository profile claims an exception without its required evidence and
  owner.

Do not keep auditing indefinitely. Once important findings are evidenced,
prioritized, and acceptance-ready, optional breadth belongs in the optional
register.
