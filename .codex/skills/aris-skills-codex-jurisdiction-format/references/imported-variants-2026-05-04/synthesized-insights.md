# Synthesized Imported Variant Insights

This file is synthesized from full reads of disabled overlapping skills. Treat these notes as active guidance for the keeper skill, not as an archive. Read the source folders only when this synthesis is insufficient.

Keeper: aris-skills-codex-jurisdiction-format

## How To Apply

- Prefer the keeper skill workflow as the default path.
- Add the trigger phrases, verification checks, output contracts, and resource pointers below when they fit the task.
- If a disabled variant contains scripts, templates, references, examples, or assets, treat them as reusable resources from this keeper skill.
- Do not resurrect a disabled variant as a separate active skill unless the keeper cannot express its behavior cleanly.

## Source: aris-jurisdiction-format

Trigger/description delta: Compile patent application into jurisdiction-specific filing format. Use when user says \"格式转换\", \"jurisdiction format\", \"国家格式\", \"compile patent\", or wants formatted patent documents for CN/US/EP filing.
Actionable imported checks:
- `OUTPUT_FORMAT = "markdown"` — `markdown` (for review) or `docx` (for filing, requires python-docx)
- `OUTPUT_DIR = "patent/output/"` — Base output directory
- Verify word count <= 300 Chinese characters
- Verify word count <= 150 words / 2500 characters
- Never mix jurisdiction formats (e.g., do not include "其特征在于" in US claims).
- Claims must be identical in technical content across jurisdictions, only the format differs.
- For CN output, verify Chinese patent terminology is correct and consistent.
- For EP output, the two-part claim form is mandatory -- every independent claim must have "characterised in that."
- Abstract word limits are jurisdiction-specific and must be verified.
- If `OUTPUT_FORMAT = "docx"`, check that python-docx is available; if not, fall back to markdown.
Workflow excerpt to incorporate:
```text
## Workflow
### Step 1: Determine Output Jurisdictions
From `$ARGUMENTS` or constant:
- `CN` -> Generate CNIPA format only
- `US` -> Generate USPTO format only
- `EP` -> Generate EPO format only
- `ALL` -> Generate all three formats
```
