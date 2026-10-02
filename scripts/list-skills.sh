#!/usr/bin/env bash
set -euo pipefail

# Lists every SKILL.md in each skill source (see skill-sources.sh), including
# in-progress and deprecated skills.

# shellcheck source=scripts/skill-sources.sh
. "$(dirname "$0")/skill-sources.sh"

skill_sources | while IFS= read -r source; do
  echo "# $source"
  (cd "$source" && find skills -name SKILL.md -not -path '*/node_modules/*' | sort)
done
