# Skills

Minimal agent skills repo.

Agent-facing repo instructions live in `AGENTS.md`. Tool-specific files should stay thin and point back to that source of truth.

## Structure

- `skills/engineering/` - code and repo workflows
- `skills/framer/` - Framer workflows
- `skills/productivity/` - general workflow tools
- `skills/in-progress/` - drafts
- `skills/deprecated/` - retired skills

## Adding a Skill

Create `skills/<bucket>/<skill-name>/SKILL.md`, then add stable skills to `.claude-plugin/plugin.json`.

User-invoked skills set `disable-model-invocation: true`. Model-invoked skills omit it and use trigger-focused descriptions.

## Install Locally

Run `npm run link` to symlink stable skills into:

- `~/.claude/skills`
- `~/.agents/skills`

Pass explicit destination directories to `scripts/link-skills.sh` to override the defaults.

Cursor adapters live in `adapters/cursor/` and should be copied or symlinked into a target repo's `.cursor/rules/` directory.

## Skills

### Framer

- **[convert-prompt](./skills/framer/convert-prompt/SKILL.md)** - Convert code-oriented prompts into copy-paste-ready native Framer prompts.
