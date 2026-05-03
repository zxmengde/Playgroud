# Synthesized Imported Variant Insights

This file is synthesized from full reads of disabled overlapping skills. Treat these notes as active guidance for the keeper skill, not as an archive. Read the source folders only when this synthesis is insufficient.

Keeper: omx-ralplan

## How To Apply

- Prefer the keeper skill workflow as the default path.
- Add the trigger phrases, verification checks, output contracts, and resource pointers below when they fit the task.
- If a disabled variant contains scripts, templates, references, examples, or assets, treat them as reusable resources from this keeper skill.
- Do not resurrect a disabled variant as a separate active skill unless the keeper cannot express its behavior cleanly.

## Source: omx-plugin-ralplan

Trigger/description delta: Alias for $plan --consensus
Actionable imported checks:
- **Planner** creates an adaptive plan (right-sized to task scope; do not default to exactly five steps) and a compact **RALPLAN-DR summary** before review:
- **Re-review loop** (max 5 iterations): Any non-`APPROVE` Critic verdict (`ITERATE` or `REJECT`) MUST run the same full closed loop:
- known facts/evidence
- **Test specification**: Acceptance criteria are testable before code is written
- `ralph fix the null check in src/hooks/bridge.ts:326`
- **Architect** reviews for soundness
- On consensus approval, user chooses execution path:
Workflow excerpt to incorporate:
```text
## Usage
```
$ralplan "task description"
```
```
