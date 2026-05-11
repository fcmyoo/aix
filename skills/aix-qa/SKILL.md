---
name: aix-qa
description: >-
  QA testing phase: run tests, verify functionality, and check for regressions.
  Use after code review passes. Supports both automated and manual testing.
when_to_use: >-
  User says "qa", "test", "run tests", "verify", "check for regressions",
  or types /aix-qa. Routed from aix-review or called manually before ship.
allowed-tools: Read Grep Bash
---

# aix-qa — QA Testing Phase

Verify changes work correctly and don't break existing functionality.

## Flow

### 1. Automated Tests

Run existing test suite:

```bash
npm test 2>/dev/null || npm run test 2>/dev/null || echo "No test script found"
```

Check for any existing test files:

```bash
find . -name "*.test.*" -o -name "*.spec.*" -o -name "__tests__" 2>/dev/null | grep -v node_modules | head -20
```

### 2. Build Verification

```bash
npm run build
```

Verify the build completes without errors.

### 3. Manual Test Checklist

Based on the changes, create a checklist for the user:

- Golden path: main use case works
- Edge cases: empty state, error state, boundary values
- Cross-browser/platform: if relevant
- Performance: if relevant to the change

### 4. Report

```
## QA Results

Tests: ✅ passed / ⚠️ N skipped / ❌ N failed
Build: ✅ / ❌
Manual checklist:
  - [ ] Item 1
  - [ ] Item 2

Overall: ✅ Pass / ⚠️ Minor / ❌ Fail
```
