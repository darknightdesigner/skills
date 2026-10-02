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

Every skill directory should contain `SKILL.md` and `agents/openai.yaml` (Codex skill-picker metadata). See `docs/invocation.md` for invocation metadata.

## Publishing Rules

Stable skills should be listed in `.claude-plugin/plugin.json` and linked from `README.md`.

Non-stable skills should stay out of `.claude-plugin/plugin.json`, the root `README.md`, and generated/adapted install targets.

## Private Skills

This repo is public: everything committed here is published. Personal skills that shouldn't be shared live in a separate private repo, `darknightdesigner/skills-private`, cloned next to this one as `skills-private`. It uses the same bucket layout and skill rules, and has no plugin manifest or release setup.

- Never move a private skill into this repo unless the user asks to publish it.
- Skill names must be unique across both repos.
- To publish a private skill, move its directory into a bucket here, then follow the publishing rules above.

Keep reusable skill bodies in `skills/**/SKILL.md`. Do not maintain duplicate full copies in downstream project repos; use shims, symlinks, plugin manifests, or adapter rules that point back to this repo.

## Distribution

- Claude plugin metadata lives in `.claude-plugin/plugin.json`. `.claude-plugin/marketplace.json` makes the repo its own single-plugin marketplace. Run `claude plugin validate . --strict` after touching either manifest.
- Don't edit `version` in `plugin.json` by hand. `npm run version` (run by the release workflow) applies changesets, then `scripts/sync-plugin-version.mjs` copies the `package.json` version into `plugin.json`. `npm run check-plugin-version` reports drift.
- Local installs are handled by `scripts/link-skills.sh`. It symlinks every installable skill (outside `in-progress/` and `deprecated/`) from this repo and, when present, the sibling `skills-private` repo: `~/.agents/skills/<name>` points at the skill's repo directory, and `~/.codex/skills`, `~/.claude/skills`, and `~/.cursor/skills` point at `~/.agents/skills/<name>`. Edits and `git pull` take effect immediately. Set `SKILL_SOURCES` (colon-separated repo roots) to override the sources.
- The link script checks before changing anything: it refuses duplicate skill names and `SKILL.md` files whose frontmatter `name:` is missing or doesn't match the directory. It prunes its own links for removed skills, leaves skills installed by other tools alone, and moves any real directory in the way to `~/.agents/skills-backup/` instead of deleting it.
- Cursor adapters live in `adapters/cursor/` and should be copied or symlinked into a target repo's `.cursor/rules/` directory.

Run `npm run list` to list skills in every source. Run `npm run link` after adding, removing, renaming, or moving a skill in either repo.
