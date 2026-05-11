---
name: aix-explore
description: >-
  Global exploration and analysis: trace business call chains across files,
  analyze logs, discover codebase structure, and perform deep investigations.
  Supports four modes: call-chain, landscape, log-scan, and root-cause.
  Leverages omx-chain for internal exploration and !omx explore for Codex CLI
  external parallel search.
when_to_use: >-
  User says "explore", "trace", "call chain", "how does this work",
  "full flow", "analyze logs", "find the bug", "investigate",
  "understand the code", "链路", "调用链", "日志分析", "根因".
  Routed from aix-plan or aix-start when investigation is needed.
allowed-tools: Read Grep Glob Bash Write Agent
---

# aix-explore — Global Exploration & Analysis

Explore codebase structure, trace call chains, analyze logs, and
investigate root causes. Supports both Claude Code internal search and
Codex CLI external parallel search.

## Mode Selection

Start by asking what the user needs. Based on response, select mode:

| Mode | What it answers | When to use |
|------|----------------|-------------|
| **call-chain** | "这个功能的完整调用链是什么？" | 业务流程理解、跨文件追踪 |
| **landscape** | "这个模块的整体结构是怎样的？" | 新项目上手、模块重构前 |
| **log-scan** | "日志里有什么异常？" | 错误排查、性能问题 |
| **root-cause** | "这个 bug 的根因是什么？" | 缺陷调查 |
| **external** | 用 Codex CLI 批量搜索 | 大规模并行搜索 |

---

## Mode: call-chain — 业务链路追踪

Traces a business feature end-to-end: UI entry → service → data layer.

### Flow

1. **Identify entry point**: Ask user which feature/business flow to trace
2. **Forward trace**: From UI component → event handler → service → data access
3. **Reverse trace**: From data/error → callers back to entry
4. **Map dependencies**: External APIs, workers, IPC channels, database tables
5. **Report**: Visual call chain with file:line references

### Techniques

```bash
# Trace function callers (reverse)
grep -rn "functionName\|targetMethod" --include='*.ts' --exclude-dir=node_modules .

# Trace IPC channels
grep -rn "ipcMain.handle\|ipcRenderer.invoke" --include='*.ts' --exclude-dir=node_modules .

# Trace imports
grep -rn "from '@/services/xxx'" --include='*.ts' --exclude-dir=node_modules .
```

Use `Agent(Explore, model="haiku")` for parallel search branches.

### Output

```
## Call Chain: <功能名>

UI:   src/pages/X.tsx:42 → Component → Event
       │
IPC:  electron/preload.ts:10 → channel:xxx:yyy
       │
Main: electron/main.ts:300 → ipcMain.handle('xxx:yyy')
       │
Svc:  electron/services/xxxService.ts:150 → process()
       │
DB:   electron/services/dbService.ts:80 → query()
```

---

## Mode: landscape — 代码全景

Understand a module's structure, key functions, and data flow.

```bash
# Module file tree
find electron/services -name '*.ts' | sort

# Key exports
grep -rn "^export " electron/services/xxxService.ts

# Test coverage
find . -name '*.test.*' -path '*/xxx*' | head -10
```

Use `omx-chain research` for deeper structural analysis if needed.

---

## Mode: log-scan — 日志分析

Analyze application logs for errors, warnings, and patterns.

### Flow

1. **Locate logs**: Ask user where logs are stored, or search common paths
2. **Scan for errors**: `grep -n "ERROR\|Error\|error\|FATAL\|fatal\|trace\|warning" <log-dir>/*.log`
3. **Cluster patterns**: Group similar errors, count frequencies
4. **Timeline**: Identify temporal patterns (spikes, recurring intervals)
5. **Correlate**: Match error timestamps with known events (deploys, config changes)
6. **Report**: Error summary + frequency + likely causes

```
## Log Analysis: <time-range>

### Error Summary
| Level | Count | Pattern |
|-------|-------|---------|
| ERROR | 23    | DB connection timeout |
| WARN  | 45    | Rate limit approaching |
| FATAL | 2     | OOM killed |

### Top Errors
1. `2026-05-11 10:23:45 ERROR [DB] timeout after 30s` (×12)
   - Possible cause: connection pool exhausted during batch job

### Recommendation
- Increase pool size or stagger batch processing
```

---

## Mode: root-cause — 根因调查

Investigate a bug from symptom to root cause.

### Flow

1. **Symptom confirmation**: What exactly is the observed failure?
2. **Hypothesis generation**: Generate 3 possible root causes
3. **Evidence collection**: Search code for each hypothesis
4. **Elimination**: Rule out hypotheses with contradictory evidence
5. **Root cause identification**: Converge on most likely cause
6. **Fix suggestion**: Minimal change to fix + verification steps

Use `omx-chain deep` for the evidence collection phase if search is complex.

```
## Root Cause Analysis

### Symptom
<observed failure>

### Hypotheses
1. ❌ <hypothesis A> — eliminated because <evidence>
2. ✅ <hypothesis B> — confirmed by <evidence>
3. ❌ <hypothesis C> — eliminated because <evidence>

### Root Cause
<file>:<line> — <explanation>

### Fix
<minimal change description>

### Verification
<how to confirm the fix works>
```

---

## Mode: external — Codex CLI 并行探索

For large-scale search that benefits from Codex CLI's parallel execution.

### Trigger conditions

- Search spans >10 files or >3 directories
- Need pattern matching across the entire codebase
- Need worker isolation (git worktree)
- Current session has limited context budget

### Execution

```bash
# Construct the exploration prompt
!omx explore --prompt "...
Analyze the following in <project-name>:
1. How does <feature> work end-to-end?
2. Find all files related to <topic>
3. List all callers of <function>
4. Identify potential issues in <area>

Search in: <dirs>
Output format: file:line references with code snippets
..."
```

After Codex CLI completes, read the result file and analyze in Claude Code:

```bash
cat .omx/explore-latest.md
```

Then synthesize findings into the standard aix-explore report format.

### Handoff

If the exploration result needs deeper analysis, route to `omx-chain deep` with
the Codex findings as input context.
