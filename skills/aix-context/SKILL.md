---
name: aix-context
description: >-
  Context management: save current session state for later restoration, or
  restore from a previous save. Use when switching contexts,
  at end of session, or starting a follow-up session.
when_to_use: >-
  User says "save context", "restore context", "save state", "continue later",
  "checkpoint", or types /aix-context. Also useful before handing off to
  another agent or runtime.
allowed-tools: Read Write Grep Bash
---

# aix-context — Context Management

Save or restore session context for continuity across sessions and runtimes.

## Save Context

When the user needs to save their current state:

1. Gather current state:
   - Current branch: `git branch --show-current`
   - Uncommitted changes: `git status --short`
   - Active change context: read `openspec/changes/` or `.omx/plans/`
   - Current task description (ask user)

2. Write to `.aix/context/<timestamp>.md`:

   ```markdown
   # Context Save: <timestamp>
   
   ## Branch
   <branch-name>
   
   ## Uncommitted Changes
   <git status summary>
   
   ## Active Work
   <what user is working on>
   
   ## Next Steps
   <what to do next>
   
   ## Key Decisions
   <decisions made so far>
   ```

3. If using dual-runtime, also sync plan to `.omx/plans/`:

   ```bash
   cp .aix/context/<timestamp>.md .omx/plans/context-<timestamp>.md
   ```

## Restore Context

When the user wants to restore from a previous save:

1. List available saves:

   ```bash
   ls -t .aix/context/ 2>/dev/null || echo "No saved contexts"
   ```

2. Ask user which save to restore (by timestamp or description)

3. Read the save file and present summary:

   ```
   Restoring context from <timestamp>:
   - Branch: <branch>
   - Working on: <active work>
   - Next: <next steps>
   ```

4. Check out the branch and resume
