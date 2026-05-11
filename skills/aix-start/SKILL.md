---
name: aix-start
description: >-
  aix development pipeline orchestrator. Start here for new work.
  Runs the full pipeline automatically: explore → plan → code → review → ship.
  Proactively invoked when user says "start development", "begin work",
  "let's build", "new feature", or types /aix-start.
  Do NOT let the user manually route between stages — run the pipeline.
when_to_use: >-
  User says "start", "begin work", "let's develop", "start session",
  "new feature", "let's build", "I want to work on", "implement",
  "我需要开发", "开始", and any message indicating intent to start
  development work. Activated by default when starting work on a project
  that has aix configured. Do NOT wait for user to ask for each step.
allowed-tools: Read Grep Glob Bash Write Edit Agent
---

# aix-start — Development Pipeline

Complete development pipeline: explore → plan → code → review → ship.
Run this once per feature/change. Do NOT ask user to manually route.

## Pipeline

```
[start] ─→ explore ─→ plan ─→ code ─→ review ─→ [commit]
   ↑                                            │
   └──────────────── ship ───────────────────────┘
```

## Flow

Ask the user ONE question: "What are you working on?"
Then run the full pipeline. Do not stop between stages.

---

### Stage 1: Explore

> 探索代码上下文，理解现有实现

Invoke `/aix-explore` in `landscape` mode:

- Learn the project structure from CLAUDE.md
- Explore relevant files based on what the user wants to build
- If user's request is vague, ask 1-2 clarifying questions

**Output**: Clear understanding of:
- What exists today
- Where changes need to be made
- Key files and their relationships

---

### Stage 2: Plan

> 设计方案，用户审批

Based on exploration findings:

1. Present 1-2 design approaches with trade-offs
2. Show specific files that will change
3. User approves → proceed
4. User has concerns → adjust and re-present

**Design must be approved before any code is written.**

---

### Stage 3: Code

> 执行实施

Invoke `/aix-code`:

- Read design decisions from stage 2
- Implement changes file by file
- Run type check after each file
- Run full build after all changes

---

### Stage 4: Review

> 审查代码质量

Invoke `/aix-review`:

- Run automated checks (typecheck, build, conflicts)
- Review diff for architecture compliance
- Show summary to user

---

### Stage 5: Commit / Ship

> 提交流通

Ask user: "Ready to commit?"

- If yes → stage and commit with descriptive message
- If user wants ship (release) → invoke `/aix-ship`

---

## Constraints

- Stage 2 (Plan) requires user approval — never skip
- Stage 3 (Code) requires approved plan — never start coding without it
- Run `npm run typecheck && npm run build` before marking code as done
- Run conflict marker scan before commit
- IPC changes need 3-file sync
