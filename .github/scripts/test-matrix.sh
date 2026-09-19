#!/usr/bin/env bash
set -euo pipefail

# Run from the checked-out tap. PRs compare against their merge base; pushes
# compare the complete before/after range, including deleted formulae.
if (($# != 3)); then
  echo "usage: $0 EVENT BEFORE AFTER" >&2
  exit 2
fi
event="$1"
before="$2"
after="$3"
[[ "$event" == push || "$event" == pull_request ]]
[[ "$before" =~ ^[0-9a-f]{40}$ && "$after" =~ ^[0-9a-f]{40}$ ]]
if [[ "$before" == 0000000000000000000000000000000000000000 ]]; then
  before="$(git mktree </dev/null)"
else
  if ! git cat-file -e "$before^{commit}" 2>/dev/null; then
    git fetch --no-tags origin "$before"
  fi
  if [[ "$event" == pull_request ]]; then
    before="$(git merge-base "$before" "$after")"
  fi
fi
changed="$(git diff --name-only --no-renames "$before" "$after" -- ':(glob)Formula/**/*.rb' 'Formula/*.rb')"

# Documentation-only changes still keep the existing cross-platform tap checks.
legacy='{"os":"macos-14","arch":"arm64"},{"os":"macos-15-intel","arch":"x86_64"},'
if [[ "$changed" == Formula/zotero-pdf2zh-next.rb ]]; then
  legacy=''
fi
printf 'matrix={"include":[%s{"os":"macos-26","arch":"arm64"},{"os":"ubuntu-latest","arch":"x86_64","container":{"image":"ghcr.io/homebrew/brew:main","options":"--privileged"}}]}\n' "$legacy"
