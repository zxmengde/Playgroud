# Synthesized Imported Variant Insights

This file is synthesized from full reads of disabled overlapping skills. Treat these notes as active guidance for the keeper skill, not as an archive. Read the source folders only when this synthesis is insufficient.

Keeper: omx-configure-notifications

## How To Apply

- Prefer the keeper skill workflow as the default path.
- Add the trigger phrases, verification checks, output contracts, and resource pointers below when they fit the task.
- If a disabled variant contains scripts, templates, references, examples, or assets, treat them as reusable resources from this keeper skill.
- Do not resurrect a disabled variant as a separate active skill unless the keeper cannot express its behavior cleanly.

## Source: omx-plugin-configure-notifications

Trigger/description delta: Configure OMX notifications - unified entry point for all platforms
Actionable imported checks:
- **Telegram (native)** - bot token + chat id
- Keep `instruction` templates concise and avoid untrusted shell metacharacters.
- During troubleshooting, avoid swallowing command output; route it to a log file.
- For dev operations, enforce Korean output in all hook instructions.
- `/hooks/agent` delivery verification
