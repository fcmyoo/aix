#!/usr/bin/env bash
# Scans source files for Git conflict markers (<<<<<<<, =======, >>>>>>>)
# Used after stash pop / merge / rebase to verify no artifacts remain
set -e

cd "$(git rev-parse --show-toplevel 2>/dev/null || echo .)"

EXCLUDE_DIRS="--exclude-dir=node_modules --exclude-dir=dist --exclude-dir=dist-electron --exclude-dir=.git --exclude-dir=.omx"
INCLUDE_FILES="--include='*.ts' --include='*.tsx' --include='*.js' --include='*.jsx' --include='*.json' --include='*.scss' --include='*.css' --include='*.md'"

# Find lines starting with <<<<<<< or >>>>>>> (with optional leading whitespace)
LEFT=$(grep -rn '^[[:space:]]*<<<<<<< ' $INCLUDE_FILES $EXCLUDE_DIRS . 2>/dev/null || true)
RIGHT=$(grep -rn '^[[:space:]]*>>>>>>> ' $INCLUDE_FILES $EXCLUDE_DIRS . 2>/dev/null || true)
# Find standalone ======= lines (whitespace-only around =======)
SEP=$(grep -rn '^[[:space:]]*=======$' $INCLUDE_FILES $EXCLUDE_DIRS . 2>/dev/null || true)

RESULT=""
[ -n "$LEFT" ] && RESULT+="$LEFT"$'\n'
[ -n "$RIGHT" ] && RESULT+="$RIGHT"$'\n'
[ -n "$SEP" ] && RESULT+="$SEP"$'\n'

if [ -n "$RESULT" ]; then
  echo "❌ Git conflict markers found:"
  echo "$RESULT"
  exit 1
fi

echo "✅ No Git conflict markers"
