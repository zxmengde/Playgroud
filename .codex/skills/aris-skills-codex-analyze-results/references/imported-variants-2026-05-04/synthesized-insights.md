# Synthesized Imported Variant Insights

This file is synthesized from full reads of disabled overlapping skills. Treat these notes as active guidance for the keeper skill, not as an archive. Read the source folders only when this synthesis is insufficient.

Keeper: aris-skills-codex-analyze-results

## How To Apply

- Prefer the keeper skill workflow as the default path.
- Add the trigger phrases, verification checks, output contracts, and resource pointers below when they fit the task.
- If a disabled variant contains scripts, templates, references, examples, or assets, treat them as reusable resources from this keeper skill.
- Do not resurrect a disabled variant as a separate active skill unless the keeper cannot express its behavior cleanly.

## Source: aris-analyze-results

Trigger/description delta: Analyze ML experiment results, compute statistics, generate comparison tables and insights. Use when user says "analyze results", "compare", or needs to interpret experimental data.
Actionable imported checks:
- Check `figures/`, `results/`, or project-specific output directories
- If multiple seeds: report mean +/- std, check reproducibility
Workflow excerpt to incorporate:
```text
## Workflow
### Step 1: Locate Results
Find all relevant JSON/CSV result files:
- Check `figures/`, `results/`, or project-specific output directories
- Parse JSON results into structured data
```
Verification/output excerpt to incorporate:
```text
## Output Format
Always include:
1. Raw data table
2. Key findings (numbered, concise)
3. Suggested next experiments (if any)
```
