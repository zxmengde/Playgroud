# Synthesized Imported Variant Insights

This file is synthesized from full reads of disabled overlapping skills. Treat these notes as active guidance for the keeper skill, not as an archive. Read the source folders only when this synthesis is insufficient.

Keeper: aris-skills-codex-claims-drafting

## How To Apply

- Prefer the keeper skill workflow as the default path.
- Add the trigger phrases, verification checks, output contracts, and resource pointers below when they fit the task.
- If a disabled variant contains scripts, templates, references, examples, or assets, treat them as reusable resources from this keeper skill.
- Do not resurrect a disabled variant as a separate active skill unless the keeper cannot express its behavior cleanly.

## Source: aris-claims-drafting

Trigger/description delta: Draft patent claims for an invention. Use when user says \"撰写权利要求\", \"draft claims\", \"写权利要求书\", \"claim drafting\", or wants to create patent claims. The core skill of the patent pipeline.
Actionable imported checks:
- `REVIEWER_MODEL = gpt-5.4` — External examiner for claim quality review
- `patent/PRIOR_ART_REPORT.md` — prior art to avoid
- Claims must be numbered 1, 2, 3, ... continuously without gaps
- Do NOT group independent claims separately from dependent claims
- Do NOT include signal characteristics, detection principles, measurement results
- Each element should be separated by semicolons or on separate lines
- [ ] Antecedent basis: "a" first, "the" thereafter for each element
- **Provide fallback positions**: If the independent claim is rejected, these narrower claims may survive
- Each must add at least one meaningful limitation
- Must reference a prior claim by number
- Must not merely repeat the parent claim
- Should not be cumulative (each claim should be independently useful as a fallback)
- Dependent claims: Do they provide meaningful fallback positions?
- Address MAJOR issues (scope too narrow, missing support, weak fallbacks)
- Re-submit to examiner for round 2 (use `mcp__codex__codex` with threadId)
- Independent claims must be broadest defensible scope over prior art -- not broader, not narrower.
- Each dependent claim should be independently useful as a fallback position.
- Antecedent basis is mandatory: "a processor" first, "the processor" thereafter.
Workflow excerpt to incorporate:
```text
## Workflow
### Step 1: Determine Claim Style and Patent Type
Based on patent type and jurisdiction:
**If `PATENT_TYPE = utility_model` (实用新型)**:
- CN jurisdiction ONLY
- Apparatus/device claims ONLY — no method, no product-by-process
- `MIN_INDEPENDENT_CLAIMS = 1` (single apparatus claim is sufficient)
- Claim format: "1. 一种[主题]，其特征在于，包括：[组件描述]。"
Based on target jurisdiction:
| Jurisdiction | Claim Style | Characterising Phrase | Preamble Format |
|-------------|------------|----------------------|-----------------|
| CN | Two-part (两部式) | 其特征在于 | 一种...的方法/装置，包括： |
| US | Open (preferred) | comprising | A method for..., comprising: |
| EP | Two-part (mandatory) | characterised in that | A method for..., comprising [known], characterised in that [inventive] |
| ALL | Draft CN + US + EP | All of the above | All of the above |
```
