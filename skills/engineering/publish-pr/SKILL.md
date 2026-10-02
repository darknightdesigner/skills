---
name: publish-pr
description: Use whenever the user asks to create, open, publish, submit, or make a pull request or PR from local changes. This skill publishes ready-for-review PRs and follows through until checks pass and merge conflicts are resolved.
---

# Goal

Publish a ready-for-review GitHub PR, resolve its merge conflicts, and get all applicable PR checks passing on the final pushed head. If an open PR already exists with current branch/changes, do not create another PR.

## Merge Conflicts

Resolve every conflicted hunk deliberately. For visible UI conflicts, preserve the head branch's local UI structure, interaction model, copy, and styling intent by default. Incorporate compatible or required base changes, but do not replace local UI work merely because the base is newer.

## PR Title & Body

Focus the PR content on the ROI of the changes in simple, clear language:

- Start from the problem the branch solves.
- Explain what changed.
- Highlight the real-world benefit: time saved, manual work removed, risk reduced, workflows made faster, support burden reduced, reliability improved, recovery made easier, maintenance made cheaper, or revenue/profit protected.
- Make the value specific to this diff. Do not use generic business language that could describe any PR.

Include:

- What changed.
- Which user, customer, operator, or developer workflow improves.
- The practical value and ROI of the change.
- Validation that was run, or explicitly say validation was skipped and why.
- Any known caveat, including skipped browser QA or skipped broad validation.

Do not invent metrics. Do not use generic value language that could describe any PR. Connect implementation details to the actual outcome.

## Optional: Analyze & Respond to Code Review Comments

When the user asks to analyze, address, or respond to PR comments from code review agents, launch one or more subagents and group related comments into their assignments. Each subagent must start by calling the Skill tool with `respond-code-review`.

## Freshness Claims

Upstream parity only proves the local branch matches its pushed branch. It does
not prove the pushed branch is current with the PR base.

If the user asks whether the branch is current with the base, asks to update from
the base, or asks for a freshness claim:

- Fetch after the final push.
- Compare `origin/<branch>` with the freshly fetched base.
- Report the remote branch/base counts.
- Do not update the branch unless the user explicitly asks.

Branch drift behind the PR base is not a publishing blocker unless the user asked
for a freshness claim or base update, or the drift creates a merge conflict that
must be resolved under the completion contract.

## Final Report

Always include:

- PR URL.
- Base branch.
- Head branch.
- `isDraft` value.
- Validation status: run, targeted, skipped, or blocked.
- PR-check status for the final pushed head, including any explicitly skipped
checks.
- Merge-conflict status and GitHub mergeability result.
- Visual-evidence status: not applicable, optional follow-up offered/not
requested, blocked, or the number of verified before-and-after pairs uploaded
to the PR.
- Upstream parity counts when available.
- Freshness counts only when the user requested a freshness claim.

