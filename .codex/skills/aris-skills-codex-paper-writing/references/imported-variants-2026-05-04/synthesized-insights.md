# Synthesized Imported Variant Insights

This file is synthesized from full reads of disabled overlapping skills. Treat these notes as active guidance for the keeper skill, not as an archive. Read the source folders only when this synthesis is insufficient.

Keeper: aris-skills-codex-paper-writing

## How To Apply

- Prefer the keeper skill workflow as the default path.
- Add the trigger phrases, verification checks, output contracts, and resource pointers below when they fit the task.
- If a disabled variant contains scripts, templates, references, examples, or assets, treat them as reusable resources from this keeper skill.
- Do not resurrect a disabled variant as a separate active skill unless the keeper cannot express its behavior cleanly.

## Source: aris-paper-writing

Trigger/description delta: Workflow 3: Full paper writing pipeline. Orchestrates paper-plan → paper-figure → figure-spec/paper-illustration/mermaid-diagram → paper-write → paper-compile → auto-paper-improvement-loop to go from a narrative report to a polished PDF. At `— effort: max | beast` (or explicit `— assurance: submission`), Phase 6 gates the Final Report on `tools/verify_paper_audits.sh`; the PDF is labelled `submission-ready` only when the external verifier is green. Use when user says \"写论文全流程\", \"write paper pipeline\", \"从报告到PDF\", \"paper writing\", or wants the complete paper generation workflow.
Unique headings to preserve:
- Optional: Style reference (`— style-ref: <source>`, opt-in)
Actionable imported checks:
- **MAX_IMPROVEMENT_ROUNDS = 2** — Number of review→fix→recompile rounds in the improvement loop.
- **REVIEWER_MODEL = `gpt-5.4`** — Model used via Codex MCP for plan review, figure review, writing review, and improvement loop.
- **AUTO_PROCEED = true** — Auto-continue between phases. Set `false` to pause and wait for user approval after each phase.
- **`submission`** — The three mandatory audits (proof-checker,
- Parse NARRATIVE_REPORT.md for claims, evidence, and figure descriptions
- Build a **Claims-Evidence Matrix** — every claim maps to evidence, every experiment supports a claim
- GPT-5.4 reviews the plan for completeness
- GPT-5.4 reviews figure quality and captions
- Output: `figures/*.svg` + `figures/*.pdf` (via rsvg-convert) + `figures/specs/*.json`
- Claude plans → Gemini optimizes → Nano Banana Pro renders → Claude reviews (score ≥ 9)
- Output: `figures/ai_generated/*.png`
- Output: `figures/*.mmd` + `figures/*.png`
- Claude plans → Codex native image generation renders → Claude reviews (same multi-stage workflow as `gemini`, different renderer)
- Output: `figures/ai_generated/figure_final.png` + `latex_include.tex` + `review_log.json` (emitted via `tools/paper_illustration_image2.py finalize`)
- GPT-5.4 reviews each section for quality
- Post-compilation checks: undefined refs, page count, font embedding
- Verify all proof steps (hypothesis discharge, interchange justification, etc.)
- Check for logic gaps, quantifier errors, missing domination conditions
Workflow excerpt to incorporate:
```text
# Workflow 3: Paper Writing Pipeline
Orchestrate a complete paper writing workflow for: **$ARGUMENTS**
```

## Source: aris-skills-codex-gemini-review-paper-writing

Trigger/description delta: Workflow 3: Full paper writing pipeline. Orchestrates paper-plan \u2192 paper-figure \u2192 paper-write \u2192 paper-compile \u2192 auto-paper-improvement-loop to go from a narrative report to a polished, submission-ready PDF. Use when user says \\\"\u5199\u8bba\u6587\u5168\u6d41\u7a0b\\\", \\\"write paper pipeline\\\", \\\"\u4ece\u62a5\u544a\u5230PDF\\\", \\\"paper writing\\\", or wants the complete paper generation workflow.
Unique headings to preserve:
- Phase 2b: AI Illustration Generation (when `illustration: true`)
- Paper Writing Pipeline Report
- Pipeline Summary
Actionable imported checks:
- **MAX_IMPROVEMENT_ROUNDS = 2** — Number of review→fix→recompile rounds in the improvement loop.
- **REVIEWER_MODEL = `gemini-review`** — Gemini reviewer invoked through the local `gemini-review` MCP bridge for plan review, figure review, writing review, and the improvement loop.
- **AUTO_PROCEED = true** — Auto-continue between phases. Set `false` to pause and wait for user approval after each phase.
- Parse NARRATIVE_REPORT.md for claims, evidence, and figure descriptions
- Build a **Claims-Evidence Matrix** — every claim maps to evidence, every experiment supports a claim
- Gemini reviews the plan for completeness via the `/paper-plan` overlay
- Gemini reviews figure quality and captions via the `/paper-figure` overlay
- Codex plans the layout → Gemini optimizes → Nano Banana Pro renders → Codex reviews (score ≥ 9)
- Output: `figures/ai_generated/*.png` — publication-quality method diagrams
- Gemini reviews each section for quality via the `/paper-write` overlay
- Post-compilation checks: undefined refs, page count, font embedding
- Soften overclaims to match evidence
- paper/main_round0_original.pdf — Before improvement
- paper/main_round1.pdf — After round 1
- paper/main_round2.pdf — After round 2
- paper/PAPER_IMPROVEMENT_LOG.md — Full review log
- [items from final review that weren't addressed]
- [ ] Submit to [venue] via OpenReview / CMT / HotCRP
Workflow excerpt to incorporate:
```text
# Workflow 3: Paper Writing Pipeline
Orchestrate a complete paper writing workflow for: **$ARGUMENTS**
```
