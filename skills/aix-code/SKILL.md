---
name: aix-code
description: >-
  Implementation phase: write code following approved designs. Supports TDD,
  subagent-driven parallel development, and dual-runtime handoff to Codex CLI.
  Must have an approved design before starting.
when_to_use: >-
  User says "implement", "write code", "start coding", or has an approved
  design and wants to begin implementation. Routed here from aix-start or aix-plan.
allowed-tools: Read Write Edit Grep Glob Bash
---

# aix-code — Implementation Phase

Write code following approved designs. Design must be approved before starting.

## Prerequisites

Verify there is an approved design:
- Read `openspec/changes/<name>/` for OpenSpec changes
- Read `.omx/plans/<name>.md` for dual-runtime plans
- Ask user for confirmation if no design found

## Implementation

### Option A: Direct Implementation (Claude Code)

For tasks manageable in a single session:

1. Read the approved design/spec
2. Read relevant existing code
3. Implement changes following project conventions in CLAUDE.md
4. Run type checking: `npm run typecheck` (or equivalent)
5. Run build: `npm run build` (or equivalent)
6. Run `bash ./scripts/check-conflict-markers.sh` if available
7. Show diff to user for confirmation

### Option B: Subagent Parallel (Claude Code)

For tasks with 2-5 independent sub-tasks, dispatch subagents:

- Use `superpowers:subagent-driven-development` for parallel execution
- Each subagent gets: specific file list, clear acceptance criteria, context from design

### Option C: Dual-Runtime Handoff (Claude Code → Codex CLI)

For large tasks or tasks needing persistent execution:

1. Write detailed execution plan to `.omx/plans/<name>-exec.md`
2. Plan includes: files, approach, order, verification steps
3. Tell user to run Codex CLI:

```bash
# In Codex CLI session:
$team 3:executor "Execute plan from .omx/plans/<name>-exec.md"
```

4. After Codex finishes, run `/aix-review` to review generated code

## Verification (Mandatory)

Before marking complete, ALL of these must pass:

1. Type check: `npm run typecheck` — exit 0
2. Build: `npm run build` — exit 0
3. Conflict markers: `bash ./scripts/check-conflict-markers.sh` — no markers found
4. User approval on diff
