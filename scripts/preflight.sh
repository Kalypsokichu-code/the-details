#!/usr/bin/env bash
# Run before every post. Fails if the repo mentions the app's internals or uses
# em/en dashes. Works with both GNU and BSD grep.
set -uo pipefail
cd "$(dirname "$0")/.."

status=0

# Every tracked or new file, minus the ignored ones (so .leakwords never checks itself).
list_files() {
  git ls-files -z --cached --others --exclude-standard
}

# 1. The app's internal names. The patterns live in .leakwords, which is gitignored:
#    publishing the list would publish the names.
if [[ -f .leakwords ]]; then
  patterns=$(grep -v -e '^[[:space:]]*#' -e '^[[:space:]]*$' .leakwords || true)
  if [[ -n "$patterns" ]]; then
    hits=$(list_files | xargs -0 grep -nIE -f <(printf '%s\n' "$patterns") -- 2>/dev/null || true)
    if [[ -n "$hits" ]]; then
      echo "Internal names found:"
      echo "$hits"
      status=1
    fi
  fi
else
  echo "No .leakwords file here, so the internal-name check was skipped."
fi

# 2. No em or en dashes anywhere (house style). Built from bytes so this file stays clean.
em_dash=$(printf '\xe2\x80\x94')
en_dash=$(printf '\xe2\x80\x93')
hits=$(list_files | xargs -0 grep -nI -e "$em_dash" -e "$en_dash" -- 2>/dev/null || true)
if [[ -n "$hits" ]]; then
  echo "Em or en dashes found:"
  echo "$hits"
  status=1
fi

if [[ $status -eq 0 ]]; then
  echo "Preflight passed."
fi
exit $status
