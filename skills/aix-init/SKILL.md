---
name: aix-init
description: >-
  Initialize a new project with the full aix toolchain: OpenSpec, Superpowers,
  gstack, and Codex CLI/OMX. Run this when starting a brand new project to set
  up spec-driven development workflow, CLAUDE.md, and all project-level skills.
when_to_use: >-
  User says "init project", "new project setup", "initialize toolchain",
  "setup workflow", or types /aix-init in a fresh project directory.
  Requires an existing git repository and npm/node project.
allowed-tools: Bash Read Write
---

# aix-init — New Project Initialization

Initialize the current project with the full aix development workflow toolchain.

## Prerequisites

Verify before starting (run `which openspec git codex`):
- `openspec` CLI (v1.3+)
- `git` (any version)
- `codex` CLI (optional, for dual-runtime mode)
- `gstack` installed at `~/.claude/skills/gstack/bin/` (optional, for review/ship workflow)

## Steps

### 1. Run `openspec init`

```bash
openspec init --tools claude .
```

This generates `.claude/skills/openspec-*` (4 skills), `.claude/commands/opsx/` (4 slash commands), and `openspec/` directory structure.

### 2. Create CLAUDE.md

Check if `openspec init` already generated a CLAUDE.md. If not, read the aix
template at `{{aix_dir}}/template/CLAUDE.md` and render it into `./CLAUDE.md`.

Collect project info interactively:
- Project name
- Description (one line)
- Dev command (e.g., `npm run dev`)
- Build command (e.g., `npm run build`)
- Test command (e.g., `npm run test`)
- Tech stack (e.g., React + Express + PostgreSQL)

Replace `{{placeholders}}` in the template before writing.

### 3. Register gstack (optional)

```bash
cd ~/.claude/skills/gstack && ./bin/gstack-team-init optional 2>/dev/null || true
cd -
```

This appends gstack section to CLAUDE.md.

### 4. Set up OMX directory (optional, for Codex CLI dual-runtime)

```bash
mkdir -p .omx/{plans,team,state,runtime,logs}
```

### 5. Copy reusable scripts

```bash
cp {{aix_dir}}/scripts/*.sh scripts/
chmod +x scripts/*.sh
```

Add to `package.json` scripts:

```json
"check:conflicts": "bash ./scripts/check-conflict-markers.sh"
```

### 6. Summary

Print the following for the user:

```
✅ aix toolchain initialized for <project-name>

Installed:
  - OpenSpec: 4 skills + 4 commands
  - CLAUDE.md: project workflow guide
  - gstack: review/qa/ship workflow (optional)
  - OMX: Codex dual-runtime (optional)
  - scripts/check-conflict-markers.sh

Next steps:
  - Edit CLAUDE.md with project-specific architecture constraints
  - Start development: /aix-start
  - Propose a change: /opsx:propose "feature name"
```
