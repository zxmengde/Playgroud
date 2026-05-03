# Synthesized Imported Variant Insights

This file is synthesized from full reads of disabled overlapping skills. Treat these notes as active guidance for the keeper skill, not as an archive. Read the source folders only when this synthesis is insufficient.

Keeper: aris-skills-codex-paper-illustration

## How To Apply

- Prefer the keeper skill workflow as the default path.
- Add the trigger phrases, verification checks, output contracts, and resource pointers below when they fit the task.
- If a disabled variant contains scripts, templates, references, examples, or assets, treat them as reusable resources from this keeper skill.
- Do not resurrect a disabled variant as a separate active skill unless the keeper cannot express its behavior cleanly.

## Source: aris-paper-illustration

Trigger/description delta: Generate publication-quality AI illustrations for academic papers using Gemini image generation. Creates architecture diagrams, method illustrations with Claude-supervised iterative refinement loop. Use when user says \"生成图表\", \"画架构图\", \"AI绘图\", \"paper illustration\", \"generate diagram\", or needs visual figures for papers.
Unique headings to preserve:
- Paper Illustration: Multi-Stage Claude-Supervised Figure Generation
- Optional: Style reference (`— style-ref: <source>`, opt-in)
- Step 1: Claude Plans the Figure (YOU ARE HERE)
- The initial prompt from Claude
- Step 5: Claude STRICT Visual Review & Scoring (MANDATORY)
- Claude's STRICT Review of Figure v{N}
Actionable imported checks:
- **IMAGE_MODEL = `gemini-3-pro-image-preview`** — Paperbanana (Nano Banana Pro) for image rendering
- **REASONING_MODEL = `gemini-3-pro-preview`** — Gemini for layout optimization and style checking
- **OUTPUT_DIR = `figures/ai_generated/`** — Output directory
- **Never pass `— style-ref` (or the cache contents) to the Claude vision-checker / Gemini reasoning-checker sub-agents** when they score the generated image — the image must be judged on its own merits.
- **Print-friendly** — Must be readable in grayscale (many reviewers print papers)
- **Consistent sizing** — Similar components should have similar sizes
- **Dark colors** — Black or dark gray (#333333); avoid colored arrows
- **Labeled** — Every arrow should indicate what data flows through it
- **No crossings** — Reorganize layout to avoid arrow crossings
- **CORRECT DIRECTION** — Arrows must point to the RIGHT target!
- **Outputs**: 温暖的橙色系 (#EA580C / #F97316)
- ❌ Thin, hairline arrows (arrows must be THICK)
- Grouping: [how components should be grouped]
- Outputs: Orange (#EA580C)
- Print-friendly (must work in grayscale)
- **ALL arrows must be VERY THICK** - minimum 5-6px stroke width
- **ALL arrows must have CLEAR arrowheads** - large, visible triangular heads
- **ALL arrows must be BLACK or DARK GRAY** - not colored
Workflow excerpt to incorporate:
```text
## Workflow: MUST EXECUTE ALL STEPS
### Step 0: Pre-flight Check
```bash
```
