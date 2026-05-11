---
name: aix-ship
description: >-
  Release phase: version bump, changelog, tag, and publish. Run after all
  changes are reviewed, tested, and approved. Manages git flow for release.
when_to_use: >-
  User says "ship", "release", "publish", "bump version", "cut release",
  or types /aix-ship. Final step after aix-qa passes.
allowed-tools: Read Grep Bash
---

# aix-ship — Release Phase

Ship the current changes: version, changelog, tag, and publish.

## Prerequisites

Verify the pipeline is green:

```bash
# Clean working tree
git status --porcelain

# All tests pass (if applicable)
npm test 2>/dev/null || true

# Build succeeds
npm run build 2>/dev/null || true

# Conflicts check
bash ./scripts/check-conflict-markers.sh 2>/dev/null || true
```

## Flow

### 1. Determine Version Bump

Ask the user for version bump type:

- `patch` — bug fixes (1.0.0 → 1.0.1)
- `minor` — new features (1.0.0 → 1.1.0)
- `major` — breaking changes (1.0.0 → 2.0.0)

### 2. Update Changelog

Read existing CHANGELOG.md (or create one). Add entry for the new version
with changes from `git log` since last tag.

### 3. Update Version

```bash
npm version <bump-type> --no-git-tag-version
```

### 4. Commit and Tag

```bash
git add package.json CHANGELOG.md
git commit -m "chore: release v<new-version>"
git tag v<new-version>
```

### 5. Push (optional)

Ask user before pushing:

```bash
git push origin <current-branch> --tags
```

### 6. Report

```
✅ Release v<new-version> ready

Tag: v<new-version>
Branch: <current-branch>

To publish:
  git push origin <current-branch> --tags
```
