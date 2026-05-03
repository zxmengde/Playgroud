# Synthesized Imported Variant Insights

This file is synthesized from full reads of disabled overlapping skills. Treat these notes as active guidance for the keeper skill, not as an archive. Read the source folders only when this synthesis is insufficient.

Keeper: aris-skills-codex-specification-writing

## How To Apply

- Prefer the keeper skill workflow as the default path.
- Add the trigger phrases, verification checks, output contracts, and resource pointers below when they fit the task.
- If a disabled variant contains scripts, templates, references, examples, or assets, treat them as reusable resources from this keeper skill.
- Do not resurrect a disabled variant as a separate active skill unless the keeper cannot express its behavior cleanly.

## Source: aris-specification-writing

Trigger/description delta: Write the full patent specification from claims and invention disclosure. Use when user says \"撰写说明书\", \"write specification\", \"写说明书\", \"patent description\", or wants to draft the complete patent specification.
Actionable imported checks:
- `REVIEWER_MODEL = gpt-5.4` — External reviewer for specification quality
- `OUTPUT_FORMAT = "markdown"` — Markdown drafts; converted to filing format by `/jurisdiction-format`
- `OUTPUT_DIR = "patent/"` — Base output directory
- Must match the broadest claim scope
- The deficiencies must be technical, not commercial or social
- DO NOT admit the prior art is "superior" or "better"
- DO NOT cite specific patent numbers unless they are known prior art (citations go in IDS for US, or Background section for CN)
- Must provide support for ALL claim elements
- The specification supports the claims, not the other way around. Every claim element must have support.
- DO NOT include experimental results, accuracy metrics, or empirical evaluations.
- DO NOT use subjective language ("excellent", "surprising", "superior").
- Reference numerals must be consistent: same component, same numeral, everywhere.
- Multiple embodiments strengthen the specification but are not always required.
- If `mcp__codex__codex` is not available, skip cross-model review and note it in the output.
Workflow excerpt to incorporate:
```text
## Workflow
### Step 1: Initialize Specification Structure
Create the output directory and section files:
```
patent/specification/
├── title.md
├── technical_field.md
├── background.md
├── summary.md
├── drawings_description.md
├── detailed_description.md
└── abstract.md
```
```
