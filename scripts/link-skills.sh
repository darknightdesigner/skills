#!/usr/bin/env bash
set -euo pipefail

REPO="$(cd "$(dirname "$0")/.." && pwd)"
DESTS=("$HOME/.claude/skills" "$HOME/.agents/skills")

if [ "$#" -gt 0 ]; then
  DESTS=("$@")
fi

resolve_path() {
  realpath "$1" 2>/dev/null || python3 -c 'import os, sys; print(os.path.realpath(sys.argv[1]))' "$1"
}

link_into_dest() {
  local dest="$1"

  if [ -L "$dest" ]; then
    local resolved
    resolved="$(resolve_path "$dest")"
    case "$resolved" in
      "$REPO"|"$REPO"/*)
        echo "error: $dest is a symlink into this repo ($resolved)." >&2
        echo "Remove it and re-run; this script will recreate it as a real directory." >&2
        exit 1
        ;;
    esac
  fi

  mkdir -p "$dest"

  find "$REPO/skills" -name SKILL.md \
    -not -path '*/node_modules/*' \
    -not -path '*/deprecated/*' \
    -not -path '*/in-progress/*' \
    -print0 |
  while IFS= read -r -d '' skill_md; do
    local src name target
    src="$(dirname "$skill_md")"
    name="$(basename "$src")"
    target="$dest/$name"

    if [ -e "$target" ] && [ ! -L "$target" ]; then
      rm -rf "$target"
    fi

    ln -sfn "$src" "$target"
    echo "linked $name -> $src"
  done
}

for dest in "${DESTS[@]}"; do
  link_into_dest "$dest"
done
