---
name: ui-pattern-research
description: |
  Research how production apps implement a UI screen or flow with Mobbin, then write a pattern brief for Framer mocks, prompt conversion, or implementation.
  Use when asked for UI/UX patterns, design references, or how real apps do a flow (settings, empty states, dashboards, tables, checkout, onboarding).
  Also use when create-mock is missing a state the local view does not show.
---

# UI Pattern Research

Search [Mobbin](https://mobbin.com) for real production screens, extract the layout recipe, and write a pattern brief. Do not invent "typical" UI from memory.

Use this before filling gaps in a Framer dashboard mock, before writing a Framer prompt for a known page type, or whenever the user asks how other apps do a flow.

## When not to use this

- `create-mock` already has the local view for the requested state: match that view. Do not restyle it to look like a reference app.
- `convert-prompt` is converting a closed-world spec: do not add patterns the source prompt did not ask for. Research first only when the user asked to design or invent the UI.

## Workflow

### 1. Name the one thing to research

One screen or one journey. Include the product type. Add a UI element only if the task depends on it.

Good: `SaaS app settings page`, `SaaS dashboard empty state`, `SaaS product dashboard with data table`.
Bad: `modern clean dashboard`, `settings with tabs and a danger zone and a toast`.

### 2. Search Mobbin

Use the Mobbin MCP tools. Prefer `web` for this repo's Framer dashboard work; use `ios` when the user asked for mobile.

| Need | Tool |
|------|------|
| A single state (settings, table, empty) | `search_screens` |
| A multi-step journey (onboarding, checkout) | `search_flows` |
| A marketing-page block (pricing, hero, footer) | `search_sections` |

- One query per intent. Split unrelated asks into separate searches.
- Use `mode: "deep"` for screens when the query is a product-type + page-type, not a named app.
- Cap results (`limit` 6–8 for screens, 3–5 for flows) and read the preview images. Do not describe a screen from metadata alone.
- Cite every screen you use as a markdown link to its `mobbin_url`. Do not link `image_url` (it expires). If the result includes `ai_usage_notice`, show that text verbatim after the findings.
- If Mobbin tools are missing or fail, say so and stop. Do not fabricate production examples.

### 3. Write a pattern brief

Keep what repeats across apps. Drop brand, unique copy, and one-off chrome.

```text
Pattern brief:
- Product type:
- Chrome: <nav rail vs labeled sidebar, top-bar contents>
- Page header: <title, subtitle, primary CTA placement>
- Content model: <table, cards, form rows, hub>
- Density: <how sparse data is treated; do not collapse chrome>
- Primary vs secondary actions:
- Overflow / row actions:
- Empty / error / loading:
- Do not copy: <colors, logos, unique copy>
- Apply to: <the missing mock state, Framer frames, or prompt section>
```

### 4. Apply the brief, then stop

- For `create-mock`: use the brief only for states the local view does not show. Keep matching the local layout, color styles, and typography everywhere else.
- For a Framer prompt: translate the brief into native stacks, variants, and overlays. Do not paste Mobbin URLs into the prompt unless the user asked for references.
- For implementation: describe structure and interaction, not pixel copies of the reference apps.
- Report which screens you used and which pattern you applied.

## SaaS dashboard calibration

When the research target is a SaaS dashboard, settings page, table, or empty state, read [examples/saas-dashboard-pattern-brief.md](examples/saas-dashboard-pattern-brief.md) before searching. It is a worked brief from production web apps, not a substitute for a fresh Mobbin search.
