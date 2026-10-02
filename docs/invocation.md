# Invocation

Every skill lives in a directory containing `SKILL.md`.

User-invoked skills are only reached when the user names them. Add `disable-model-invocation: true` to their frontmatter, add `policy.allow_implicit_invocation: false` to their `agents/openai.yaml`, and keep descriptions human-facing.

Model-invoked skills may be reached automatically. Omit `disable-model-invocation` and the `policy` block, and write descriptions with clear trigger phrasing.

## Codex metadata

Every skill has an `agents/openai.yaml` beside its `SKILL.md` with `interface.display_name` and `interface.short_description` for the Codex skill picker. Keep its `policy` in sync with `disable-model-invocation`: a skill is user-invoked in both harnesses or neither.

```yaml
interface:
  display_name: "Sync Styles"
  short_description: "Sync codebase styles into Framer"
# User-invoked skills only:
policy:
  allow_implicit_invocation: false
```
