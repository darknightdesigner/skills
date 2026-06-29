# React/Tailwind to Framer Conversion Reference

Use this reference when converting code-oriented React or Tailwind prompts into concrete Framer instructions. It covers anti-pattern phrasing, utility-to-Framer mappings, layout and viewport geometry, media layers, and motion behavior. Apply a row only when the source prompt contains the matching source detail; do not infer missing layers, effects, sections, copy, motion, or styling from this reference.

## Anti-Patterns To Avoid

| Bad final-prompt wording | Better conversion |
| --- | --- |
| "Build this directly in Framer." | Omit it when the user already asked for a Framer conversion. Start with the concrete section/page to create. |
| "Use native Framer layout/styling wherever possible." | Replace with specific converted structure: vertical 100vh stack, nav at top, fill-height hero body, footer at bottom, full-bleed video behind content. |
| "Translate Tailwind-style sizing/spacing into equivalent Framer styles." | Perform the translation: 24px horizontal padding, 48px bottom padding, max width about 1024px, max content width about 576px, 16px gap, white at 80% opacity. |
| "If custom code is needed, use a Code Component for the background video fade behavior and CSS glass effects." | Attach code notes only to exact behaviors: the 500ms requestAnimationFrame video fade loop likely needs a code component; the glass border may need a code-based mask if native layered frames cannot reproduce it exactly. |

## Reliable Class And Instruction Conversions

| Source detail | Framer conversion | Safe convention |
| --- | --- | --- |
| `fixed top-6 left-1/2 -translate-x-1/2 w-[95%] max-w-5xl z-50` | Fixed navbar frame, about 24px from top, horizontally centered, 95% width, max width about 1024px, above hero content. | Tailwind spacing `top-6` maps reliably to about 24px. `max-w-5xl` maps to about 1024px. |
| Outer `pointer-events-none` plus inner `pointer-events-auto` | State that the fixed nav wrapper should not block page interactions except for the nav itself. | This is a behavior instruction, not a visual style. Keep it concise. |
| `backdrop-blur rounded-full bg-transparent border border-black/10` | Transparent pill surface with background blur and a subtle 1px black border at about 10% opacity. | Framer can represent blur, radius, fill, and border natively. |
| `flex justify-between items-center` | Horizontal stack/frame with centered alignment and distributed children. | Use native stacks for flex layout. |
| `hidden md:flex gap-10` | Hide links on Phone; show on Tablet/Desktop with about 40px gap. | Convert responsive prefixes into named breakpoint behavior. |
| `font-sans text-[14px] text-[#1a1a1a]` | Inter text style, 14px, color `#1a1a1a`. | Preserve arbitrary pixel sizes and hex colors exactly. |
| `font-instrument text-[28px] tracking-tight` | Instrument Serif logo, 28px, tight tracking. | If exact tracking is not specified numerically, use descriptive Framer text style language. |
| `bg-[#0871E7] rounded-full text-white` | Blue pill CTA with fill `#0871E7`, white text, fully rounded corners. | Direct color/radius/text mapping is reliable. |
| `shadow-[inset_0_-4px_4px_rgba(255,255,255,0.39)]` | Add an inset bottom highlight shadow similar to `0 -4px 4px rgba(255,255,255,0.39)`. | Mark as "similar" if Framer's shadow controls cannot exactly match CSS syntax. |
| `outline-1 outline-[#0871E7] -outline-offset-1` | Add a 1px blue border/outline visually inside or aligned to the button edge. | Negative outline offset may need approximation. Do not overpromise exact CSS outline behavior. |
| Absolute glint layer `w-[80%] h-4 left-[10%] top-[1px] rounded-[12px] bg-gradient-to-b from-[#DEF0FC] to-transparent` | Add an internal top glint layer with 80% width, 16px height, 10% left inset, 1px top inset, 12px radius, vertical gradient from `#DEF0FC` to transparent. | Framer layers and gradient fills can represent this visually. |
| `group-hover:scale-x-105` | On CTA hover, scale the glint horizontally to about 105%. | Use hover state/variant language. Keep the parent button stable. |
| `min-h-screen bg-[#F3F4ED] pt-24 md:pt-32 flex ... centered` | Hero section min height 100vh, background `#F3F4ED`, top padding about 96px on Phone/Tablet and 128px on Desktop, centered vertical stack. | Convert `pt-24` to 96px and `pt-32` to 128px when exact Tailwind spacing is present. |
| Video `absolute inset-0 z-0 object-cover autoplay loop muted playsInline` | Full-bleed video layer behind content, covering the hero, autoplaying, looping, muted, plays inline. | Native video/media layer is the default. Keep the exact source URL. |
| Overlay `absolute inset-0 bg-white/5` | Full-bleed white tint overlay at about 5% opacity above the video. | Only apply when the source includes this overlay layer. |
| Text wrapper `relative z-20 pointer-events-none text-center` | Centered text layer/group above media that does not intercept interactions. | Keep z-order and pointer behavior as instructions, not code. |
| Headline `text-[38px] md:text-[56px] lg:text-[72px] leading-[0.85] tracking-tight mb-6` | Headline sizes: Phone 38px, Tablet 56px, Desktop 72px; line height 0.85; tight tracking; bottom spacing about 24px. | Preserve arbitrary responsive sizes exactly. `mb-6` maps to about 24px. |
| Subheadline `text-[16px] md:text-[18px] max-w-xl mx-auto leading-relaxed text-[#1a1a1a]/70` | Body sizes: Phone 16px, Tablet/Desktop 18px; max width about 576px; centered; relaxed line height; color `rgba(26,26,26,0.70)`. | `max-w-xl` maps to about 576px. Tailwind slash opacity maps to RGBA. |
| Message overlay `absolute left-[48.5%] md:left-[47.5%] lg:left-[48.5%] -translate-x-1/2 bottom-[32%] z-30 w-[110px] sm:w-[130px]` | Absolutely position message over the video phone screen using per-breakpoint left percentages, centered by -50% x translation, bottom about 32%, width 110px Phone and 130px Tablet/Desktop, above media/text as needed. | Preserve exact percentages because they are asset-alignment constraints. Warn that final placement may need visual adjustment after media crop review. |
| `font-nokia text-[#2A3616] text-[10px] sm:text-[14px] leading-tight break-words min-h-[1.5em]` | Nokia-style monospace text, color `#2A3616`, size 10px Phone and 14px Tablet/Desktop, tight line height, wrapping enabled, minimum height about 1.5em. | Custom font availability may vary; specify fallback. |
| Cursor `w-1.5 h-3 bg-[#2A3616] ml-1` | Cursor rectangle about 6px wide, 12px tall, color `#2A3616`, with about 4px left margin. | Tailwind `w-1.5`, `h-3`, and `ml-1` map to 6px, 12px, and 4px. |

## High-Risk Viewport Geometry Conversions

| Source detail | Framer conversion | Safe convention |
| --- | --- | --- |
| Outer `min-h-screen bg-black overflow-hidden flex flex-col` | Page or hero section is a 100vh vertical stack with black background and clipped overflow. Foreground children remain in normal flow above the full-bleed background media. | Do not place all foreground content in one centered absolute group if the source uses normal-flow top, fill, and bottom children. |
| Top nav `relative z-20 pl-6 pr-6 py-6` followed by `flex-1` hero and bottom footer | Preserve the three-part vertical structure: nav hugs content at top with 24px vertical padding, hero/body fills remaining height, footer/social controls hug content at bottom. | The hero content is centered inside the remaining fill region, not centered against the full viewport independently. |
| Hero content `relative z-10 flex-1 flex flex-col items-center justify-center px-6 py-12 text-center -translate-y-[20%]` | Create a fill-height hero/body frame between nav and footer. Center its content horizontally and vertically within that filled frame, then shift the entire hero/body frame upward by 20% of the hero/body frame height. | CSS percent translate is relative to the transformed element. If Framer cannot express the exact transform, set the content's visual center around 34-35% from the top of the viewport on desktop and keep the footer in normal flow. |
| Background video `absolute inset-0 object-cover translate-y-[17%]` | Full-bleed video layer covers the viewport and is shifted downward by 17% of the video layer height to crop more from the top and favor the lower footage. | This transform belongs to the media crop, not to the foreground layout. Keep the lower portion of the video visible. |
| Bottom social/footer `relative z-10 flex justify-center gap-4 pb-12` | Footer/social row remains in normal flow near the bottom with 48px bottom padding, centered horizontally, above the video. | Do not attach the footer to the hero content group if the source keeps it as a separate bottom sibling. |
| Combined `nav + flex-1 translated hero + footer` | Explain the combined visual result directly: nav at top, bottom controls at bottom, primary hero copy appears in the upper-middle rather than true center. | Avoid vague language like "slightly above center." Include the structure and a numeric visual target when available. |

## Reliable Motion Conversions

| Source detail | Framer conversion | Safe convention |
| --- | --- | --- |
| `motion.div` opacity `0 -> 1`, scale `0.95 -> 1`, duration `1.5`, ease `[0.16, 1, 0.3, 1]` | Headline appear animation with opacity and scale, 1.5s duration, custom/equivalent easing. | Preserve duration and easing values. If Framer cannot enter exact cubic easing, say "close to". |
| `motion.div` opacity `0 -> 1`, y `20 -> 0`, duration `1.2`, delay `0.3`, same ease | Subheadline appear animation with opacity and vertical offset, 1.2s duration, 0.3s delay, custom/equivalent easing. | Preserve delay and offset. |
| Blinking cursor opacity `0 -> 1 -> 0`, duration `0.8`, repeat infinite, linear | Blinking cursor animation with 0.8s linear loop. | This is likely expressible as a looped animation, but keep exactness contingent on Framer support. |
| Type at 100ms, delete at 50ms, pause 2000ms, cycle messages | Code component for exact behavior; native approximation may use looping variants/text states. | Treat exact typewriter logic as code-only unless Framer native tooling is known to support it. |
