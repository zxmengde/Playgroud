---
name: omx-visual-ralph
description: "Use for reference-driven frontend implementation loops: approved visual reference or live URL baseline, implementation, screenshot capture, omx-visual-verdict scoring, pixel diff as secondary evidence, and reusable design tokens."
metadata:
  role: stage_specialist
---

# Visual Ralph

Use this skill when the UI task needs a measured implementation loop rather
than general design advice. It composes an approved visual reference,
implementation, screenshots, `omx-visual-verdict`, and optional pixel diff.

## Trigger Boundary

Use when:

- the user provides or approves a visual reference;
- the task is to clone, restyle, or match a live URL or screenshot;
- visual fidelity must be measured before the next edit;
- reusable design tokens/components should remain after the match.

Do not use when the user only asks for general UI critique; use
`uipro-ui-ux-pro-max` for broad UI/UX review and design guidance.

## Workflow

1. Inspect local frontend evidence: framework, routes, styling system,
   screenshot tooling, and reusable components.
2. Establish a reference: saved screenshot, approved generated image, or
   live-URL baseline with viewport and scope notes.
3. Require an approved reference before implementation when the reference is
   generated or ambiguous.
4. Implement using the repository's existing stack and design conventions.
5. Capture screenshots at the agreed viewport/state.
6. Run `omx-visual-verdict`; treat its JSON verdict as the next-edit driver.
7. Use pixel diff only to locate hotspots when visual diagnosis is unclear.
8. Encode the final match in reusable tokens/components where the project has a
   native place for them.

## Completion Criteria

- Reference artifact is saved in the workspace or source URL baseline is
  documented.
- Screenshot command, viewport, route, and state are recorded.
- Final `omx-visual-verdict` score is at least 90 or the remaining gap is
  explicitly accepted.
- Relevant interaction, loading, error, empty, and responsive states are checked
  when they exist in the task scope.
- Build/lint/test or the repository's equivalent frontend verification has
  passed, or the blocker is stated.
