# Synthesized Imported Variant Insights

This file is synthesized from full reads of disabled overlapping skills. Treat these notes as active guidance for the keeper skill, not as an archive. Read the source folders only when this synthesis is insufficient.

Keeper: aris-skills-codex-embodiment-description

## How To Apply

- Prefer the keeper skill workflow as the default path.
- Add the trigger phrases, verification checks, output contracts, and resource pointers below when they fit the task.
- If a disabled variant contains scripts, templates, references, examples, or assets, treat them as reusable resources from this keeper skill.
- Do not resurrect a disabled variant as a separate active skill unless the keeper cannot express its behavior cleanly.

## Source: aris-embodiment-description

Trigger/description delta: Write detailed embodiment descriptions for patent specifications. Use when user says \"撰写实施例\", \"write embodiment\", \"实施例描述\", \"detailed description\", or wants to describe how to practice an invention.
Actionable imported checks:
- `MIN_EMBODIMENTS = 1` — At least one complete embodiment required
- `patent/CLAIMS.md` — drafted claims that the embodiments must support
- Every component mentioned must have a numeral
- Numeral must appear first in parentheses after the component name: "the processor (102)"
- Embodiments must teach a POSITA to make and use the invention without undue experimentation.
- Describe the invention, do NOT evaluate it empirically ("The embodiment achieves 95% accuracy" is wrong; "The processor classifies the input data" is correct).
- Do NOT include tables of experimental results, graphs of measurement data, or comparisons with prior art performance.
- Do NOT copy experimental sections from source papers verbatim. Transform the experimental setup into a manufacturing/operation description.
- Reference numerals must be consistent with the figures.
- Do NOT use subjective language ("excellent", "surprising", "superior").
Workflow excerpt to incorporate:
```text
## Workflow
### Step 1: Plan Embodiments
For each claim category (method, system, etc.), plan at least one embodiment:
| Embodiment | Covers Claims | Type | Key Variations |
|-----------|--------------|------|----------------|
| 1 | Claims 1, X | Best mode / preferred | [primary implementation] |
| 2 | Claims 2, 3 | Alternative | [different parameters/materials] |
| 3 | Claims 4, 5 | Additional alternative | [different configuration] |
```
