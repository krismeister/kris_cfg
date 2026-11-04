#!/usr/bin/env bash
# Guardrail: scan staged filenames and staged content for secrets.
# Exit 0 = clean (safe to commit), exit 1 = findings (do NOT commit).
#
# The script excludes itself from the content scan, since it necessarily
# contains the detection patterns.
set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"

fail=0
staged="$(git diff --cached --name-only)"

if [ -z "$staged" ]; then
  echo "Nothing staged — nothing to check."
  exit 0
fi

echo "Checking $(echo "$staged" | wc -l) staged file(s)..."

# 1. Sensitive filenames (excluding this script, whose own name matches).
name_hits="$(echo "$staged" | grep -v '^check-secrets.sh$' | grep -Ei 'auth\.json$|trust\.json$|\.pem$|\.key$|(^|/)id_[a-z0-9_]+$|\.env(\.|$)|secret|credential|MEMORY\.md$|\.bak\.' || true)"
if [ -n "$name_hits" ]; then
  echo "BLOCKED — sensitive filename(s) staged:"
  echo "$name_hits" | sed 's/^/  /'
  fail=1
fi

# 2. Secret content in staged diff (excluding this script).
content_hits="$(git diff --cached -U0 -- . ':!check-secrets.sh' | grep -nEi 'PRIVATE KEY|ghp_[A-Za-z0-9]+|gho_[A-Za-z0-9]+|github_pat_[A-Za-z0-9_]+|AKIA[0-9A-Z]+|xox[bpas]-[A-Za-z0-9-]+|sk-(live|test)-[A-Za-z0-9]+|password\s*[:=]\s*\S|passwd|api[_-]?key\s*[:=]\s*\S|secret\s*[:=]\s*\S|token\s*[:=]\s*\S' || true)"
if [ -n "$content_hits" ]; then
  echo "BLOCKED — possible secret(s) in staged content:"
  echo "$content_hits" | sed 's/^/  /'
  fail=1
fi

if [ "$fail" -eq 0 ]; then
  echo "Clean — safe to commit."
fi
exit "$fail"
