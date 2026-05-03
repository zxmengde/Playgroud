# Synthesized Imported Variant Insights

This file is synthesized from full reads of disabled overlapping skills. Treat these notes as active guidance for the keeper skill, not as an archive. Read the source folders only when this synthesis is insufficient.

Keeper: aris-skills-codex-feishu-notify

## How To Apply

- Prefer the keeper skill workflow as the default path.
- Add the trigger phrases, verification checks, output contracts, and resource pointers below when they fit the task.
- If a disabled variant contains scripts, templates, references, examples, or assets, treat them as reusable resources from this keeper skill.
- Do not resurrect a disabled variant as a separate active skill unless the keeper cannot express its behavior cleanly.

## Source: aris-feishu-notify

Trigger/description delta: Send notifications to Feishu/Lark. Internal utility used by other skills, or manually via /feishu-notify. Supports push-only (webhook) and interactive (bidirectional) modes. Use when user says \"发飞书\", \"notify feishu\", or other skills need to send status updates.
Actionable imported checks:
- **File not found** → return silently, do nothing
- **`"mode": "off"`** → return silently, do nothing
- **Push mode**: Check curl exit code. If non-zero, log warning but do NOT block the workflow.
- **NEVER require Feishu config** — all skills must work without it.
- **Push mode is fire-and-forget.** Send curl, check exit code, move on.
- **No secrets in notifications.** Never include API keys, tokens, or passwords in Feishu messages.
Workflow excerpt to incorporate:
```text
## Workflow
### Step 1: Read Config
```bash
cat ~/.claude/feishu.json 2>/dev/null
```
- **File not found** → return silently, do nothing
- **`"mode": "off"`** → return silently, do nothing
- **`"mode": "push"`** → proceed to Step 2 (push)
- **`"mode": "interactive"`** → proceed to Step 3 (interactive)
```
