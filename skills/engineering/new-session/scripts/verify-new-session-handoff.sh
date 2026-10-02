#!/usr/bin/env bash
set -euo pipefail

base_ref="${1:-origin/main}"
stable_seconds="${NEW_SESSION_STABLE_SECONDS:-5}"
max_attempts="${NEW_SESSION_CONVERGE_ATTEMPTS:-8}"

branch="$(git branch --show-current)"
if [[ -z "$branch" ]]; then
  echo "error: detached HEAD; expected to be on the new session branch" >&2
  exit 2
fi

upstream="$(git rev-parse --abbrev-ref --symbolic-full-name '@{u}' 2>/dev/null || true)"
if [[ -z "$upstream" ]]; then
  echo "error: current branch has no upstream" >&2
  exit 2
fi

if [[ "$upstream" != origin/* ]]; then
  echo "error: expected upstream under origin, got $upstream" >&2
  exit 2
fi

last_stable_base_sha=""
stable_fetches=0
attempt=1

while (( attempt <= max_attempts )); do
  echo "fetch: git fetch --prune origin"
  git fetch --prune origin

  status_short="$(git status --short)"
  status_branch="$(git status --short --branch)"
  head_sha="$(git rev-parse HEAD)"
  upstream_sha="$(git rev-parse "$upstream")"
  base_sha="$(git rev-parse "$base_ref")"
  local_counts="$(git rev-list --left-right --count "$upstream"...HEAD)"
  branch_base_counts="$(git rev-list --left-right --count "$upstream"..."$base_ref")"
  branch_only="${branch_base_counts%%[[:space:]]*}"
  base_only="${branch_base_counts##*[[:space:]]}"

  echo "attempt: $attempt/$max_attempts"
  echo "branch: $branch"
  echo "upstream: $upstream"
  echo "base: $base_ref"
  echo "status:"
  echo "$status_branch"
  echo "HEAD: $head_sha"
  echo "$upstream: $upstream_sha"
  echo "$base_ref: $base_sha"
  echo "local/upstream counts ($upstream...HEAD): $local_counts"
  echo "remote branch/base counts ($upstream...$base_ref): $branch_base_counts"

  if [[ -n "$status_short" ]]; then
    echo "error: worktree is dirty; refusing to verify a clean new-session handoff" >&2
    git status --short --branch >&2
    exit 1
  fi

  if [[ "$local_counts" != $'0\t0' && "$local_counts" != "0 0" ]]; then
    echo "error: local branch does not match upstream; push or investigate before claiming handoff" >&2
    exit 1
  fi

  if [[ "$branch_base_counts" == $'0\t0' || "$branch_base_counts" == "0 0" ]]; then
    if [[ "$base_sha" == "$last_stable_base_sha" ]]; then
      stable_fetches=$((stable_fetches + 1))
    else
      last_stable_base_sha="$base_sha"
      stable_fetches=1
    fi

    if (( stable_fetches >= 2 )); then
      echo "stable remote-base fetches: $stable_fetches"
      echo "ls-remote proof:"
      git ls-remote --heads origin "refs/heads/main" "refs/heads/$branch"

      if command -v gh >/dev/null 2>&1 && gh auth status -h github.com >/dev/null 2>&1; then
        repo="$(gh repo view --json nameWithOwner --jq .nameWithOwner 2>/dev/null || true)"
        if [[ -n "$repo" ]] && command -v python3 >/dev/null 2>&1; then
          encoded_branch="$(python3 - "$branch" <<'PY'
import sys
from urllib.parse import quote
print(quote(sys.argv[1], safe=""))
PY
)"
          echo "github api proof:"
          gh api "repos/$repo/branches/$encoded_branch" --jq '.name + " " + .commit.sha' || true
        fi
      fi

      echo "new-session handoff verified"
      exit 0
    fi

    echo "remote base is current but not yet stable; sleeping ${stable_seconds}s before final re-fetch"
    sleep "$stable_seconds"
    attempt=$((attempt + 1))
    continue
  fi

  if [[ "$branch_only" == "0" && "$base_only" =~ ^[0-9]+$ && "$base_only" -gt 0 ]]; then
    echo "branch is behind $base_ref by $base_only commits with no unique commits; fast-forwarding"
    git merge --ff-only "$base_ref"
    git push
    last_stable_base_sha=""
    stable_fetches=0
    attempt=$((attempt + 1))
    continue
  fi

  echo "error: branch has unique commits or non-fast-forward divergence from $base_ref; do not silently integrate" >&2
  exit 1
done

echo "error: could not obtain a stable fresh handoff after $max_attempts attempts" >&2
exit 1
