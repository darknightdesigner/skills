#!/usr/bin/env bash
set -euo pipefail

# Links every installable skill from the skill sources (this repo, plus the
# private repo when present; see skill-sources.sh) into the local harness
# skill directories:
#
#   ~/.agents/skills/<name>        -> <repo>/skills/<bucket>/<name>
#   <host>/skills/<name>           -> ~/.agents/skills/<name>
#
# Everything is a symlink back into the repos, so edits and `git pull` take
# effect immediately. Re-run after adding, removing, renaming, or moving a
# skill: links for skills that no longer exist are pruned.
#
# Pass host skill directories as arguments to override the defaults.
# Entries in these directories that don't belong to a skill source (skills
# installed by other tools) are never touched. A real directory that's in the
# way of one of our links is moved to ~/.agents/skills-backup/, not deleted.

# shellcheck source=scripts/skill-sources.sh
. "$(dirname "$0")/skill-sources.sh"

CANONICAL_ROOT="$HOME/.agents/skills"
BACKUP_ROOT="$HOME/.agents/skills-backup/$(date +%Y%m%d-%H%M%S)"
HOST_ROOTS=("$HOME/.codex/skills" "$HOME/.claude/skills" "$HOME/.cursor/skills")

if [ "$#" -gt 0 ]; then
  HOST_ROOTS=("$@")
fi

sources=()
while IFS= read -r source; do
  sources+=("$source")
done < <(skill_sources)

skill_dirs=()
while IFS= read -r dir; do
  skill_dirs+=("$dir")
done < <(installable_skill_dirs)

if [ "${#skill_dirs[@]}" -eq 0 ]; then
  echo "error: no installable skills found in: ${sources[*]}" >&2
  exit 1
fi

# Check everything before changing anything.
problems=0

duplicates="$(for dir in "${skill_dirs[@]}"; do basename "$dir"; done | sort | uniq -d)"
if [ -n "$duplicates" ]; then
  for name in $duplicates; do
    echo "error: skill name '$name' exists in more than one place:" >&2
    for dir in "${skill_dirs[@]}"; do
      if [ "$(basename "$dir")" = "$name" ]; then
        echo "  $dir" >&2
      fi
    done
  done
  problems=1
fi

for source in "${sources[@]}"; do
  if [ ! -d "$source/skills" ]; then
    echo "error: skill source has no skills/ directory: $source" >&2
    problems=1
  fi
done

for dir in "${skill_dirs[@]}"; do
  name="$(basename "$dir")"
  # The `name:` value from a frontmatter block that opens on line 1 and closes
  # with `---`. Empty when the frontmatter is missing, unclosed, or has no name.
  frontmatter_name="$(awk '
    NR == 1 { if ($0 != "---") exit; next }
    /^---$/ { if (value != "") print value; exit }
    /^name:/ { value = $0; sub(/^name:[ \t]*/, "", value) }
  ' "$dir/SKILL.md")"
  if [ -z "$frontmatter_name" ]; then
    echo "error: $dir/SKILL.md needs frontmatter (between --- lines) with a name:" >&2
    problems=1
  elif [ "$frontmatter_name" != "$name" ]; then
    echo "error: $dir/SKILL.md has name: $frontmatter_name, but its directory is $name" >&2
    problems=1
  fi
done

for dest in "$CANONICAL_ROOT" "${HOST_ROOTS[@]}"; do
  # If a destination is itself a symlink into a skill source, writing links
  # into it would pollute that repo's working copy.
  if [ -L "$dest" ]; then
    resolved="$(readlink -f "$dest")"
    for source in "${sources[@]}"; do
      case "$resolved" in
        "$source" | "$source"/*)
          echo "error: $dest is a symlink into $source. Remove it and re-run." >&2
          problems=1
          ;;
      esac
    done
  fi
done

if [ "$problems" -ne 0 ]; then
  echo "Nothing was changed." >&2
  exit 1
fi

# Moves a real file or directory out of the way of a link.
back_up() {
  local path="$1"
  local backup="$BACKUP_ROOT/${path#"$HOME"/}"
  mkdir -p "$(dirname "$backup")"
  mv "$path" "$backup"
  echo "backed up $path -> $backup"
}

# Creates or updates the symlink $1 -> $2.
link() {
  local path="$1" target="$2"

  if [ -L "$path" ]; then
    if [ "$(readlink "$path")" = "$target" ]; then
      echo "ok      $path"
      return
    fi
    rm "$path"
  elif [ -e "$path" ]; then
    back_up "$path"
  fi

  ln -s "$target" "$path"
  echo "linked  $path -> $target"
}

# True when $1 points into a skill source or into the canonical root, i.e.
# the link was made by this script.
is_our_link() {
  local target
  target="$(readlink "$1")"
  for source in "${sources[@]}"; do
    case "$target" in "$source"/*) return 0 ;; esac
  done
  case "$target" in "$CANONICAL_ROOT"/*) return 0 ;; esac
  return 1
}

# Removes our links in $1 whose target no longer exists.
prune() {
  local root="$1" path
  [ -d "$root" ] || return 0
  for path in "$root"/*; do
    if [ -L "$path" ] && [ ! -e "$path" ] && is_our_link "$path"; then
      rm "$path"
      echo "pruned  $path"
    fi
  done
}

mkdir -p "$CANONICAL_ROOT"
for dir in "${skill_dirs[@]}"; do
  link "$CANONICAL_ROOT/$(basename "$dir")" "$dir"
done
prune "$CANONICAL_ROOT"

for host_root in "${HOST_ROOTS[@]}"; do
  mkdir -p "$host_root"
  for dir in "${skill_dirs[@]}"; do
    name="$(basename "$dir")"
    link "$host_root/$name" "$CANONICAL_ROOT/$name"
  done
  prune "$host_root"
done

echo "Linked ${#skill_dirs[@]} skills from: ${sources[*]}"
