# Skills

Minimal agent skills repo.

## Structure

- `skills/engineering/` - code and repo workflows
- `skills/framer/` - Framer workflows
- `skills/productivity/` - general workflow tools
- `skills/misc/` - useful but rarely used tools
- `skills/personal/` - local or personal workflows
- `skills/in-progress/` - drafts
- `skills/deprecated/` - retired skills

## Adding a Skill

Create `skills/<bucket>/<skill-name>/SKILL.md`, then add stable skills to `.claude-plugin/plugin.json`.

User-invoked skills set `disable-model-invocation: true`. Model-invoked skills omit it and use trigger-focused descriptions.
