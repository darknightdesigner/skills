---
name: before-after-video
description: Create a motion-graphics before/after video of UI changes, built from the real app's before and after states and refined with an unbiased reviewer loop. Use when the user asks for a before/after video, promo, animation, or demo of UI, layout, spacing, or design changes on a branch, PR, or redesign.
---

# Before/After UI Video

Turn a UI change into a short video that **shows** what changed. The real interface morphs from before to after, with outlines and labels marking the change. Build the first version fast, then let a fresh reviewer push it until it's genuinely impressive.

## 1. Scope the story

- Find the before and after states. For a branch, diff against `git merge-base HEAD main`.
- List every visible change: layout, spacing, sizing, copy, icons, new controls.
- Order them into one path through the app, like a real user moving between pages. If the user gave a sequence, follow it exactly.
- Confirm the format. Default to 1440×1080, 60fps, H.264, with no captions or voiceover.

## 2. Capture real states

- Run both versions locally. For a branch, add a git worktree at the merge-base on a second port. Skip repo hooks (`git -c core.hooksPath=/dev/null worktree add ...`, install with `--ignore-scripts`). Copy over git-ignored env and generated files as needed.
- Use the same viewport, data, and login for every capture.
- Prefer DOM snapshots: serialize each page with Playwright, inlining CSS, fonts, and images. Snapshots can morph in place, and overlays can be measured from live elements. Fall back to 2× screenshots only for surfaces that can't be snapshotted.
- Keep a before and an after screenshot of every page to check accuracy against later.

## 3. Build an editable prototype

Write a small HTML page rather than editing video by hand:

- **Stage**: a fixed-size canvas at the output size, with a neutral background and a browser-window frame. Tint the frame's top bar to the app's background, as real Safari does.
- **Scenes config** (`scenes.js`): an ordered list of steps. Each step has a duration, a camera target, morphs, cursor events (move, hover, click, navigate), and overlays. Every value you'd want to tweak lives here.
- **Engine**: `seek(t)` sets the whole frame as a pure function of time, so playback, scrubbing, and rendering always match. Morphs interpolate the changed CSS values (padding, width, gap, text, icon) on the real snapshot elements.
- **Panel**: play, scrub, and step durations, hidden by a `?render` query flag.

## 4. Follow the motion rules

- **Show, don't tell.** Morph the real UI in place. Never cut between screenshots and never add captions.
- **Camera.** Zoom the whole browser window, never crop inside it. Every move uses one curve and duration, slow and consistent (about 1.6s smootherstep). Interpolate translate and scale together so moves travel in straight lines. Land with edges in empty space, never cutting through words.
- **One focus at a time.** The element being changed gets a solid outline with 4 corner handles. Related elements get thin dashed outlines with no handles, sitting just outside their element. Keep only a few overlays on screen at once.
- **Measured overlays.** Read each overlay's box from the live element every frame (`getBoundingClientRect`), so it stays exact at any zoom and during morphs.
- **Small code chips.** Label changes with the real token, variable, or component names from the diff (for example `pageTitleBandClassName`). When a value changes, crossfade the before and after chip text.
- **One delta colour and one focus colour.** A hatch fill marks the space being added or removed. A region that grows starts as a thin line and expands.
- **Real interactions.** Clicks behave as the app does: hover state first, then the press, then the real result. Menus close on an outside click. Drawers slide in and out fully.

## 5. Render

- Drive the prototype with Playwright at `deviceScaleFactor: 2`. Call `seek(frame / fps)`, screenshot each frame, and pipe the frames to ffmpeg: `-c:v libx264 -pix_fmt yuv420p -crf 16`, scaled to the output size. Split long videos into segments that render in parallel, then concatenate.
- Export a master copy and a smaller share copy (CRF around 22).
- Extract a few frames and look at them before handing anything to a reviewer.

## 6. Review loop

Run this loop until a reviewer says it is genuinely impressed.

1. Start a **fresh** subagent for every round. Never reuse one; it becomes biased toward its own earlier notes. Give it the brief below, not your opinion of the video.
2. Fix every blocker and as many other issues as it's worth, in the prototype config. Re-render.
3. Repeat. Stop when the reviewer answers `Genuinely impressed: yes`. If the reviewers keep raising the same issue in conflicting ways, ask the user to decide.

Reviewer brief:

```text
You are an independent, demanding reviewer: a senior motion designer and product
design lead. Judge this video cold, as a picky client would. Do not be lenient.

Video: <path>
What was asked: <the user's request and sequence, in their words>
Rejected before (must not reappear): <earlier feedback, if any>
Ground truth: before/after screenshots in <folder>

How to review:
- Use ffmpeg to extract frames: a 2–4 fps contact sheet for the overall flow,
  then 10–15 fps around every zoom, click, and morph. Look at the frames.
- Check camera: same curve and duration everywhere, slow, never clipping content.
- Check overlays: do outlines, rules, and labels sit exactly on their elements
  at every zoom? One solid focus at a time? Few overlays? Labels readable?
- Check accuracy: do the before/after states and names match the ground truth?
- Check interactions: would the real app respond this way?
- Check the sequence: is every requested step present, in order, and readable?
Write files only to <scratch folder>.

Output:
1. Score from 1 to 10.
2. "Genuinely impressed: yes/no". Say yes only if you'd show it to a demanding
   design lead as is.
3. Prioritized issues, blockers first, each with a timestamp, what's wrong, and
   a specific fix.
4. What works, briefly.
```

## Finish

- Deliver the master and share copies, plus the prototype folder so the user can retime or relabel it later.
- Stop the servers you started and remove the before worktree. Check that the user's repo and environment are unchanged.
