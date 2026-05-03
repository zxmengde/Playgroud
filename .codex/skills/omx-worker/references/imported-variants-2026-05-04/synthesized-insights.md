# Synthesized Imported Variant Insights

This file is synthesized from full reads of disabled overlapping skills. Treat these notes as active guidance for the keeper skill, not as an archive. Read the source folders only when this synthesis is insufficient.

Keeper: omx-worker

## How To Apply

- Prefer the keeper skill workflow as the default path.
- Add the trigger phrases, verification checks, output contracts, and resource pointers below when they fit the task.
- If a disabled variant contains scripts, templates, references, examples, or assets, treat them as reusable resources from this keeper skill.
- Do not resurrect a disabled variant as a separate active skill unless the keeper cannot express its behavior cleanly.

## Source: omx-plugin-worker

Trigger/description delta: Team worker protocol (ACK, mailbox, task lifecycle) for tmux-based OMX teams
Actionable imported checks:
- `<leader_cwd>/skills/worker/SKILL.md` (repo fallback)
- `teamName` (before the `/`)
- `workerName` (after the `/`, usually `worker-<n>`)
- Send a startup ACK to the lead mailbox **before task work**:
- After ACK, proceed to your inbox instructions.
- The MCP/state API uses the numeric id (`"1"`), not `"task-1"`.
- Claim the task (do NOT start work without a claim) using claim-safe lifecycle CLI interop (`omx team api claim-task --json`).
- Do NOT directly write lifecycle fields (`status`, `owner`, `result`, `error`) in task files.
- `omx team api mailbox-mark-delivered --json` to acknowledge delivery
- Do **not** rely on ad-hoc tmux keystrokes as a primary delivery channel.
- If a manual trigger arrives (for example `tmux send-keys` nudge), treat it only as a prompt to re-check state and continue through the normal claim-safe lifecycle.
