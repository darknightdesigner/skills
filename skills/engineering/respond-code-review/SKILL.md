---
name: respond-code-review
description: Respond to code review by verifying PR review feedback, code review comments, CI/reviewer objections, or issue feedback before acting on it. Use when the user asks the agent to evaluate, verify, address, respond to, or sanity-check feedback from an active pull request or review thread, especially when the feedback may be wrong, partially right, involve UI behavior rather than visual appearance, or require a best-practice fix rather than a quick patch.
---

# Respond to Code Review

## Overview

Evaluate feedback as a claim to prove or disprove, not as an instruction to obey. Identify the actual root cause, classify the feedback, and choose a best-practice response whose scope fits the real risk.

## Operating Rules

- Do not assume the reviewer is correct.
- Do not bias toward the quickest code change; bias toward the best maintainable solution.
- Treat the user invoking this skill on PR feedback as permission to inspect the active PR context through GitHub tools when available.
- Reuse existing authorization for remedies within the requested scope that preserve established intent, including visual fixes. Ask when the remedy requires an unresolved product decision or additional authorization; visible impact alone does not require another approval.
- Do not make externally visible PR replies until the user asks to post/respond or answers yes to the post-analysis prompt.
- Distinguish the feedback's literal claim from the underlying product, architecture, type-safety, security, or test-quality concern.
- Separately prove two things before editing automatically: that the feedback is valid, and that the intended fix is known. A proven bug is not enough to make the remedy obvious.
- Prefer repository conventions and existing abstractions over new patterns.
- Feedback is often pasted without a URL. If GitHub tools are available, infer the active PR from the current branch, repository remote, or local diff; gather the most likely matching thread, changed files, and surrounding diff before deciding. If the thread cannot be identified confidently, still inspect the active PR/diff and say which context was used.
- Evaluate appearance feedback when it falls within the user's requested scope; otherwise classify it as out of scope. Use established visual intent to judge the claim.
- Analyze UI feedback critically when it is about how the UI works: state management, interaction logic, disabled/loading/error states, optimistic updates, routing, persistence, validation, accessibility behavior, data binding, race conditions, or other functional behavior.
- For UI actionability feedback, distinguish "this control is broken" from "this is what the control should do." If the intended destination, mutation, dialog, or state transition is not already encoded in nearby code, tests, routes, docs, or a clearly equivalent component, classify the issue as needing user review instead of making up or removing behavior.
- Do not treat a UI cleanup or persistence bug as an obvious fix merely because a backend handler, mutation, or cleanup function already exists. The visible user affordance must also be proven. If fixing the issue requires choosing how the user discovers, invokes, labels, or understands a control, classify it as needing user review.
- Be especially conservative with new or uncommon UI affordances. Adding a visible button, icon, tooltip, menu item, toast action, keyboard shortcut, auto-discard behavior, navigation side effect, or hidden lifecycle cleanup is not obvious unless the same surface already has an equivalent established pattern and product intent proves it should apply here.
- If any proposed or implemented solution changes how the UI looks, is positioned, is sized, is spaced, is ordered, or otherwise visually appears, call that out explicitly as `Visual impact: ...`. Do this even when the underlying feedback is functional and the visual change is incidental.
- Count incidental rendered changes as visual impact, including changes to layout, spacing, sizing, position, order, visibility, labels, colors, typography, backgrounds, borders, shadows, rounded surfaces, or DOM composition that changes appearance.

## Workflow

1. Parse the feedback.
   - Extract the claim, affected file/function, suggested fix if any, and implied risk.
   - Separate observations from conclusions. Example: "this can be null" is an observation; "add `!`" is a proposed fix.
   - For UI feedback, decide whether it is pure appearance feedback or functional behavior feedback before investigating deeper.

2. Gather evidence.
   - Read the relevant code, tests, types, schemas, call sites, and local docs.
   - Inspect the current branch's PR or local diff when the feedback is about a PR, even if the pasted feedback does not include a URL.
   - Match pasted feedback to a PR thread by quoted code, file path, symbol names, reviewer text, or diff hunk. If multiple threads match, choose the strongest match and state the confidence.
   - Reproduce the concern with tests, type checks, runtime traces, or a minimal reasoning proof when practical.
   - Look for adjacent invariants that make the feedback invalid or change its scope.
   - For any contemplated fix, identify the source of product intent: an existing handler, route, href, mutation, test expectation, documented contract, or equivalent component. If that source is missing, the issue may be valid but the automatic fix is not obvious.
   - For UI fixes, identify the source of user-facing product intent separately from the internal implementation hook. A cleanup function proves a capability; it does not prove that a new visible control, label, placement, or timing is the right user experience.

3. Find the root cause.
   - Ask what system boundary allowed the problem: data contract, validation gap, state model, concurrency, error handling, stale tests, naming mismatch, reviewer misunderstanding, or unclear API.
   - Avoid fixes that only silence symptoms, type errors, lint errors, or reviewer wording.

4. Classify the feedback.
   - **Out of scope visual feedback**: The feedback concerns appearance outside the user's requested scope, with no separate functional or accessibility concern.
   - **Valid, obvious fix**: The issue is real, the root cause is understood, the intended behavior is already proven from current project evidence, and the best-practice solution is clear, low-risk, and bounded.
   - **Valid, design change needed**: The issue is real, but the solution requires a refactor, API/data contract change, migration, notable behavior change, cross-module coordination, product intent decision, or choosing what an interactive control should do.
   - **Partially valid**: The reviewer identified a real risk or ambiguity, but the literal claim or suggested fix is incomplete, overbroad, or points at the wrong layer.
   - **Not valid**: The claim is contradicted by code, tests, types, documented invariants, or runtime behavior.
   - **Insufficient evidence**: The available artifacts cannot prove the claim after reasonable investigation.

5. Act based on classification.
   - For any option, recommendation, or implemented fix that touches UI output, include a `Visual impact` line. Use `Visual impact: None` when the fix is UI-related but does not change appearance.
   - Apply the authorization rule above. If the remedy needs a user decision, explain that decision and its visual impact before asking; continue independent work within the authorized scope.

## Action Matrix

### Out of Scope Visual Feedback

Use this classification when appearance work is outside the user's requested scope. Otherwise evaluate the feedback against the established visual intent.

Tell the user:
- The appearance feedback is outside the requested scope.
- Why that scope does not cover the requested change.
- Whether there is any separate functional UI issue worth analyzing. If there is, analyze that issue under the normal classifications.

Handle PR replies under **PR Response Drafting**.

### Valid, Obvious Fix

Implement when the remedy is within existing authorization and preserves established intent. Explain visual impact when relevant; request approval only for scope or decisions not already covered.

Count a fix as obvious only when all of these are true:
- The failing behavior or correctness risk is directly supported by code, types, tests, schema, or diff evidence.
- The desired replacement behavior is directly supported by current project evidence, not inferred from generic product intuition.
- For UI feedback, both the internal behavior and the visible affordance are directly supported by current project evidence. Evidence of a handler, mutation, or lifecycle hook is not enough by itself.
- The change preserves intended behavior or tightens an existing contract without surprising callers.
- The edit is bounded to the smallest natural ownership area, such as one module plus its tests, or a simple mechanical call-site update.
- The repository already has a clear convention or abstraction for the fix.
- Focused verification is available and proportional.

Do not count it as obvious if the fix needs a new architecture decision, changes public API semantics, alters persistence or migrations, changes security/authorization behavior, changes money movement or billing behavior, hides uncertainty with assertions/casts, or requires guessing product intent.

For UI fixes, do not count a new or changed affordance as obvious unless its intended behavior is established. A proven bug or available implementation hook alone does not establish that intent. Classify unresolved choices as `Valid, design change needed` or `Partially valid` and present options instead.

For UI controls, do not automatically remove, hide, disable, redirect, repurpose, or replace an interactive surface just because its current implementation is broken. Those are product behavior decisions unless the PR, code, tests, or an equivalent existing component clearly proves that exact remedy.

Then:
- Run focused verification.
- Report the root cause, the fix, and verification.
- Include `Visual impact: ...` if the change affects UI behavior or rendering.
- Handle PR replies under **PR Response Drafting**.

### Valid, Design Change Needed

Resolve any outstanding product or architecture choice before implementing. An already authorized decision does not need another approval.

Use this classification when the review correctly identifies broken or misleading behavior, but the codebase does not prove what the repaired behavior should be. Examples include menu items with no actions, buttons with missing destinations, controls whose labels imply features that do not yet exist, or UI where several reasonable fixes would change user behavior differently.

Propose two best-practice solutions with:
- What would change.
- Pros.
- Cons and risks.
- Verification plan.
- Visual impact, if either option changes UI appearance, layout, position, spacing, sizing, ordering, or visible states.
- Recommended option and why.

When possible, make the two options meaningfully different in scope while keeping both best-practice:
- A smaller, production-safe fix that preserves current behavior and addresses the validated risk.
- A broader refactor or contract-level fix that improves the underlying model when the context justifies it.

After implementing the chosen remedy, handle PR replies under **PR Response Drafting**.

### Partially Valid

Explain the nuance precisely: what is correct, what is incorrect, and what the reviewer likely intended to protect.

Choose a remedy for the supported concern and explain why it fits. Apply the same authorization rule: implement within established intent and scope, or present unresolved choices for user review. Explain visual impact when relevant, and handle PR replies under **PR Response Drafting**.

### Not Valid

Do not change code just to appease the comment.

Tell the user:
- The feedback is not valid.
- The evidence that disproves it.
- Any residual ambiguity or documentation/test gap, if present.

Handle PR replies under **PR Response Drafting**.

### Insufficient Evidence

State what was checked and what is missing. Ask for the missing PR link, reviewer thread, failing command output, production behavior, or artifact only after local investigation cannot resolve the claim.

## PR Response Drafting

Reuse explicit authorization to respond/post. If it is missing and a reply would help, ask once after presenting the analysis. Permission to inspect or edit code alone does not authorize posting.

When posting is authorized:
- Draft a concise, professional reply grounded in evidence.
- If code was changed, mention the exact change and verification.
- If feedback was invalid, explain the invariant or proof without sounding defensive.
- If partially valid, acknowledge the valid concern and explain the adjusted solution.
- Post through GitHub tools when available. If the exact review thread was not confidently identified, show the draft and ask for the target thread instead of posting to a guessed location.

## Output Shape

For completed automatic fixes, use:

```markdown
Verdict: Valid, obvious fix
Root cause: ...
Change made: ...
Visual impact: ...
Verification: ...
```

When a fix requires a user decision or additional authorization, use:

```markdown
Verdict: Valid, decision needed
Root cause: ...
Proposed change: ...
Visual impact: ...
Verification plan: ...

Decision needed: ...
```

For proposals, use:

```markdown
Verdict: Valid, design change needed
Root cause: ...

Option 1: ...
Pros: ...
Cons: ...
Visual impact: ...

Option 2: ...
Pros: ...
Cons: ...
Visual impact: ...

Recommendation: ...
```

For appearance feedback outside the requested scope, use:

```markdown
Verdict: Out of scope visual feedback
Why ignored: ...
Functional issue found: ...
```

For invalid feedback, use:

```markdown
Verdict: Not valid
Why: ...
Evidence: ...
```
