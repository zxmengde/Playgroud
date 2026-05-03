# Synthesized Imported Variant Insights

This file is synthesized from full reads of disabled overlapping skills. Treat these notes as active guidance for the keeper skill, not as an archive. Read the source folders only when this synthesis is insufficient.

Keeper: omx-ultraqa

## How To Apply

- Prefer the keeper skill workflow as the default path.
- Add the trigger phrases, verification checks, output contracts, and resource pointers below when they fit the task.
- If a disabled variant contains scripts, templates, references, examples, or assets, treat them as reusable resources from this keeper skill.
- Do not resurrect a disabled variant as a separate active skill unless the keeper cannot express its behavior cleanly.

## Source: omx-plugin-ultraqa

Trigger/description delta: QA cycling workflow - test, verify, fix, repeat until goal met
Actionable imported checks:
- `--typecheck`: Run the project's type check command
- `--custom`: Run appropriate command and check for pattern
- **CHECK RESULT**: Did the goal pass?
- **For resume detection**:
- **CLEAR OUTPUT** - User should always know current cycle and status
