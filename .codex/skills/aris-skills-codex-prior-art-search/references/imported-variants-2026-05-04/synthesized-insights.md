# Synthesized Imported Variant Insights

This file is synthesized from full reads of disabled overlapping skills. Treat these notes as active guidance for the keeper skill, not as an archive. Read the source folders only when this synthesis is insufficient.

Keeper: aris-skills-codex-prior-art-search

## How To Apply

- Prefer the keeper skill workflow as the default path.
- Add the trigger phrases, verification checks, output contracts, and resource pointers below when they fit the task.
- If a disabled variant contains scripts, templates, references, examples, or assets, treat them as reusable resources from this keeper skill.
- Do not resurrect a disabled variant as a separate active skill unless the keeper cannot express its behavior cleanly.

## Source: aris-prior-art-search

Trigger/description delta: Search patent databases and academic literature for prior art relevant to an invention. Use when user says \"现有技术检索\", \"prior art search\", \"专利检索\", \"check patents\", or wants to find relevant prior art.
Actionable imported checks:
- Never fabricate patent numbers or citations. Mark uncertain references with `[VERIFY]`.
- Patent prior art includes everything published before the priority date, not just patents.
Workflow excerpt to incorporate:
```text
## Workflow
### Step 1: Extract Search Concepts
From the invention description, identify:
1. **Core inventive concept**: The primary technical contribution (1-2 sentences)
2. **Technical problem**: What problem it solves
3. **Key technical features**: 4-6 specific technical elements that define the invention
4. **IPC/CPC classes**: Predict relevant classification codes (e.g., G06N, G06F)
```
