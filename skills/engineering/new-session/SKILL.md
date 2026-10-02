---
name: new-session
description: Create and publish a unique branch from the latest origin/main. Use when the user asks to start a new repository session or branch.
---

# New Session

Complete the session autonomously. Never stop at a recoverable error.

## Inputs

1. Repository path.
2. Optional branch name.

Resolve the repository from available context.

## Workflow

1. Confirm the repository and inspect `git status --short --branch`.
2. Stash local changes before switching branches:
   `git stash push -u -m "new-session preserve <branch> <date>"`.
3. Fetch `origin`, switch to `main`, and fast-forward to `origin/main`.
4. Choose a historically unique Batman-themed branch name.
5. Create it from the explicit start point `origin/main`.
6. Push with upstream tracking.
7. Run the handoff helper. Fix failures and rerun it until it exits `0`.
8. Record the name after handoff succeeds.

`<skill-dir>` is the directory containing this `SKILL.md`. Used names are recorded per repository in `~/.local/state/new-session/used-branches/` (override with `NEW_SESSION_USED_BRANCHES_DIR`).

## Branch Names

- Every branch name must be a concise, lowercase Batman reference under `darknight/`.
- Use a requested name only if it is Batman-themed and the availability helper accepts it. Otherwise, generate one.
- Never add numbers, dates, hashes, IDs, or arbitrary suffixes.
- Check each candidate:
  `bash <skill-dir>/scripts/check-branch-name-available.sh <branch-name>`
- Try three candidates before asking the user for a name.
- If GitHub PR history is unavailable, continue and report that limitation.

## Commands

```bash
cd <project>
git status --short --branch
# Run only when local changes exist.
git stash push -u -m "new-session preserve <current-branch> <date>"
git fetch --prune origin
git switch main
git merge --ff-only origin/main
bash <skill-dir>/scripts/check-branch-name-available.sh <branch-name>
git switch -c <branch-name> origin/main
git push -u origin <branch-name>
bash <skill-dir>/scripts/verify-new-session-handoff.sh
bash <skill-dir>/scripts/check-branch-name-available.sh --record <branch-name>
```

Adapt commands to repository state without weakening the checks.

If the user references a merged PR, verify its merge commit is in freshly fetched `origin/main`:

```bash
gh pr view <number-or-url> --json state,mergedAt,mergeCommit,baseRefName
git merge-base --is-ancestor <mergeCommitOid> origin/main
```

## Handoff

The helper must prove:

- local and upstream parity;
- `origin/<branch>` matches stable, freshly fetched `origin/main`;
- the pushed GitHub ref exists.

If the branch diverges, the repository is dirty, or `origin/main` moves, preserve changes, fetch, update, push, and rerun the helper. Just make it work.

## Report

- Preserved stash, if any.
- Full branch name and verified base.
- Push and upstream status.
- Name-availability result.
- Handoff result.
- Zero-commit GitHub visibility caveat, if applicable.
