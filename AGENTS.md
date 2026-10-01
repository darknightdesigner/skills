# Repo Instructions

`AGENTS.md` is the canonical source of truth for this repo's agent-facing instructions. Tool-specific files such as `CLAUDE.md` and Cursor rules should be thin adapters that point back here.

## Structure

Skills are organized under `skills/` by bucket.

Stable skill buckets:

- `engineering/`
- `framer/`
- `productivity/`

Non-stable buckets:

- `in-progress/`
- `deprecated/`

Every skill directory should contain `SKILL.md`. See `docs/invocation.md` for invocation metadata.

## Publishing Rules

Stable skills should be listed in `.claude-plugin/plugin.json` and linked from `README.md`.

Non-stable skills should stay out of `.claude-plugin/plugin.json`, the root `README.md`, and generated/adapted install targets.

Keep reusable skill bodies in `skills/**/SKILL.md`. Do not maintain duplicate full copies in downstream project repos; use shims, symlinks, plugin manifests, or adapter rules that point back to this repo.

## Distribution

- Claude plugin metadata lives in `.claude-plugin/plugin.json`.
- Local installs are handled by `scripts/link-skills.sh`: canonical user copies live under `~/.agents/skills`, and host-specific directories link back to them.
- Cursor adapters live in `adapters/cursor/` and should be copied or symlinked into a target repo's `.cursor/rules/` directory.

Run `npm run list` to list repository skills. Run `npm run link` to seed stable skills into the canonical local `~/.agents/skills` directory and link the default host directories back to it.
