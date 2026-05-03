# Synthesized Imported Variant Insights

This file is synthesized from full reads of disabled overlapping skills. Treat these notes as active guidance for the keeper skill, not as an archive. Read the source folders only when this synthesis is insufficient.

Keeper: aris-skills-codex-figure-description

## How To Apply

- Prefer the keeper skill workflow as the default path.
- Add the trigger phrases, verification checks, output contracts, and resource pointers below when they fit the task.
- If a disabled variant contains scripts, templates, references, examples, or assets, treat them as reusable resources from this keeper skill.
- Do not resurrect a disabled variant as a separate active skill unless the keeper cannot express its behavior cleanly.

## Source: aris-figure-description

Trigger/description delta: Process user-provided patent figures and generate formal drawing descriptions. Use when user says \"附图处理\", \"figure description\", \"附图说明\", \"drawings description\", or wants to describe patent figures with reference numerals.
Actionable imported checks:
- `FIGURE_DIR = "patent/figures/"` — Output directory for figure descriptions
- Check `patent/figures/`, `figures/`, root directory
- Check INVENTION_BRIEF.md or INVENTION_DISCLOSURE.md for figure references
- Every component in every figure must have a reference numeral.
- Every reference numeral must be explained in the specification.
- Numeral series must be consistent: 100-series for FIG. 1, 200-series for FIG. 2.
- Do NOT modify user-provided figures -- only describe them.
Workflow excerpt to incorporate:
```text
## Workflow
### Step 1: Discover Figures
1. Search the project directory for figure files:
   - Check `patent/figures/`, `figures/`, root directory
   - Look for PNG, JPG, SVG, PDF files
   - Check INVENTION_BRIEF.md or INVENTION_DISCLOSURE.md for figure references
2. List all discovered figures with their paths
3. If figures are missing that claims require, note them as `[MISSING: description needed]`
```
