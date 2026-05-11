---
name: aix-ccb
description: >-
  CCB (Claude Codex Bridge) integration layer. Set up multi-agent teams,
  manage Claude ↔ Codex handoff, and coordinate parallel execution.
  Supports aix pipeline stages: hand off execution to Codex, request
  parallel exploration, or set up review workflows.
when_to_use: >-
  User says "ccb", "team", "multi-agent", "handoff", "codex execute",
  "parallel", "agent team", or pipeline reaches execution stage that
  needs Codex CLI. Also trigger when user wants to set up or manage
  CCB team configuration.
allowed-tools: Bash Read Write
---

# aix-ccb — CCB Multi-Agent Team Integration

Integrate CCB (Claude Codex Bridge) into the aix pipeline for
multi-agent collaboration with Claude Code and Codex CLI.

## Prerequisites

CCB requires Python 3.10+ and tmux:

```bash
python3 --version
tmux -V
```

## Install CCB

If CCB is not installed:

```bash
git clone https://github.com/SeemSeam/claude_codex_bridge.git /tmp/ccb
cd /tmp/ccb && bash install.sh install && cd -
rm -rf /tmp/ccb
```

Verify: `ccb --help`

## Team Templates

### Template 1: Full Pipeline Team

For the aix workflow: planner (Claude) → executor (Codex) → reviewer (Claude).

Write this to `.ccb/ccb.config`:

```toml
cmd; planner:claude(worktree), executor:codex(worktree); reviewer:claude(worktree)
```

Usage:
1. `ccb` — start the team in tmux
2. In planner pane: explore and plan the feature
3. `ccb ask executor "Implement the plan in .omx/plans/<name>.md"` — hand off
4. In executor pane: Codex reads and implements
5. `ccb ask reviewer "Review the changes in executor pane"` — request review
6. In reviewer pane: Claude reviews

### Template 2: Parallel Research Team

For exploring multiple angles simultaneously:

```toml
cmd; researcher-1:codex(worktree), researcher-2:codex(worktree), researcher-3:codex(worktree)
```

### Template 3: Simple Codex Executor

Single Codex executor for implementation handoff:

```toml
cmd; executor:codex(worktree)
```

## Integration with aix Pipeline

### Stage 2 (Plan) → Stage 3 (Code) Handoff

When the pipeline reaches implementation and the task is large enough:

1. Write execution plan to `.omx/plans/<feature>.md`
2. Ensure team config is set up (Template 3 or 1)
3. Tell user:

```
Implementation plan ready at .omx/plans/<feature>.md

Option A: Implement directly in Claude Code (/aix-code)
Option B: Hand off to Codex via CCB:
  tmux新开窗口 → cd <project> → ccb
  然后在 executor pane 中运行 Codex
  让其读取 .omx/plans/<feature>.md 并执行
```

### Stage 4 (Review) Handoff

When Codex executor completes and needs review:

```
Option A: Review directly in Claude Code (/aix-review)
Option B: Use CCB reviewer:
  在 reviewer pane 中运行 Claude Code
  让其审查 executor 的变更
```

## CCB Config Generator

For projects initialized with aix, generate `.ccb/ccb.config`:

```bash
mkdir -p .ccb
cat > .ccb/ccb.config << 'EOF'
cmd; planner:claude(worktree), executor:codex(worktree); reviewer:claude(worktree)
EOF
```

This is created during `aix-init --with-ccb`.
