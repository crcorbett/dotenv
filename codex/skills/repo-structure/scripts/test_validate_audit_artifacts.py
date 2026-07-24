#!/usr/bin/env python3
"""Positive and adversarial tests for validate_audit_artifacts.py."""

from __future__ import annotations

import copy
import json
import subprocess
import tempfile
from pathlib import Path


SKILL = Path(__file__).resolve().parent.parent
VALIDATOR = SKILL / "scripts/validate_audit_artifacts.py"
ASSETS = SKILL / "assets/audit"
PROFILE_ASSETS = SKILL.parent / "docs-maintainer/assets/harness"


def load(name: str) -> dict:
    return json.loads((ASSETS / name).read_text())


def run_case(root: Path, scope: dict, findings: dict, crosswalk: dict, profile: dict) -> subprocess.CompletedProcess[str]:
    paths = {}
    for name, value in (
        ("scope", scope),
        ("findings", findings),
        ("crosswalk", crosswalk),
        ("profile", profile),
    ):
        path = root / f"{name}.json"
        path.write_text(json.dumps(value, indent=2) + "\n")
        paths[name] = path
    return subprocess.run(
        [
            "python3",
            str(VALIDATOR),
            "--scope",
            str(paths["scope"]),
            "--findings",
            str(paths["findings"]),
            "--crosswalk",
            str(paths["crosswalk"]),
            "--profile",
            str(paths["profile"]),
        ],
        text=True,
        capture_output=True,
        check=False,
    )


def main() -> None:
    scope = load("audit-scope.template.json")
    findings = load("audit-findings.template.json")
    crosswalk = load("accepted-findings.template.json")
    profile = json.loads((PROFILE_ASSETS / "repository-harness-profile.template.json").read_text())
    findings["findings"][0]["decision"] = "accepted"

    cases: list[tuple[str, dict, dict, dict, dict, bool]] = [
        ("valid", scope, findings, crosswalk, profile, True),
    ]

    wrong_revision = copy.deepcopy(findings)
    wrong_revision["targetRevision"] = "different"
    cases.append(("wrong-revision", scope, wrong_revision, crosswalk, profile, False))

    missing_surface = copy.deepcopy(findings)
    del missing_surface["findings"][0]["surfaces"]["skills"]
    cases.append(("missing-surface", scope, missing_surface, crosswalk, profile, False))

    unexplained_surface = copy.deepcopy(findings)
    unexplained_surface["findings"][0]["surfaces"]["readmes"]["evidence"] = []
    cases.append(("unexplained-na", scope, unexplained_surface, crosswalk, profile, False))

    optional_in_crosswalk = copy.deepcopy(findings)
    optional_in_crosswalk["findings"][0]["decision"] = "optional"
    cases.append(("optional-in-crosswalk", scope, optional_in_crosswalk, crosswalk, profile, False))

    missing_accepted = copy.deepcopy(crosswalk)
    missing_accepted["entries"] = []
    cases.append(("missing-accepted", scope, findings, missing_accepted, profile, False))

    unsafe_mutation = copy.deepcopy(scope)
    unsafe_mutation["authority"]["externalAccess"] = "mutation"
    cases.append(("mutation-without-approval", unsafe_mutation, findings, crosswalk, profile, False))

    incomplete_exception = copy.deepcopy(profile)
    incomplete_exception["exceptions"] = [{"id": "EX-001", "invariantId": "HC-CTX-001"}]
    cases.append(("incomplete-exception", scope, findings, crosswalk, incomplete_exception, False))

    incomplete_owner_map = copy.deepcopy(profile)
    del incomplete_owner_map["owners"]["runbooks"]
    cases.append(("incomplete-owner-map", scope, findings, crosswalk, incomplete_owner_map, False))

    with tempfile.TemporaryDirectory() as temporary:
        root = Path(temporary)
        results = {}
        for name, case_scope, case_findings, case_crosswalk, case_profile, expected in cases:
            result = run_case(root, case_scope, case_findings, case_crosswalk, case_profile)
            passed = result.returncode == 0
            if passed != expected:
                raise AssertionError(f"{name}: expected pass={expected}, got {result.returncode}: {result.stdout}{result.stderr}")
            results[name] = passed

    print(json.dumps({"status": "passed", "cases": results}, sort_keys=True))


if __name__ == "__main__":
    main()
