# Synthesized Imported Variant Insights

This file is synthesized from full reads of disabled overlapping skills. Treat these notes as active guidance for the keeper skill, not as an archive. Read the source folders only when this synthesis is insufficient.

Keeper: omx-skill

## How To Apply

- Prefer the keeper skill workflow as the default path.
- Add the trigger phrases, verification checks, output contracts, and resource pointers below when they fit the task.
- If a disabled variant contains scripts, templates, references, examples, or assets, treat them as reusable resources from this keeper skill.
- Do not resurrect a disabled variant as a separate active skill unless the keeper cannot express its behavior cleanly.

## Source: omx-plugin-skill

Trigger/description delta: Manage local skills - list, add, remove, search, edit, setup wizard
Actionable imported checks:
- Tricky bugs that required investigation
- [Common mistake and how to avoid it]
- GOOD: "When seeing 'Cannot find module' in dist/, check tsconfig.json moduleResolution"
- **Hard-Won** - Required significant debugging effort
- **Clear Feedback:** Use checkmarks (✓), crosses (✗), arrows (→) for clarity
- **Scope Resolution:** Always check both user and project scopes
- `/skill validate` - Check all skills for format errors
Workflow excerpt to incorporate:
```text
### Workflow Skill Template
```markdown
# [Workflow Name]
```
