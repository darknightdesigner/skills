---
name: create-mock
description: Update an existing Framer mock-dashboard component and its subcomponents to match a view in the local codebase. Use when asked to recreate a local app's page, layout, or component inside a Framer dashboard mock or template remix.
---

# Create Mock

Update the existing `mock-dashboard` to match the requested view in the local app, keeping it editable and interactive.

- Use the current repository unless the user names another source. Identify the requested page, layout, or component; ask which view only when unclear.
- Inspect the local rendered view and its relevant source, styles, and interactions. Use the project's documented development or preview workflow when needed. Screenshots are optional supporting references unless the user explicitly makes one the primary reference. If the app cannot be rendered, use available source evidence and report the visual verification limit.
- Connect to the intended Framer project or remix using the official `framer` skill and its current instructions. If that skill is unavailable, run `npx @framer/agent@latest setup`, then read the installed skill. Use the user's destination, not the original template's project URL.
- Find `mock-dashboard` and inspect its actual dependencies, variants, and instances. If the target is missing or ambiguous, clarify before editing. Do not assume a similarly named component is connected.
- Match the local view's layout, proportions, content, colors, and typography as closely as possible. Use existing Framer color styles that best match; preserve their definitions. Adjust typography within the mock as needed. Keep the recreation scoped to the requested view.
- Edit the existing component definition so its instances update. Add, remove, or restructure editable Framer layers and subcomponents as needed; do not replace the mock with a screenshot image.
- Reuse existing Framer components and create missing subcomponents when necessary. Recreate relevant interactions observed in the local app or established by its source, such as menus, tabs, and toggles, without rebuilding backend functionality.
- Keep changes within the mock. If modifying a shared component would affect unrelated website elements, create a mock-specific version.
- Adapt affected desktop and mobile variants using the local app's responsive behavior. Compare the rendered mock with the local view, test affected interactions, and fix visible differences. Report any verification limitations rather than claiming unperformed checks.
- Briefly report what changed and any meaningful approximations. Changing the local source project or publishing requires a separate user request.
