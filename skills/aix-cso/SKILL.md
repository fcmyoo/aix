---
name: aix-cso
description: >-
  Security audit: scan for secrets, dependency vulnerabilities, and OWASP
  top-10 issues in the codebase. Use before release or when handling
  sensitive data.
when_to_use: >-
  User says "security", "audit", "cso", "vulnerability", "secret scan",
  "owasp", or types /aix-cso. Called before ship or when handling auth/crypto.
allowed-tools: Read Grep Bash
---

# aix-cso — Security Audit

Audit the project for security issues. Must be run before shipping to production.

## Checks

### 1. Secret Scan

```bash
# Check for accidentally committed secrets
grep -rn 'api[Kk]ey\|api_secret\|api[_-]secret\|password\|passwd\|secret\|token' \
  --include='*.ts' --include='*.tsx' --include='*.js' --include='*.json' \
  --exclude-dir=node_modules --exclude-dir=.git --exclude-dir=dist \
  . 2>/dev/null | grep -v 'node_modules\|\.git\|"example\|"test\|sample' | head -30
```

Flag any real secrets found.

### 2. Dependency Audit

```bash
npm audit 2>/dev/null || true
```

Report critical and high vulnerabilities.

### 3. Code Review for OWASP Top-10

Check for:

- **Command injection**: Shell commands with unsanitized user input
- **Path traversal**: File operations with unsanitized paths
- **XSS**: User content rendered without sanitization
- **Insecure deserialization**: `JSON.parse` on untrusted data
- **Sensitive data exposure**: Logging sensitive fields

### 4. Report

```
## Security Audit

Secrets scan: ✅ clean / ⚠️ N items to review
Dependencies: ✅ up to date / ⚠️ N advisories / ❌ N critical
Code review: ✅ clean / ⚠️ N items / ❌ N blockers

Recommendations:
- ...
```
