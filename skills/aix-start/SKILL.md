---
name: aix-start
description: >-
  Start a development session with the full aix workflow. Routes to the
  appropriate phase (plan → code → review → ship) based on context.
  This is the primary entry point for daily development work.
when_to_use: >-
  User says "start", "begin work", "let's develop", "start session",
  or types /aix-start at the beginning of a development session.
  Activated by default when starting work on a project that has aix configured.
allowed-tools: Read Grep Bash
---

# aix-start — Development Session Start

Entry point for daily development. Routes to the appropriate aix skill
based on what the user wants to do.

## HARD-GATE: Design before Code

Do NOT write any code until the user has approved a design. This is enforced
regardless of how simple the request seems.

## Routing

Ask the user what they want to do. Based on their response, route to:

| If user wants to... | Route to |
|---|---|
| New feature / change | `/aix-plan` |
| Implement approved plan | `/aix-code` |
| Review code | `/aix-review` |
| QA / test | `/aix-qa` |
| Security audit | `/aix-cso` |
| Release / ship | `/aix-ship` |
| Save session context | `/aix-context` |

## Session Start Protocol

1. Load `CLAUDE.md` from project root for project-specific context
2. Read `openspec/config.yaml` for OpenSpec context (if exists)
3. Check `.omx/plans/` for any active plans (if exists)
4. Check git status for current branch state
5. Ask user what they want to work on
6. Route to appropriate aix skill

## Key Constraints

- Always read `CLAUDE.md` first — it contains project-specific rules
- Never skip planning phase for new features
- Run full build verification before marking work as done
- IPC changes require 3-file sync (main.ts / preload.ts / electron.d.ts)
