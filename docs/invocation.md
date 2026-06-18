# Invocation

Every skill lives in a directory containing `SKILL.md`.

User-invoked skills are only reached when the user names them. Add `disable-model-invocation: true` to their frontmatter and keep descriptions human-facing.

Model-invoked skills may be reached automatically. Omit `disable-model-invocation` and write descriptions with clear trigger phrasing.
