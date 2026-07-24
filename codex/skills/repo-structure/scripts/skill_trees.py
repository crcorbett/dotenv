#!/usr/bin/env python3
"""Canonical repository-skill tree inventory and comparison."""

from __future__ import annotations

import hashlib
import json
import os
import stat
from pathlib import Path
from typing import Any


REPOSITORY_SKILLS = (
    "docs-maintainer",
    "effect-client-wrapper",
    "package-structure",
    "prd-implementer",
    "prd-review",
    "prd-writer",
)
GENERATED_SKILL_OVERLAYS = {
    "docs-maintainer": ("references/repository-profile.md",),
    "package-structure": ("references/repository-profile.md",),
}
IGNORED_NAMES = {".DS_Store", "__pycache__"}


def is_ignored(path: Path) -> bool:
    return any(part in IGNORED_NAMES for part in path.parts) or path.suffix == ".pyc"


def tree_entries(root: Path, excluded: tuple[str, ...] = ()) -> dict[str, dict[str, Any]]:
    if not root.is_dir() or root.is_symlink():
        raise ValueError(f"skill tree must be a real directory: {root}")
    excluded_paths = set(excluded)
    entries: dict[str, dict[str, Any]] = {}
    for path in sorted(root.rglob("*")):
        relative = path.relative_to(root)
        key = relative.as_posix()
        if is_ignored(relative) or key in excluded_paths:
            continue
        if path.is_symlink():
            entries[key] = {"kind": "symlink", "target": os.readlink(path)}
        elif path.is_file():
            entries[key] = {
                "kind": "file",
                "mode": stat.S_IMODE(path.stat().st_mode),
                "sha256": hashlib.sha256(path.read_bytes()).hexdigest(),
            }
        elif not path.is_dir():
            raise ValueError(f"unsupported skill-tree entry: {path}")
    return entries


def tree_receipt(root: Path, excluded: tuple[str, ...] = ()) -> dict[str, Any]:
    entries = tree_entries(root, excluded)
    encoded = json.dumps(entries, sort_keys=True, separators=(",", ":")).encode()
    return {
        "entryCount": len(entries),
        "treeDigest": hashlib.sha256(encoded).hexdigest(),
    }


def compare_skill_tree(source: Path, rendered: Path, excluded: tuple[str, ...] = ()) -> None:
    expected = tree_entries(source)
    observed = tree_entries(rendered, excluded)
    if observed == expected:
        return
    expected_paths = set(expected)
    observed_paths = set(observed)
    missing = sorted(expected_paths - observed_paths)
    unexpected = sorted(observed_paths - expected_paths)
    changed = sorted(
        path for path in expected_paths & observed_paths if expected[path] != observed[path]
    )
    raise ValueError(
        f"rendered skill differs from canonical source: {rendered.name}; "
        f"missing={missing[:5]}; unexpected={unexpected[:5]}; changed={changed[:5]}"
    )


def baseline_receipt(skills_root: Path) -> dict[str, Any]:
    skills: dict[str, Any] = {}
    for name in REPOSITORY_SKILLS:
        source = skills_root / name
        if not (source / "SKILL.md").is_file():
            raise ValueError(f"missing canonical skill: {source}")
        skills[name] = tree_receipt(source)
    overlays = [
        f".agents/skills/{name}/{relative}"
        for name, paths in GENERATED_SKILL_OVERLAYS.items()
        for relative in paths
    ]
    return {
        "skills": skills,
        "generatedOverlays": sorted(overlays),
        "claudeLinks": {
            name: f"../../.agents/skills/{name}" for name in REPOSITORY_SKILLS
        },
    }
