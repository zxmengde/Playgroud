---
name: omx-visual-verdict
description: Use when a UI screenshot must be judged against one or more visual references with a strict JSON verdict, numeric score, differences, suggestions, and pass threshold. Trigger for visual QA, screenshot-to-reference comparison, or measured UI iteration.
metadata:
  role: output_contract
---

# Visual Verdict

Use this skill to compare generated UI screenshots against one or more
reference images and return a strict verdict that can drive the next UI edit.
It is an output contract, not a general UI design skill.

## Inputs

- `reference_images[]`: one or more image paths.
- `generated_screenshot`: current output image path.
- Optional `category_hint`: dashboard, mobile app, landing page, data table,
  form flow, or another UI category.

## Output Contract

Return JSON only:

```json
{
  "score": 0,
  "verdict": "revise",
  "category_match": false,
  "differences": ["..."],
  "suggestions": ["..."],
  "reasoning": "short explanation"
}
```

Rules:

- `score` is an integer from 0 to 100.
- `verdict` is `pass`, `revise`, or `fail`.
- `category_match` is true only when the screenshot matches the intended UI
  category and visual language.
- `differences` must be concrete visual mismatches: layout, spacing,
  typography, color, hierarchy, component state, or responsiveness.
- `suggestions` must be actionable edits tied to those differences.
- `reasoning` is one or two sentences.

## Threshold

The normal pass threshold is `score >= 90`. If the score is lower, continue
editing and rerun this skill before the next visual completion claim.

Pixel diff tooling can be used as secondary debug evidence, but the final
decision is this JSON verdict.
