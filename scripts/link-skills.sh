#!/usr/bin/env bash
set -euo pipefail

REPO="$(cd "$(dirname "$0")/.." && pwd)"
CANONICAL_ROOT="$HOME/.agents/skills"
HOST_ROOTS=("$HOME/.codex/skills" "$HOME/.claude/skills" "$HOME/.cursor/skills")

if [ "$#" -gt 0 ]; then
  HOST_ROOTS=("$@")
fi

install_skill() {
  local source_skill="$1"
  local skill_name
  local canonical_skill

  skill_name="$(basename "$source_skill")"
  canonical_skill="$CANONICAL_ROOT/$skill_name"

  mkdir -p "$CANONICAL_ROOT"

  if [ -L "$canonical_skill" ]; then
    echo "error: canonical skill must be a directory, not a symlink: $canonical_skill" >&2
    exit 1
  elif [ ! -e "$canonical_skill" ]; then
    cp -R "$source_skill" "$canonical_skill"
    echo "installed $skill_name -> $canonical_skill"
  else
    echo "canonical $skill_name already exists at $canonical_skill"
  fi

  for host_root in "${HOST_ROOTS[@]}"; do
    local host_skill="$host_root/$skill_name"
    mkdir -p "$host_root"

    if [ -L "$host_skill" ]; then
      local link_target
      link_target="$(readlink "$host_skill")"
      if [ "$link_target" = "$canonical_skill" ]; then
        echo "linked $host_skill -> $canonical_skill"
        continue
      fi
      rm "$host_skill"
    elif [ -e "$host_skill" ]; then
      echo "error: refusing to replace non-symlink host skill: $host_skill" >&2
      exit 1
    fi

    ln -s "$canonical_skill" "$host_skill"
    echo "linked $host_skill -> $canonical_skill"
  done
}

while IFS= read -r -d '' skill_md; do
  install_skill "$(dirname "$skill_md")"
done < <(
  find "$REPO/skills" -name SKILL.md \
    -not -path '*/node_modules/*' \
    -not -path '*/deprecated/*' \
    -not -path '*/in-progress/*' \
    -print0
)
