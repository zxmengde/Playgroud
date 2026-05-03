# Synthesized Imported Variant Insights

This file is synthesized from full reads of disabled overlapping skills. Treat these notes as active guidance for the keeper skill, not as an archive. Read the source folders only when this synthesis is insufficient.

Keeper: omx-note

## How To Apply

- Prefer the keeper skill workflow as the default path.
- Add the trigger phrases, verification checks, output contracts, and resource pointers below when they fit the task.
- If a disabled variant contains scripts, templates, references, examples, or assets, treat them as reusable resources from this keeper skill.
- Do not resurrect a disabled variant as a separate active skill unless the keeper cannot express its behavior cleanly.

## Source: omx-plugin-note

Trigger/description delta: Save notes to notepad.md for compaction resilience
Actionable imported checks:
- Auto-pruned after 7 days
Workflow excerpt to incorporate:
```text
## Usage
| Command | Action |
|---------|--------|
| `/note <content>` | Add to Working Memory with timestamp |
| `/note --priority <content>` | Add to Priority Context (always loaded) |
| `/note --manual <content>` | Add to MANUAL section (never pruned) |
| `/note --show` | Display current notepad contents |
| `/note --prune` | Remove entries older than 7 days |
| `/note --clear` | Clear Working Memory (keep Priority + MANUAL) |
```
