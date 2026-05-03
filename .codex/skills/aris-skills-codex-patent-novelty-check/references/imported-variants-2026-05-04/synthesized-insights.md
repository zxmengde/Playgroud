# Synthesized Imported Variant Insights

This file is synthesized from full reads of disabled overlapping skills. Treat these notes as active guidance for the keeper skill, not as an archive. Read the source folders only when this synthesis is insufficient.

Keeper: aris-skills-codex-patent-novelty-check

## How To Apply

- Prefer the keeper skill workflow as the default path.
- Add the trigger phrases, verification checks, output contracts, and resource pointers below when they fit the task.
- If a disabled variant contains scripts, templates, references, examples, or assets, treat them as reusable resources from this keeper skill.
- Do not resurrect a disabled variant as a separate active skill unless the keeper cannot express its behavior cleanly.

## Source: aris-patent-novelty-check

Trigger/description delta: Assess patent novelty and non-obviousness against prior art. Use when user says \"专利查新\", \"patent novelty\", \"可专利性评估\", \"patentability check\", or wants to evaluate if an invention is patentable.
Actionable imported checks:
- `REVIEWER_MODEL = gpt-5.4` — Model used via Codex MCP for cross-model examiner verification
- `patent/PRIOR_ART_REPORT.md` (output of `/prior-art-search`)
- Patent novelty is absolute: any public disclosure before the priority date counts as prior art, worldwide.
- If `mcp__codex__codex` is not available, skip cross-model examiner review and note it in the output.
Workflow excerpt to incorporate:
```text
## Workflow
### Step 1: Define Claim Elements
From the invention description, extract the key claim elements that would define the invention's scope:
1. List the technical features that make the invention novel
2. Identify which features are known from prior art vs. inventive
3. Draft preliminary claim language for 2-3 independent claims (method + system)
```
