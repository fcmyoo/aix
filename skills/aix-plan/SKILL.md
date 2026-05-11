---
name: aix-plan
description: >-
  Planning phase: turn ideas into designs and specs. Uses Superpowers
  brainstorming to explore requirements and OpenSpec to formalize.
  DO NOT write code — this phase is about design only.
when_to_use: >-
  User wants to plan a new feature, explore requirements, create a spec,
  or has said "new feature", "plan", "design", "propose".
  Routed here from aix-start.
allowed-tools: Read Grep Bash Write
---

# aix-plan — Planning Phase

Transform user requirements into approved designs and specs. No code allowed.

## HARD-GATE

Do NOT write any code, create any implementation files, or modify source files
during this phase. This is design-only.

## Flow

### 1. Explore Context

- Read `CLAUDE.md` for project rules and architecture
- Read `openspec/config.yaml` for tech stack context
- Check existing code in relevant areas
- Understand what exists before proposing new things

### 2. Brainstorm with User

Invoke `superpowers:brainstorming` skill to:

- Ask clarifying questions (one at a time)
- Explore 2-3 approaches with trade-offs
- Present design section by section
- Get user approval on each section

### 3. Formalize

Based on the approved design, either:

- **For small changes**: Write design to CLAUDE.md or inline
- **For substantial changes**: Create OpenSpec change:
  - `/opsx:propose <change-name>` — generates proposal.md + design.md + tasks.md
  - Or manually write to `openspec/changes/<name>/`

### 4. Handoff

When design is approved, tell the user:

```
Design approved. Ready for implementation phase.
Run /aix-code to start coding, or I'll hand off to the executor.
```

If using dual-runtime with Codex CLI:
- Write plan to `.omx/plans/<change-name>.md`
- Plan file should include: goal, files to modify, approach, acceptance criteria
