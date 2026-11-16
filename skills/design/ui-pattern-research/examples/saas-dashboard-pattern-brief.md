# SaaS dashboard pattern brief

Worked example from Mobbin web screens. Use it to calibrate dashboard mocks and Framer prompts. Search again for the specific product type and state in front of you; do not copy these apps' brands, colors, or copy.

## Chrome

Production SaaS dashboards keep a persistent left nav and put the page title in the content pane, not in the app top bar.

- Labeled sidebar with the current item filled: [Neon tables](https://mobbin.com/screens/26b08f01-7aad-4ad9-a78e-3a69377b9e33), [Krea usage](https://mobbin.com/screens/2f42de91-7e35-4818-af62-43b5636603b5), [Airwallex products](https://mobbin.com/screens/0298ba5e-60d0-4e60-978e-02e3e4ac3440).
- Icon rail plus a secondary list when the product has many objects: [Webflow products](https://mobbin.com/screens/e814052d-4046-4952-9175-8cb1cea9f09a), [Zoho CRM reports](https://mobbin.com/screens/487bf253-b748-4f93-a322-3e99b508ca35).
- Workspace or org control at the top of the nav; search, help, and avatar on the right of the top bar.
- Primary CTA sits top-right of the content pane (`+ New product`, `+ Add record`), filled; filters and search stay in the table toolbar below the title.

Match the local app's nav density (labeled sidebar vs icon rail). Do not switch chrome models because a reference looks cleaner.

## Tables

The table keeps its header, toolbar, and column labels even when it has one row.

- Toolbar order: view/search, Filters, Columns, overflow, then the add action. See [Neon](https://mobbin.com/screens/26b08f01-7aad-4ad9-a78e-3a69377b9e33) and [Webflow](https://mobbin.com/screens/e814052d-4046-4952-9175-8cb1cea9f09a).
- Column visibility is a checkbox dropdown, not a settings page: [Luma usage](https://mobbin.com/screens/204303b4-16e7-4225-840a-2fb8aa7b8d8a).
- Row actions open an in-row overflow (`Run`, `Edit`, `Clone`, `Delete`), not a page-level menu: [Zoho CRM](https://mobbin.com/screens/487bf253-b748-4f93-a322-3e99b508ca35).
- Sparse data still uses the full table chrome: [Airwallex](https://mobbin.com/screens/0298ba5e-60d0-4e60-978e-02e3e4ac3440) (one product row), [Luma](https://mobbin.com/screens/204303b4-16e7-4225-840a-2fb8aa7b8d8a) (one usage row).

If `create-mock` has the table but not the overflow or column picker, recreate those as variants on the existing table component. Do not replace the local table with a Neon or Webflow layout.

## Settings

Settings is nested IA, not one scrolling form.

- App nav stays. A settings sub-nav lists categories. The pane is stacked rows of label + control + helper text: [ManyChat](https://mobbin.com/screens/c6a092da-d453-4d5a-89e5-870d65f4b563), [Heidi](https://mobbin.com/screens/e4686af6-0384-4fea-912b-35f9a2730f5a).
- Sibling groups inside one category use in-page tabs: [Cloudflare configurations](https://mobbin.com/screens/bb52ee77-63fc-4f79-b032-249efedeb2df), [ElevenLabs workspace](https://mobbin.com/screens/017cddb8-d2d2-4e92-a187-4ead3da9f4eb).
- Toggles for preferences. Buttons for discrete actions (`Change name`, `Enable MFA`). Destructive actions sit at the bottom as quieter outline/ghost controls, often under a danger-zone heading: [ManyChat](https://mobbin.com/screens/c6a092da-d453-4d5a-89e5-870d65f4b563), [Greptile](https://mobbin.com/screens/58bded49-e16d-4e96-aa88-5c3d62e1d321).
- Success is a toast, not an in-form banner: [Greptile](https://mobbin.com/screens/58bded49-e16d-4e96-aa88-5c3d62e1d321).
- Use a card hub only when settings is a map of destinations, not a form: [Intercom](https://mobbin.com/screens/d7cbfa82-f123-44dd-b9e6-813757d6c5de).

Read-only fields need a reason, not just a disabled input: [Heidi](https://mobbin.com/screens/e4686af6-0384-4fea-912b-35f9a2730f5a) (`Why can't I change this?`).

## Empty states

Empty is a body state. The surrounding dashboard chrome stays.

- Title + one-line reason + one primary action and up to two secondary actions, still under the page header and toolbar: [Whop connected accounts](https://mobbin.com/screens/bb43b054-7de7-457e-b8f8-2a6694b4aff3), [AWS dashboard](https://mobbin.com/screens/c14f1b3c-0651-42b0-9d20-929d5eb6a887).
- Choice grid of 2–4 object types when the user must pick what to create first: [Render overview](https://mobbin.com/screens/63958e19-2913-4d0e-85d9-39c9654e106b).
- Sample-content preview when the empty object has a distinctive shape (alert rows, cards): [incident.io escalations](https://mobbin.com/screens/39cdcbd2-4334-4c16-b1ee-ba8c13064ac9).
- First-run marketing landings (`Get started!`, illustrations, demo CTAs) are not list-empty states. [Steep](https://mobbin.com/screens/b026462f-39da-445e-b451-36da6d487c49) is onboarding; do not use it for a filtered-empty table.

If the local app has no empty state captured, add one that keeps the mock's existing sidebar, header, and toolbar, and only replaces the body.
