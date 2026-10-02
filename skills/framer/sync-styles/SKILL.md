---
name: sync-styles
description: Sync a local codebase's explicitly defined colors, text styles, and icons into a blank or existing Framer project. Use when asked to bring a codebase's design styles into Framer or update a Framer template or remix to match them.
---

# Sync Styles

Recreate the source codebase's reusable design assets as closely as Framer supports. Preserve appearance, light/dark behavior, and editability. Follow the user's requested subset when they only want colors, typography, or icons.

## Establish the source and destination

- Use the current codebase unless the user names another source. Start with global CSS, directly referenced theme/token files, font declarations, and the project's icon library or shared icon wrapper. Follow relevant definitions.
- Connect to the intended Framer project using the official `framer` skill and its current setup instructions. Read the refreshed project context and inspect existing color styles, text styles, fonts, and icon sets.
- Resolve unclear source or destination identity before writing.

## Match the existing project

- Reuse clearly matching assets and update them in place, preserving their IDs, names, folders, and references. Match by name/path and source meaning, not just equal values. Map CSS names naturally, for example `--background` to `background`.
- Create missing assets using the destination's naming conventions. In a blank project, use the source's names, removing CSS syntax such as the leading `--`.
- Leave assets without a clear source counterpart unchanged, including template-specific mockup, shadow, and logo styles. Never delete, merge, or rename assets merely to make the libraries match.
- When a match is ambiguous, leave that item unchanged and report it; continue with clear matches. Read back uncertain write outcomes before retrying so retries do not create duplicates.

## Colors

- Sync colors explicitly named by the source codebase in global CSS or its directly referenced token definitions. Resolve dependencies to obtain their values without importing an entire framework palette. Treat utility aliases such as `--color-background: var(--background)` as mappings to the same source role, not additional styles.
- Preserve each definition's light and dark values, alpha, and color fidelity. Resolve `var(...)`, `color-mix(...)`, and other expressions in the applicable theme and scope using reliable tooling or rendered evidence; do not guess unresolved values or hand-estimate conversions. Avoid reducing wide-gamut colors to hex when Framer can preserve them.
- Preserve distinct semantic names even when their colors match. Do not invent opacity variants or derive existing values from suffixes alone: `primary-90` must follow its actual definition. If the source is single-theme, use its defined appearance without inventing a second theme; report any intentional destination theme override that would be lost.

## Text styles

- Use established source text treatments, following their definitions or representative usages only as needed. Preserve font family and actual weight/style, size, line height, letter spacing, paragraph spacing, color binding, and defined responsive changes. Retain source font features or variable axes when present and supported.
- Verify the required fonts and variants are available; use provided custom font assets when needed. Report missing fonts rather than silently substituting them.
- Preserve meaningful units and resolve their context when conversion is necessary. Keep existing Framer names when the roles clearly match; a source size utility such as `text-4xl` alone does not establish a `heading-1` match.
- Report unsupported fluid sizing or other approximations. Do not invent a new type scale or adjust typography for taste.

## Icons

- Identify the source icon family and variants from imports, local SVGs, and shared wrappers. Include used icons and explicit dynamic selections, not the library's entire catalog.
- Inspect existing Framer sets, exact icon names, and supported controls before adding assets. Reuse matching artwork; otherwise import the exact source SVG as a reusable editable vector when supported.
- Preserve geometry, fill/stroke treatment, color behavior, dimensions, and stroke scaling. Similar names across libraries are not proof of a match. Report unavailable icons instead of silently substituting another family or a Unicode character.

## Verify and report

- Read back created and updated assets to confirm their names, values, theme variants, font settings, and icon mappings. Unchanged inputs should reuse the same assets without producing duplicates.
- Inspect representative rendered samples where available, including both source themes and responsive text where applicable. Wait for fonts to load. Check responsive text in its actual page/component context; saved breakpoint values alone do not prove the result.
- Report what was created, updated, unchanged, or unresolved, with any approximations and verification limits. Keep the report concise.

Creating a style does not apply it to existing elements. Rebinding unmatched page elements, redesigning layouts, changing the source codebase, and publishing require a separate user request.