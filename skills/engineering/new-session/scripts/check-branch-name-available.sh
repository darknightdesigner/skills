#!/usr/bin/env bash
set -euo pipefail

# Used names live outside the skill directory, which may be a shared repo.
ledger_root="${NEW_SESSION_USED_BRANCHES_DIR:-${XDG_STATE_HOME:-$HOME/.local/state}/new-session/used-branches}"
history_status_file="${NEW_SESSION_HISTORY_STATUS_FILE:-}"

usage() {
  cat >&2 <<'USAGE'
usage:
  check-branch-name-available.sh <branch-name>
  check-branch-name-available.sh --list
  check-branch-name-available.sh --record <branch-name>
USAGE
}

repo_name_with_owner() {
  if command -v gh >/dev/null 2>&1 && gh auth status -h github.com >/dev/null 2>&1; then
    gh repo view --json nameWithOwner --jq .nameWithOwner 2>/dev/null || true
  fi
}

repo_key() {
  local repo remote_url
  repo="$(repo_name_with_owner)"
  if [[ -n "$repo" ]]; then
    printf '%s' "$repo"
    return
  fi

  remote_url="$(git remote get-url origin 2>/dev/null || true)"
  if [[ -n "$remote_url" ]]; then
    printf '%s' "$remote_url"
    return
  fi

  pwd
}

ledger_file() {
  local key
  key="$(repo_key | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9._-]/_/g')"
  printf '%s/%s.txt' "$ledger_root" "$key"
}

emit_reserved() {
  git for-each-ref --format='%(refname:short)' refs/heads refs/remotes/origin 2>/dev/null \
    | while IFS= read -r ref; do
      [[ -n "$ref" ]] || continue
      ref="${ref#origin/}"
      [[ "$ref" == "HEAD" ]] && continue
      printf '%s\t%s\n' "$ref" "local-or-tracking-ref"
    done

  if git remote get-url origin >/dev/null 2>&1; then
    git ls-remote --heads origin 2>/dev/null \
      | while read -r _ full_ref; do
        branch="${full_ref#refs/heads/}"
        [[ -n "$branch" ]] || continue
        printf '%s\t%s\n' "$branch" "remote-ref"
      done || true
  fi

  local repo pr_refs
  repo="$(repo_name_with_owner)"
  if [[ -n "$repo" ]]; then
    if pr_refs="$(gh api --paginate "repos/$repo/pulls?state=all&per_page=100" --jq '.[] | select(.head.repo.full_name == .base.repo.full_name) | .head.ref' 2>/dev/null)"; then
      if [[ -n "$history_status_file" ]]; then
        printf 'checked\t%s\n' "$repo" > "$history_status_file"
      fi
      printf '%s\n' "$pr_refs" \
        | while IFS= read -r branch; do
          [[ -n "$branch" ]] || continue
          printf '%s\t%s\n' "$branch" "github-pr-head"
        done
    else
      if [[ -n "$history_status_file" ]]; then
        printf 'unavailable\t%s\n' "$repo" > "$history_status_file"
      fi
      echo "warning: unable to read historical GitHub PR heads for $repo" >&2
    fi
  else
    if [[ -n "$history_status_file" ]]; then
      printf 'unavailable\tunknown-repository\n' > "$history_status_file"
    fi
    echo "warning: gh repository context unavailable; historical GitHub PR heads not checked" >&2
  fi

  local ledger
  ledger="$(ledger_file)"
  if [[ -f "$ledger" ]]; then
    while IFS= read -r branch; do
      [[ -n "$branch" ]] || continue
      [[ "$branch" == \#* ]] && continue
      printf '%s\t%s\n' "$branch" "new-session-ledger:$ledger"
    done < "$ledger"
  fi
}

record_branch() {
  local branch ledger
  branch="$1"
  ledger="$(ledger_file)"
  mkdir -p "$(dirname "$ledger")"
  touch "$ledger"

  if grep -Fxq "$branch" "$ledger"; then
    echo "branch already recorded: $branch"
  else
    printf '%s\n' "$branch" >> "$ledger"
    echo "recorded used branch: $branch"
  fi
  echo "ledger: $ledger"
}

print_history_status() {
  local status repo
  [[ -n "$history_status_file" && -f "$history_status_file" ]] || return 0
  IFS=$'\t' read -r status repo < "$history_status_file" || return 0
  if [[ "$status" == "checked" ]]; then
    echo "github-pr-head history: checked for $repo"
  else
    echo "github-pr-head history: unavailable for $repo"
  fi
}

case "${1:-}" in
  "")
    usage
    exit 2
    ;;
  --list)
    emit_reserved | sort -u
    ;;
  --record)
    if [[ $# -ne 2 ]]; then
      usage
      exit 2
    fi
    record_branch "$2"
    ;;
  -*)
    usage
    exit 2
    ;;
  *)
    if [[ $# -ne 1 ]]; then
      usage
      exit 2
    fi

    candidate="$1"
    tmp="$(mktemp "${TMPDIR:-/tmp}/new-session-branches.XXXXXX")"
    status_tmp="$(mktemp "${TMPDIR:-/tmp}/new-session-history.XXXXXX")"
    export NEW_SESSION_HISTORY_STATUS_FILE="$status_tmp"
    history_status_file="$status_tmp"
    trap 'rm -f "$tmp" "$status_tmp"' EXIT
    emit_reserved > "$tmp"

    matches="$(awk -F '\t' -v candidate="$candidate" '$1 == candidate { print $2 }' "$tmp" | sort -u)"
    if [[ -n "$matches" ]]; then
      echo "error: branch name is already reserved: $candidate" >&2
      print_history_status >&2
      echo "sources:" >&2
      echo "$matches" >&2
      exit 1
    fi

    echo "branch name available: $candidate"
    print_history_status
    echo "ledger: $(ledger_file)"
    ;;
esac
