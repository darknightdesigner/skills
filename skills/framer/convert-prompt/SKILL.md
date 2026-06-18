---
name: convert-prompt
description: Convert prompts written for custom-coded web stacks such as React, Tailwind, Next.js, Vite, or plain HTML/CSS/JS into copy-paste-ready prompts for a Framer agent. Invoke this skill whenever the user says "convert prompt" (with or without a hyphen) or asks to rewrite, adapt, translate, or convert a code-oriented website, page, section, component, animation, or interaction prompt into native Framer platform instructions while preserving the original design intent, copy, layout, typography, color, motion, interactions, responsive behavior, and constraints.
---

# Convert Prompt

## Purpose

Rewrite a custom-code prompt into a prompt a Framer agent can execute with native Framer concepts. Produce the rewritten prompt, not the build itself, unless the user explicitly asks for implementation.

The exact phrase "convert prompt" is a mandatory trigger for this skill, regardless of capitalization or whether the user writes it as `convert prompt`, `convert-prompt`, or `$convert-prompt`. Load and follow this skill before answering any such request.

The downstream Framer agent may not have access to the current repository, local files, or unstated context. Do not mention local paths, file names, AGENTS.md, private reference documents, or repo-derived assumptions in the rewritten prompt. Translate any useful context into self-contained, source-neutral instructions.

## Core Rules

- Preserve rendered intent, not implementation syntax. Match the requested visual result, content, layout geometry, spacing rhythm, type scale, color roles, animation timing, interaction behavior, and responsive behavior.
- Preserve compound layout behavior before mapping individual classes. If several CSS/Tailwind tokens combine into one rendered result, translate the combined layout formula instead of listing the tokens independently.
- Perform the conversion yourself. Do not leave instructions that ask the downstream Framer agent to translate, convert, adapt, map, or interpret framework-specific syntax, Tailwind classes, React structure, or CSS implementation details that can be converted into Framer-native requirements.
- Avoid redundant destination framing. If the user asked for a Framer prompt conversion, do not include meta-instructions such as "Build this directly in Framer" or "Use native Framer wherever possible" in the final prompt unless the user explicitly asked for that wording.
- Prefer native Framer canvas capabilities over code. Use layers, stacks, grids, components, variants, CMS, overlays, forms, effects, tokens, and style presets before considering code.
- Do not improve or reinterpret the design unless the original prompt asks for that. Keep copy, colors, sizes, timing, constraints, and "do not" instructions intact.
- Treat the source prompt as a closed-world design spec. Do not add visual layers, effects, copy, interactions, accessibility/readability treatments, layout wrappers, decorative elements, or responsive behaviors unless they are explicit in the source, mechanically derived from source syntax, or required as a stated Framer approximation.
- Treat absence as meaningful. If the source defines a layer model and does not include an overlay, tint, gradient, blur, shadow, scrim, decoration, or extra surface, do not add one.
- Be honest about gaps. If Framer cannot match a behavior exactly with native features, state the closest native default and mark the code path as optional.
- For strict recreation, replica, or pixel-match prompts, require a short Framer preflight when exactness depends on proprietary/custom fonts, uploaded assets, or external media. Tell the Framer agent to verify required fonts and attached/trusted assets before building and to pause with blockers if exact resources are missing, unless the user/source explicitly asks to keep momentum with placeholders or fallbacks.
- Keep the result copy-paste-ready for a Framer agent with no surrounding explanation required.

## Output Shape Contract

Preserve the source prompt's shape by default. The conversion should feel like
the same prompt translated for Framer, not a new prompt written from a reusable
template.

Priority order:

1. Follow any output format the user explicitly requests.
2. If the source prompt has clear headings, ordering, bullets, or checklists,
   keep that outline and translate requirements in place.
3. If the source prompt is unstructured or confusing, reorganize only enough to
   make the Framer task executable.
4. Use examples only for conversion mappings and risk awareness. Do not copy an
   example's headings, section order, caveat section, or prose style unless the
   source prompt already calls for that shape.
5. Add a new caveat section only when an important requirement cannot be
   preserved inline. Prefer an inline caveat next to the affected requirement.

## Calibration Reference

For class-heavy React/Tailwind landing-page prompts, especially those with fixed navs, video heroes, responsive typography, hover effects, absolute overlay alignment, or exact typewriter/cursor logic, read [examples/react-tailwind-video-hero.md](examples/react-tailwind-video-hero.md) before converting. It provides conditional source-to-Framer mappings, not a reusable output template.

Do not load the example for simple prompts or unrelated patterns. Keep progressive disclosure: use the reference when it will clarify conversion details or reduce the risk of overpromising Framer-native behavior. The example is not an output template.

## Conversion Workflow

1. Parse the source prompt into setup, layout, typography, colors and surfaces, components, content and data, media, motion, interactions, responsiveness, and explicit constraints.
2. Create a source layout trace before writing the Framer prompt. Capture parent/child hierarchy, normal-flow versus absolute/fixed layers, viewport constraints, stack/grid direction, fill/hug/fixed sizing, sibling distribution, alignment, gaps, padding, transforms, z-order, pointer behavior, media crop/focal positioning, and any derived viewport anchors.
3. Convert the trace into a rendered intent brief. Keep it internal unless the downstream prompt needs the details, but use it to preserve geometry such as visual centers, top offsets, bottom anchors, focal crops, and sibling relationships.
4. Build an internal provenance ledger before writing the final prompt. Classify each intended instruction as `source-explicit`, `source-derived`, `Framer-mechanical`, `approximation/caveat`, or `unbacked addition`. Remove every `unbacked addition`.
5. If the source prompt matches the calibration reference pattern, load the example and use its mappings conservatively.
6. Remove build-stack mechanics such as package installs, framework setup, HTML head tags, CSS reset files, Tailwind config, Vite/Next details, imports, hooks, and DOM implementation details.
7. Identify Framer execution blockers before writing the final prompt: arbitrary third-party CDN images, proprietary fonts, external web-font imports, large asset manifests, strict custom ARIA, and subpixel/fractional precision. For strict recreation or pixel-match sources, add a concise preflight requirement that verifies fonts and attached/trusted assets first and pauses on missing exact resources. For lower-fidelity sources, allow placeholders or fallbacks only when source/user intent permits them and require the Framer agent to report them.
8. Restate each remaining requirement in Framer-native terms using the translation guide below, preserving the source prompt's headings, order, and grouping when they are clear.
9. Replace framework syntax with converted values and Framer-native descriptions before writing the final prompt. The final prompt should not delegate conversion work with phrases like "translate Tailwind styles" or "convert the React layout."
10. Preserve specifics: exact copy, intentional line breaks, colors, sizes, spacing relationships, breakpoints, durations, delays, easing, stagger values, assets, media focal positions, transforms, z-order, and negative constraints.
11. Preserve derived geometry. When source layout math implies a visible anchor, include the target anchor in Framer terms, such as "content visual center around 35% of viewport height" or "footer remains in normal flow at the bottom."
12. Express responsiveness as Desktop, Tablet, and Phone breakpoint behavior instead of CSS media queries or Tailwind prefixes. Use 1200, 810, and 390 widths as defaults when the source prompt does not specify breakpoints.
13. Flag code-only behavior only where needed. Give the native approximation as the default and make the code component or code override path opt-in unless the user explicitly asked for code. Prefer an inline caveat near the affected requirement; add a short caveat section only if inline wording would obscure the prompt.
14. Before returning, perform the downstream prompt boundary check:
   - No local paths, local file names, repo names, or private reference titles.
   - No instructions to read this repository or any local docs.
   - No raw implementation commands, internal IDs, or hidden tool syntax.
   - The prompt makes sense to a Framer agent with no access to this workspace.

## Rendered Intent Brief

For complex visual prompts, derive this brief before writing the final prompt. Do not include the heading "Rendered Intent Brief" in the final output unless it helps the downstream agent.

```text
Rendered intent:
- Viewport model: <100vh/full page/auto page/section height, overflow behavior>
- Layer model: <normal-flow, absolute, fixed, z-order, pointer behavior>
- Primary layout formula: <stack/grid/flex relationships, fill/hug/fixed children>
- Visual anchors: <hero center, nav offset, footer position, card grid bounds>
- Media model: <object fit, focal point, transform/crop, overlay order>
- Responsive changes: <Desktop, Tablet, Phone geometry differences>
- Exactness risks: <features that require approximation or optional code>
```

Use the brief as the source of truth for the Framer prompt. If the final prompt cannot preserve an item, call that out next to the affected requirement with the closest visible target.

## Layout Fidelity Rules

- Treat layout as geometry, not a bag of classes. Preserve the solver behavior that creates the visible result.
- Preserve normal-flow sibling relationships when they affect vertical or horizontal placement. Headers, fill-body regions, and footers often position content indirectly.
- Preserve fill/hug/fixed sizing as part of the parent layout formula. `flex-1`, `h-screen`, `min-h-screen`, `auto`, `fit-content`, and fixed pixel heights change where descendants land.
- Preserve percent transforms with their reference box. CSS `translateY(20%)` is relative to the transformed element's own box, not the viewport or the text inside it.
- Preserve the transformed element. A transform on a video/media layer changes crop/focal framing; a transform on a content wrapper changes the content's visual anchor; a transform on a filled parent can move a large region.
- Preserve `justify-*`, `items-*`, `content-*`, `self-*`, `auto margins`, `space-between`, and gaps as a combined distribution system.
- Preserve absolute/fixed offsets as constraints against their containing frame. Include the containing frame when it is not the viewport.
- Preserve object-fit and object-position/crop decisions. For media-heavy prompts, state both the fill mode and the intended focal region.
- Prefer numeric anchors over taste language when a source layout implies one. Use "about 34-35% from the top of the viewport" instead of "slightly above center" when the source layout supports that precision.
- Do not collapse a high-specificity layout into generic words such as centered, spacious, balanced, high, low, near the top, or near the bottom unless the source itself is that vague.

## Translation Guide

### Project Setup

- HTML entry files, font links, head tags, imports, CSS resets, global CSS, Tailwind config, bundler notes, TypeScript notes, Vite, Next.js, or React setup -> remove them.
- Page title, metadata, description, and social image requests -> Framer page metadata.
- Global design tokens from code -> Framer color tokens, text style presets, link styles, and reusable component styles when reused.

### Layout And Responsive Structure

- Flexbox rows or columns -> Framer stack frames with direction, alignment, distribution, gap, padding, and sizing.
- CSS grid -> Framer grid layout for wrapping card/list layouts and multi-row structures.
- `flex-1`, full width, fill height, or "remaining space" -> fill/flexible sizing in the relevant stack or grid.
- Centered max-width containers -> parent section with centered content frame and max width.
- Responsive padding such as `px-6 md:px-12 lg:px-16` -> per-breakpoint padding overrides for Desktop, Tablet, and Phone.
- Absolute or fixed positioning -> use only for intentional overlap, pinned full-bleed media, decorative layers, or true fixed UI.
- `object-cover` background media -> native image/video layer sized to cover the frame with appropriate cropping and z-order.
- Mobile one-column grids -> convert to vertical stacks when that is more stable and readable in Framer.
- `min-h-screen` or `h-screen` with `flex flex-col` -> a 100vh vertical stack. If children include header/nav, a `flex-1` body, and footer/bottom controls, preserve that three-part structure instead of centering all foreground content in one frame.
- `justify-center` inside a filled region -> center within that filled region, not necessarily within the viewport.
- `justify-between` or distributed children -> preserve the top/middle/bottom or left/center/right distribution explicitly.
- Negative margins and transforms -> convert to explicit visual offsets, and name the affected layer.
- Percent transforms such as `translate-y-[17%]` or `-translate-y-[20%]` -> preserve the percentage and its reference element. If Framer cannot express it directly, provide the equivalent visual anchor.
- Viewport units such as `vh`, `vw`, `dvh`, and `svh` -> preserve viewport-relative sizing and state the intended Desktop, Tablet, and Phone behavior.
- Aspect ratios, min/max widths, fixed dimensions, and whitespace/no-wrap rules -> preserve them when they affect wrapping, cropping, or visible alignment.

### Typography

- Tailwind text sizes or CSS media-query type sizes -> Framer text style presets with per-breakpoint sizes.
- Font weights -> named or numeric Framer font weights when available. Do not invent unsupported weights.
- External web-font imports -> remove the import mechanics and translate them into required font availability. Framer agents cannot rely on arbitrary external web-font URLs from the prompt.
- Proprietary or custom fonts required for exact text metrics -> require preflight verification that the font is already available in the project or uploaded as a custom font. If a strict pixel match depends on that font and it is missing, tell the Framer agent to pause and request the font files instead of substituting a fallback.
- Fallback fonts -> use only as an explicit approximation. Do not claim exact wrapping or pixel match when fallback glyph metrics can change line breaks.
- Letter spacing and line height -> explicit text style values.
- Literal `\n` line breaks -> real line breaks in the Framer text content, not raw escape sequences.
- Per-word color, weight, or emphasis -> rich text runs, preserving inline formatting.
- Text padding -> padding on the containing frame, not on the text layer.
- Links -> rich text links with link style presets when appropriate.

### Color, Effects, And Surfaces

- Tailwind color tokens or CSS variables -> explicit Framer color values, promoted to color tokens when reused.
- Borders -> native borders; if a gradient border is required, approximate with a thin gradient-filled backing frame or state that exact gradient borders may need a code-based approach.
- Glassmorphism or backdrop blur -> translucent fill, background blur, border, and subtle inset/outer shadows.
- Box shadows -> Framer shadow effects, including inset shadows when needed.
- Gradients -> Framer gradient fills.
- Decorative wrappers -> keep transparent unless they need visible surface treatment.

### Motion And Interaction

- Mount or scroll entrance animations, IntersectionObserver, AOS, or hook-driven reveal state -> Framer appear effects triggered on mount or in view.
- Per-character, per-word, or per-line text reveals -> Framer text effects with tokenization and stagger.
- Hover styles -> hover effects, gesture variants, or button/link component states.
- Looping movement, parallax, marquee, ticker, or cursor effects -> native Framer effects when available.
- Tabs, accordions, toggles, menus, drawers, open/close UI, and fixed state sets -> native components with variants and event handlers.
- Modals, dropdowns, popovers, and tooltips -> fixed or relative overlays, wired to the trigger and dismissal behavior.
- Carousels and sliders -> native Carousel/Slideshow components or variant-driven components, depending on the requested behavior.

### Content, Data, CMS, And Forms

- Hardcoded arrays mapped into cards, posts, products, people, events, testimonials, or records -> Framer CMS collection plus collection list by default.
- Small fixed visual groups such as three process steps or bespoke stat cards -> native repeated frames are acceptable when they are structural, not managed records.
- Detail/template pages -> CMS detail page with variable-bound fields and stable slugs.
- Forms -> native form frame, labeled inputs with correct types, and a submit button component instance. Mention integrations only if the source prompt asks for them.
- Runtime validation or submission logic beyond native form behavior -> code escalation note.

### Components, Media, Icons, And Reuse

- Reusable buttons, cards, badges, nav items, FAQ items, or repeated UI -> reuse existing Framer components first; otherwise create native canvas components with variants and editable properties.
- Existing styled elements needing runtime behavior -> prefer a code override over rebuilding as a code component.
- Icons -> Framer-native icon sets or available project icon components. Do not use Unicode symbols as icon substitutes unless requested.
- Arbitrary third-party CDN image URLs -> do not assume they can be applied in Framer. For strict replica or pixel-match prompts, require attached/uploaded image files, an attached asset pack with explicit ordering, or assets from a trusted built-in image-search result before building.
- Large image manifests -> include the mapping needed to place each asset, but prefer "use the attached file matching this filename/layer name" over URL assembly. Full URL tables can help ordering, but they do not make an untrusted external origin usable.
- YouTube, Vimeo, Spotify, maps, audio, iframes, and similar embeds -> matching native or embed component.
- Shared navigation, footer, sidebars, or page chrome -> layout templates rather than duplicating the same layers on each page.

## Code Escalation

Escalate to a code component or code override only when the behavior cannot be represented as native canvas structure, CMS data, variants, overlays, effects, controls, and event handlers.

Code is usually justified for:

- Live timers, clocks, countdowns, polling, or `setInterval`.
- Runtime `fetch`, SDK calls, live external API data, authentication, or browser APIs.
- `localStorage`, persistent state across reloads, clipboard, geolocation, file APIs, or media APIs.
- Complex form validation or submission behavior beyond native forms and integrations.
- Arbitrary drag-and-drop reorder, free-form continuous logic, or custom animation formulas that cannot be represented by Framer effects.

When code is justified, write the Framer prompt so native work remains the default visible implementation. Attach a short inline note to the exact requirement that needs code and name the behavior that requires it. Do not add a global preface such as "If custom code is needed" or a broad instruction to choose between native and code. Do not ask the downstream Framer agent to translate code-stack structure into Framer; provide the converted visible structure yourself, then isolate the code path to the exact runtime behavior.

## Final Prompt Audit

Before returning, read the converted prompt once and fix any issue found by this checklist:

- Replace generic titles such as `# Prompt (Framer version)` with a specific title that names the thing the Framer agent should build or edit.
- Remove framework residue such as package installs, `React`, `Tailwind`, `Next.js`, `Vite`, `motion/react`, `className`, `src/`, `index.html`, CSS variable setup, or import statements, except for a concise note that source mechanics were intentionally dropped when that clarification is useful.
- Remove delegated-conversion language. Banned final-prompt patterns include "translate Tailwind-style sizing/spacing", "convert these classes", "adapt the React structure", "map the CSS to Framer", and any instruction that leaves framework interpretation to the downstream Framer agent.
- Remove redundant destination framing that is already implied by the task, such as "Build this directly in Framer", "Use native Framer wherever possible", or "Use a Framer Code Component if needed" as a standalone preface. Keep only concrete build requirements and inline caveats tied to specific behaviors.
- Remove local workspace leakage such as local paths, repo names, file names, reference document names, AGENTS.md, hidden tool syntax, internal IDs, or instructions to read private context.
- Confirm the prompt is self-contained for a Framer agent with no repository access.
- Confirm each exact source asset, copy string, line break, color, font, size, spacing relationship, breakpoint, animation duration, delay, easing, hover state, and explicit constraint is either preserved or called out near the affected requirement as an approximation.
- For strict recreation, replica, or pixel-match prompts, confirm the final prompt has a concrete preflight when exact fonts or media may not already be trusted/available in Framer.
- Confirm each layout-affecting source token has one of: a direct Framer equivalent, a compound Framer structure preserving the rendered result, or an explicit caveat near the affected requirement with the closest visual target.
- Confirm above-the-fold sections include the important viewport anchors when present: nav/header offset, headline or primary content visual center, footer/bottom control position, media focal region, and overlay order.
- Confirm percent transforms name the reference element and do not become vague placement language.
- Confirm normal-flow header/body/footer relationships are preserved when they affect content placement.
- Confirm responsiveness is expressed as Desktop, Tablet, and Phone behavior instead of CSS media queries or Tailwind prefixes.
- Confirm native Framer implementation is the default, and any code-only behavior is isolated to an optional code component or code override note unless the user explicitly requested exact code behavior.
- Confirm every Tailwind utility, CSS selector/class, React prop, hook, import, package, or build-stack note from the source was either converted into concrete Framer-native requirements or removed as irrelevant setup. Do not leave source syntax for the Framer agent to interpret unless it is exact CSS needed for a stated code-only effect.
- Compare the source prompt's headings and major bullet groups to the output. Any added, removed, or renamed section must be justified by source ambiguity, user instructions, or an unavoidable Framer caveat.
- Confirm no calibration-example sectioning, caveat heading, or prose style leaked into the final output.
- Perform a reverse-delta audit: scan the converted prompt for any instruction that was not in the source prompt. Remove it unless it is a mechanical Framer translation, source-derived geometry, or an explicit approximation/caveat.
- Pay special attention to common embellishments: overlays, scrims, gradients, shadows, blur, texture, decorative shapes, extra sections, extra CTAs, rewritten brand positioning, "premium" styling, readability fixes, accessibility fixes, and hover or animation polish.
- If a best-practice improvement seems useful, do not place it inside the converted prompt. Mention it only outside the prompt under an optional note, and only when the user asked for suggestions.

## Output Guidance

Return one rewritten prompt, not a before/after comparison. Keep the source prompt's design intent, priority, and structure as much as possible after removing framework mechanics.

Use a specific title that helps the Framer agent understand the desired output, such as `# Build the Quiet Video Hero Landing Page` or `# Create the Pricing Page With Interactive FAQ`. Do not use generic titles such as `# Prompt (Framer version)`.

Omit implied setup instructions. Start with the concrete thing to create or edit, then list the converted requirements. Do not tell the Framer agent that the prompt is for Framer, that it should use Framer, or that it should translate source-stack syntax into Framer.

Do not force a fixed section template. If the source prompt already has clear sections, preserve and translate those sections in place. If the source prompt is messy or code-shaped, reorganize only enough to make the Framer implementation clear.

Do not add a standardized notes or caveats section by default. Add one only when a requirement cannot be preserved inline and the caveat materially affects implementation.

When the source contains long QA scripts or verbose validation prose, convert them into a short pass/fail checklist of observable Framer outcomes unless the user explicitly asks to preserve the full test script. Each checklist item should map to one thing the Framer agent can inspect, screenshot, or report.
