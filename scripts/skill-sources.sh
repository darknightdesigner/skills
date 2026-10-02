#!/usr/bin/env bash
# Shared helpers for list-skills.sh and link-skills.sh. Source this file; don't run it.
#
# Skill sources are repo roots that contain a `skills/` directory:
#   - this repo (public)
#   - the private repo, when it's cloned next to this one as `skills-private`
# Set SKILL_SOURCES to a colon-separated list of repo roots to override both.

SKILLS_REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Prints one repo root per line.
skill_sources() {
  if [ -n "${SKILL_SOURCES:-}" ]; then
    printf '%s\n' "$SKILL_SOURCES" | tr ':' '\n' | sed '/^$/d'
    return
  fi

  echo "$SKILLS_REPO"
  if [ -d "$SKILLS_REPO/../skills-private/skills" ]; then
    (cd "$SKILLS_REPO/../skills-private" && pwd)
  fi
}

# Prints the directory of every installable skill (one per line, sorted).
# `deprecated/` and `in-progress/` skills are not installable. Sources without
# a skills/ directory are skipped here; link-skills.sh reports them.
installable_skill_dirs() {
  local source
  skill_sources | while IFS= read -r source; do
    [ -d "$source/skills" ] || continue
    find "$source/skills" -name SKILL.md \
      -not -path '*/node_modules/*' \
      -not -path '*/deprecated/*' \
      -not -path '*/in-progress/*' \
      -exec dirname {} \;
  done | sort
}
