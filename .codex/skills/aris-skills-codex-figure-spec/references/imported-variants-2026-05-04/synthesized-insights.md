# Synthesized Imported Variant Insights

This file is synthesized from full reads of disabled overlapping skills. Treat these notes as active guidance for the keeper skill, not as an archive. Read the source folders only when this synthesis is insufficient.

Keeper: aris-skills-codex-figure-spec

## How To Apply

- Prefer the keeper skill workflow as the default path.
- Add the trigger phrases, verification checks, output contracts, and resource pointers below when they fit the task.
- If a disabled variant contains scripts, templates, references, examples, or assets, treat them as reusable resources from this keeper skill.
- Do not resurrect a disabled variant as a separate active skill unless the keeper cannot express its behavior cleanly.

## Source: aris-figure-spec

Trigger/description delta: Generate deterministic publication-quality architecture, workflow, and pipeline diagrams from structured JSON (FigureSpec) into editable SVG. Use when user says \"架构图\", \"workflow 图\", \"pipeline 图\", \"确定性矢量图\", \"figure spec\", \"draw architecture\", or needs precise, editable, publication-ready vector diagrams. Preferred over AI illustration for formal architecture/workflow figures.
Actionable imported checks:
- **Deterministic**: identical FigureSpec JSON always produces identical SVG output (for a fixed renderer version + fonts)
- **Editable**: SVG output is plain-text, can be post-edited by hand or programmatically
- **`/paper-illustration`**: fallback for figures that need natural/qualitative style (method illustrations with photos, qualitative result grids)
Workflow excerpt to incorporate:
```text
## Workflow
### Step 1: Understand the Diagram Goal
From `$ARGUMENTS` (description or path to `PAPER_PLAN.md` / `NARRATIVE_REPORT.md`), identify:
- **Purpose**: architecture, workflow, pipeline, audit cascade, topology?
- **Main entities**: what are the boxes?
- **Relationships**: how do they connect? (uses, produces, calls, verifies, chains)
- **Grouping**: do entities cluster into named regions?
- **Hierarchy vs network**: stacked layers, left-to-right flow, or central hub?
```
