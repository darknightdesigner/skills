# Skills

[![skills.sh](https://skills.sh/b/darknightdesigner/skills)](https://skills.sh/darknightdesigner/skills)

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

Install the stable skill set through the Skills CLI:

```bash
npx skills add darknightdesigner/skills --skill convert-prompt
```

Or install the stable set as a Claude Code plugin:

```bash
claude plugin marketplace add darknightdesigner/skills
claude plugin install darknightdesigner-skills@darknightdesigner
```

Run `npm run link` to install missing stable skills into the canonical local directory:

- `~/.agents/skills`

The script then links the corresponding entries in `~/.codex/skills`, `~/.claude/skills`, and `~/.cursor/skills` back to the canonical `~/.agents/skills` directories. Existing canonical directories are never overwritten implicitly.

Pass explicit host destination directories to `scripts/link-skills.sh` to override the default host link locations.

Cursor adapters live in `adapters/cursor/` and should be copied or symlinked into a target repo's `.cursor/rules/` directory.

## Skills

### Framer

- **[convert-prompt](./skills/framer/convert-prompt/SKILL.md)** - Convert code-oriented prompts into copy-paste-ready native Framer prompts.
- **[sync-styles](./skills/framer/sync-styles/SKILL.md)** - Sync a codebase's named colors, text styles, and used icons into Framer.
- **[create-mock](./skills/framer/create-mock/SKILL.md)** - Update an existing Framer dashboard mock to match a view in the local app.
