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
[[ "$event" == push || "$event" == pull_request || "$event" == workflow_dispatch ]]
[[ "$before" =~ ^[0-9a-f]{40}$ && "$after" =~ ^[0-9a-f]{40}$ ]]
if [[ "$event" == workflow_dispatch ]]; then
  # The manual workflow validates the current PDF2Zh formula without a version bump.
  changed=Formula/zotero-pdf2zh-next.rb
else
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
fi

# Keep existing coverage for unrelated formulae; add Tier 1 Macs whenever PDF2Zh changes.
legacy='{"os":"macos-14","arch":"arm64"},{"os":"macos-15-intel","arch":"x86_64"},'
tier1=''
if [[ "$changed" == Formula/zotero-pdf2zh-next.rb ]]; then
  legacy=''
fi
if grep -Fxq 'Formula/zotero-pdf2zh-next.rb' <<< "$changed"; then
  tier1='{"os":"macos-15","arch":"arm64","macos":"15"},{"os":"xcode-27","arch":"arm64","macos":"27"},'
fi
printf 'matrix={"include":[%s%s{"os":"macos-26","arch":"arm64","macos":"26"},{"os":"ubuntu-latest","arch":"x86_64","container":{"image":"ghcr.io/homebrew/brew:main","options":"--privileged"}}]}\n' "$legacy" "$tier1"
