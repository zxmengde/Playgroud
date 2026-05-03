# Synthesized Imported Variant Insights

This file is synthesized from full reads of disabled overlapping skills. Treat these notes as active guidance for the keeper skill, not as an archive. Read the source folders only when this synthesis is insufficient.

Keeper: aris-skills-codex-paper-slides

## How To Apply

- Prefer the keeper skill workflow as the default path.
- Add the trigger phrases, verification checks, output contracts, and resource pointers below when they fit the task.
- If a disabled variant contains scripts, templates, references, examples, or assets, treat them as reusable resources from this keeper skill.
- Do not resurrect a disabled variant as a separate active skill unless the keeper cannot express its behavior cleanly.

## Source: aris-paper-slides

Trigger/description delta: Generate conference presentation slides (beamer LaTeX → PDF + editable PPTX) from a compiled paper, with speaker notes and full talk script. Use when user says \"做PPT\", \"做幻灯片\", \"make slides\", \"conference talk\", \"presentation slides\", \"生成slides\", \"写演讲稿\", or wants beamer slides for a conference talk.
Unique headings to preserve:
- Optional: Style reference (`— style-ref: <source>`, opt-in)
Actionable imported checks:
- **OUTPUT_DIR = `slides/`** — Output directory for all slide files.
- **REVIEWER_MODEL = `gpt-5.4`** — Model used via Codex MCP for slide review.
- **AUTO_PROCEED = false** — At each checkpoint, **always wait for explicit user confirmation**.
- **Never pass `— style-ref` (or the cache contents) to the GPT-5.4 reviewer sub-agent** — the reviewer must judge the talk's clarity on its own merits.
- **Check prerequisites**:
- **Verify paper exists**:
- **Create output directory**: `mkdir -p slides/figures`
- **Check for resume**: read `slides/SLIDES_STATE.json` if it exists
- **Story arc** — Does the talk build a compelling narrative? (Problem → insight → method → evidence → takeaway)
Workflow excerpt to incorporate:
```text
## Workflow
### Phase 0: Input Validation & Setup
1. **Check prerequisites**:
   ```bash
   which pdflatex && which latexmk
   ```
2. **Verify paper exists**:
   ```bash
   ls $PAPER_DIR/main.tex || ls $PAPER_DIR/main.pdf
   ls $PAPER_DIR/sections/*.tex
   ls $PAPER_DIR/figures/
   ```
3. **Backup existing slides**: if `slides/` exists, copy to `slides-backup-{timestamp}/`
4. **Create output directory**: `mkdir -p slides/figures`
5. **Detect CJK**: if paper contains Chinese/Japanese/Korean, set ENGINE to `xelatex`
6. **Determine slide count**: from TALK_TYPE and TALK_MINUTES using the table above
7. **Check for resume**: read `slides/SLIDES_STATE.json` if it exists
**State**: Write `SLIDES_STATE.json` with `phase: 0`.
```

## Source: aris-skills-codex-gemini-review-paper-slides

Trigger/description delta: Generate conference presentation slides (beamer LaTeX → PDF + editable PPTX) from a compiled paper, with speaker notes and full talk script. Use when user says \"做PPT\", \"做幻灯片\", \"make slides\", \"conference talk\", \"presentation slides\", \"生成slides\", \"写演讲稿\", or wants beamer slides for a conference talk.
Unique headings to preserve:
- Phase 5: Gemini Review
Actionable imported checks:
- **OUTPUT_DIR = `slides/`** — Output directory for all slide files.
- **REVIEWER_MODEL = `gemini-review`** — Gemini reviewer invoked through the local `gemini-review` MCP bridge for slide review.
- **AUTO_PROCEED = false** — At each checkpoint, **always wait for explicit user confirmation**.
- **Check prerequisites**:
- **Verify paper exists**:
- **Create output directory**: `mkdir -p slides/figures`
- **Check for resume**: read `slides/SLIDES_STATE.json` if it exists
- **Story arc** — Does the talk build a compelling narrative? (Problem → insight → method → evidence → takeaway)
Workflow excerpt to incorporate:
```text
## Workflow
### Phase 0: Input Validation & Setup
1. **Check prerequisites**:
   ```bash
   which pdflatex && which latexmk
   ```
2. **Verify paper exists**:
   ```bash
   ls $PAPER_DIR/main.tex || ls $PAPER_DIR/main.pdf
   ls $PAPER_DIR/sections/*.tex
   ls $PAPER_DIR/figures/
   ```
3. **Backup existing slides**: if `slides/` exists, copy to `slides-backup-{timestamp}/`
4. **Create output directory**: `mkdir -p slides/figures`
5. **Detect CJK**: if paper contains Chinese/Japanese/Korean, set ENGINE to `xelatex`
6. **Determine slide count**: from TALK_TYPE and TALK_MINUTES using the table above
7. **Check for resume**: read `slides/SLIDES_STATE.json` if it exists
**State**: Write `SLIDES_STATE.json` with `phase: 0`.
```
