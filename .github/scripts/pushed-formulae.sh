#!/usr/bin/env bash

set -euo pipefail

if (($# != 4)); then
  echo "usage: $0 REPOSITORY GITHUB_REPOSITORY BEFORE AFTER" >&2
  exit 2
fi

repository="$1"
github_repository="$2"
before="$3"
after="$4"
tap="$(printf '%s' "$github_repository" | tr '[:upper:]' '[:lower:]' | sed 's#/homebrew-#/#')"

git -C "$repository" rev-parse --git-dir >/dev/null 2>&1 || {
  echo "not a Git repository: $repository" >&2
  exit 2
}
[[ "$before" =~ ^[0-9a-f]{40}$ ]] || {
  echo "invalid before commit: $before" >&2
  exit 2
}
[[ "$after" =~ ^[0-9a-f]{40}$ ]] || {
  echo "invalid after commit: $after" >&2
  exit 2
}

if [[ "$before" == "0000000000000000000000000000000000000000" ]]; then
  before="$(git -C "$repository" mktree </dev/null)"
elif ! git -C "$repository" cat-file -e "$before^{commit}" 2>/dev/null; then
  git -C "$repository" fetch --no-tags --depth=1 origin "$before"
fi
git -C "$repository" cat-file -e "$after^{commit}"

diff="$(git -C "$repository" diff --name-status --no-renames "$before" "$after" -- Formula)"

names_for_status() {
  status="$1"
  awk -F '\t' -v status="$status" -v tap="$tap" '
    $1 == status && $2 ~ /^Formula\/.+\.rb$/ {
      name = $2
      sub(/^Formula\//, "", name)
      sub(/\.rb$/, "", name)
      print tap "/" name
    }
  ' <<< "$diff" | sort -u | paste -sd, -
}

added="$(names_for_status A)"
modified="$(names_for_status M)"
deleted="$(names_for_status D)"
testing="$(printf '%s\n%s\n' "$added" "$modified" | tr ',' '\n' | sed '/^$/d' | sort -u | paste -sd, -)"

if [[ -n "$testing$deleted" ]]; then
  changed=true
else
  changed=false
fi

printf 'changed=%s\n' "$changed"
printf 'testing_formulae=%s\n' "$testing"
printf 'added_formulae=%s\n' "$added"
printf 'deleted_formulae=%s\n' "$deleted"
