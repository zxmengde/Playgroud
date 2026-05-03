# Synthesized Imported Variant Insights

This file is synthesized from full reads of disabled overlapping skills. Treat these notes as active guidance for the keeper skill, not as an archive. Read the source folders only when this synthesis is insufficient.

Keeper: aris-skills-codex-formula-derivation

## How To Apply

- Prefer the keeper skill workflow as the default path.
- Add the trigger phrases, verification checks, output contracts, and resource pointers below when they fit the task.
- If a disabled variant contains scripts, templates, references, examples, or assets, treat them as reusable resources from this keeper skill.
- Do not resurrect a disabled variant as a separate active skill unless the keeper cannot express its behavior cleanly.

## Source: aris-formula-derivation

Trigger/description delta: Structures and derives research formulas when the user wants to 推导公式, build a theory line, organize assumptions, turn scattered equations into a coherent derivation, or rewrite theory notes into a paper-ready formula document. Use when the derivation target is not yet fully fixed, the main object still needs to be chosen, or the user needs a coherent derivation package rather than a finished theorem proof.
Actionable imported checks:
- STATUS = `COHERENT AS STATED | COHERENT AFTER REFRAMING / EXTRA ASSUMPTION | NOT YET COHERENT`
- desired output style if specified:
- desired output mode
- what the derivation is expected to output in the end
- required intermediate identities or lemmas
- do not blindly duplicate prior content
- do not hide gaps with words like "clearly", "obviously", or "similarly"
- define every symbol before use
- Never fabricate a coherent derivation if the object, assumptions, or scope do not support one.
- If uncertainty remains, mark it explicitly in `Open Risks`; do not hide it in polished prose.
Workflow excerpt to incorporate:
```text
## Workflow
### Step 1: Gather Derivation Context
Determine the target derivation file with this priority:
1. a file path explicitly specified by the user
2. a derivation draft already referenced in local notes
3. `DERIVATION_PACKAGE.md` in project root as the default target
Read the relevant local context:
- the chosen target derivation file, if it already exists
- any local theory notes, formula drafts, appendix notes, or files explicitly mentioned by the user
Extract:
- target formula / theory goal
- current formula chain
- assumptions
- notation
- known blockers
- desired output mode
```
