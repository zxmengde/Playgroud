# Synthesized Imported Variant Insights

This file is synthesized from full reads of disabled overlapping skills. Treat these notes as active guidance for the keeper skill, not as an archive. Read the source folders only when this synthesis is insufficient.

Keeper: aris-skills-codex-proof-writer

## How To Apply

- Prefer the keeper skill workflow as the default path.
- Add the trigger phrases, verification checks, output contracts, and resource pointers below when they fit the task.
- If a disabled variant contains scripts, templates, references, examples, or assets, treat them as reusable resources from this keeper skill.
- Do not resurrect a disabled variant as a separate active skill unless the keeper cannot express its behavior cleanly.

## Source: aris-proof-writer

Trigger/description delta: Writes rigorous mathematical proofs for ML/AI theory. Use when asked to prove a theorem, lemma, proposition, or corollary, fill in missing proof steps, formalize a proof sketch, 补全证明, 写证明, 证明某个命题, or determine whether a claimed proof can actually be completed under the stated assumptions.
Actionable imported checks:
- STATUS = `PROVABLE AS STATED | PROVABLE AFTER WEAKENING / EXTRA ASSUMPTION | NOT CURRENTLY JUSTIFIED`
- desired output style if specified: concise, appendix-ready, or full-detail
- `PROVABLE AFTER WEAKENING / EXTRA ASSUMPTION`
- required intermediate lemmas
- boundary cases that must be handled separately
- do not blindly duplicate prior content
- define every constant and symbol before use
- check quantifier order carefully
- If uncertainty remains, mark it explicitly in `Open Risks`; do not hide it inside polished prose.
Workflow excerpt to incorporate:
```text
## Workflow
### Step 1: Gather Proof Context
Determine the target proof file with this priority:
1. a file path explicitly specified by the user
2. a proof draft already referenced in local notes or theorem files
3. `PROOF_PACKAGE.md` in project root as the default target
Read the relevant local context:
- the chosen target proof file, if it already exists
- theorem notes, appendix drafts, or files explicitly mentioned by the user
Extract:
- exact claim
- assumptions
- notation
- proof sketch or partial proof
- nearby lemmas that the draft may depend on
```
