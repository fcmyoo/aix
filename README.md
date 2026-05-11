# aix — AI Development Workflow Orchestration

**aix** is a Claude Code skill collection for spec-driven development.
It orchestrates the full development lifecycle: plan → code → review → ship.

## Quick Install

```bash
git clone <repo-url> ~/.aix
cd ~/.aix && bash scripts/install.sh
```

This installs all skills to `~/.claude/skills/aix-*`, making them available
in every Claude Code session.

## Skills

| Skill | Command | Purpose |
|-------|---------|---------|
| aix-init | `/aix-init` | Initialize new project with full toolchain |
| aix-start | `/aix-start` | Daily dev session entry point |
| aix-plan | `/aix-plan` | Planning & design phase |
| aix-code | `/aix-code` | Implementation phase |
| aix-review | `/aix-review` | Code review |
| aix-qa | `/aix-qa` | QA testing |
| aix-cso | `/aix-cso` | Security audit |
| aix-ship | `/aix-ship` | Release management |
| aix-context | `/aix-context` | Save/restore session context |

## New Project Initialization

```bash
# Clone aix
git clone <repo-url> ~/.aix

# Run project init in your project directory
cd /path/to/new-project
bash ~/.aix/scripts/init-project.sh
```

This sets up:
- OpenSpec (4 skills + 4 commands)
- CLAUDE.md with project workflow
- gstack review/qa/ship skills (optional)
- OMX dual-runtime with Codex CLI (optional)
- Utility scripts (conflict marker scanner)

## Workflow

```mermaid
graph LR
    Start[/aix-start] --> Plan[/aix-plan]
    Plan --> Code[/aix-code]
    Code --> Review[/aix-review]
    Review --> QA[/aix-qa]
    QA --> CSO[/aix-cso]
    CSO --> Ship[/aix-ship]
    Ship --> Done((Done))
```

## Prerequisites

- Claude Code (any version)
- `openspec` CLI v1.3+ (`npm install -g openspec`)
- `gstack` (optional, for review/ship: `git clone https://github.com/garrytan/gstack.git ~/.claude/skills/gstack && cd ~/.claude/skills/gstack && ./setup`)
- `codex` CLI (optional, for dual-runtime)

## License

MIT
