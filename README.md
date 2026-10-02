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

For local development, `npm run link` symlinks every skill outside `in-progress/` and `deprecated/` into `~/.agents/skills`, then links `~/.codex/skills`, `~/.claude/skills`, and `~/.cursor/skills` to those entries. Edits in the repo take effect immediately. Re-run it after adding, removing, or renaming a skill.

The script also picks up a private companion repo cloned next to this one as `skills-private`, or any repo roots listed in `SKILL_SOURCES` (colon-separated). Pass host skill directories as arguments to override the defaults.

Cursor adapters live in `adapters/cursor/` and should be copied or symlinked into a target repo's `.cursor/rules/` directory.

## Skills

### Engineering

- **[new-session](./skills/engineering/new-session/SKILL.md)** - Create and publish a unique branch from the latest `origin/main`.
- **[no-use-effect](./skills/engineering/no-use-effect/SKILL.md)** - Replace direct `useEffect` calls with derived state, event handlers, data fetching, `useMountEffect`, or key resets.
- **[publish-pr](./skills/engineering/publish-pr/SKILL.md)** - Publish a ready-for-review PR and follow through until checks pass and conflicts are resolved.
- **[respond-code-review](./skills/engineering/respond-code-review/SKILL.md)** - Verify PR review feedback before acting, then fix, propose options, or reply.

### Framer

- **[convert-prompt](./skills/framer/convert-prompt/SKILL.md)** - Convert code-oriented prompts into copy-paste-ready native Framer prompts.
- **[sync-styles](./skills/framer/sync-styles/SKILL.md)** - Sync a codebase's named colors, text styles, and used icons into Framer.
- **[create-mock](./skills/framer/create-mock/SKILL.md)** - Update an existing Framer dashboard mock to match a view in the local app.
