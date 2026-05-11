---
name: aix-review
description: >-
  Code review phase: review changes before merge. Checks diff quality,
  architecture compliance, security issues, and runs build verification.
  Use after implementation is complete.
when_to_use: >-
  User says "review", "review code", "review PR", "check my changes",
  or types /aix-review. Routed here from aix-code or manually.
  Also auto-triggered when user asks for code quality check.
allowed-tools: Read Grep Bash
---

# aix-review — Code Review Phase

Review uncommitted changes or a specific set of changes before merge.

## Flow

### 1. Gather Context

- Run `git status` and `git diff` to see all changes
- Read the design/spec these changes implement (from `openspec/changes/` or `.omx/plans/`)
- Understand what was supposed to be done

### 2. Automated Checks

Run in order:

```bash
# Type check
npm run typecheck

# Build
npm run build

# Conflict marker scan
bash ./scripts/check-conflict-markers.sh
```

Report any failures immediately.

### 3. Manual Review

Check for:

- **Architecture compliance**: Follows project patterns from CLAUDE.md
- **IPC 3-file sync**: If IPC changes, all 3 files updated
- **CSS variables**: No hardcoded colors (if SCSS project)
- **Process isolation**: No nodeIntegration in renderer
- **Error handling**: Meaningful error messages, no silent failures
- **Security**: No secrets, no command injection vectors, no exposed internal APIs

### 4. Report

Summarize findings:

```
## Review Results

Files changed: N
Checks: ✅ typecheck / ✅ build / ✅ conflicts

Issues found:
- None (clean) / X items (list each)

Overall: ✅ Approve / ⚠️ Minor issues / ❌ Blocking
```
