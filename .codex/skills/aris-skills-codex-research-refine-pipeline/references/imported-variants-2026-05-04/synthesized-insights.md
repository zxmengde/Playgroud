# Synthesized Imported Variant Insights

This file is synthesized from full reads of disabled overlapping skills. Treat these notes as active guidance for the keeper skill, not as an archive. Read the source folders only when this synthesis is insufficient.

Keeper: aris-skills-codex-research-refine-pipeline

## How To Apply

- Prefer the keeper skill workflow as the default path.
- Add the trigger phrases, verification checks, output contracts, and resource pointers below when they fit the task.
- If a disabled variant contains scripts, templates, references, examples, or assets, treat them as reusable resources from this keeper skill.
- Do not resurrect a disabled variant as a separate active skill unless the keeper cannot express its behavior cleanly.

## Source: aris-research-refine-pipeline

Trigger/description delta: Run an end-to-end workflow that chains `research-refine` and `experiment-plan`. Use when the user wants a one-shot pipeline from vague research direction to focused final proposal plus detailed experiment roadmap, or asks to "串起来", build a pipeline, do it end-to-end, or generate both the method and experiment plan together.
Actionable imported checks:
- the review history explaining why the method is focused
- `refine-logs/REVIEW_SUMMARY.md`
- Check whether `refine-logs/FINAL_PROPOSAL.md` already exists and still matches the current request.
- the key claims and must-run ablations
- Which reviewer concerns still matter for validation?
- `refine-logs/REVIEW_SUMMARY.md`
- a simplicity or deletion check
- a frontier necessity check if applicable
- Review summary: `refine-logs/REVIEW_SUMMARY.md`
- **Large file handling**: If the Write tool fails due to file size, immediately retry using Bash (`cat << 'EOF' > file`) to write in chunks. Do NOT ask the user for permission — just do it silently.
- Do not let the experiment plan override the Problem Anchor.
- Do not widen the paper story after method refinement unless a missing validation block is truly necessary.
- If the method does not need a frontier primitive, say that clearly and avoid forcing one.
Workflow excerpt to incorporate:
```text
## Workflow
### Phase 0: Triage the Starting Point
- Extract the problem, rough approach, constraints, resources, and target venue.
- Check whether `refine-logs/FINAL_PROPOSAL.md` already exists and still matches the current request.
- If the proposal is missing, stale, or materially different from the current request, run the full `research-refine` stage.
- If the proposal is already strong and aligned, reuse it and jump to experiment planning.
- If in doubt, prefer re-running `research-refine` rather than planning experiments for the wrong method.
```
