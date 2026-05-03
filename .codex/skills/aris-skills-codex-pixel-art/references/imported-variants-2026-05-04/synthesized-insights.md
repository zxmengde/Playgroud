# Synthesized Imported Variant Insights

This file is synthesized from full reads of disabled overlapping skills. Treat these notes as active guidance for the keeper skill, not as an archive. Read the source folders only when this synthesis is insufficient.

Keeper: aris-skills-codex-pixel-art

## How To Apply

- Prefer the keeper skill workflow as the default path.
- Add the trigger phrases, verification checks, output contracts, and resource pointers below when they fit the task.
- If a disabled variant contains scripts, templates, references, examples, or assets, treat them as reusable resources from this keeper skill.
- Do not resurrect a disabled variant as a separate active skill unless the keeper cannot express its behavior cleanly.

## Source: aris-pixel-art

Trigger/description delta: Generate pixel art SVG illustrations for READMEs, docs, or slides. Use when user says "画像素图", "pixel art", "make an SVG illustration", "README hero image", or wants a cute visual.
Actionable imported checks:
- Open with `open <file.svg>` for preview
- User provides feedback on screenshot
- **Text overflow**: monospace 13px ≈ 7.8px/char, emoji ≈ 14px. Measure before setting bubble width
Workflow excerpt to incorporate:
```text
## Workflow
### Step 1: Understand the Request
- What characters/objects to draw?
- What's the scene? (dialogue, portrait, group, diagram)
- What colors/brand to match?
- What size? (compact for badge, wide for README hero)
```
