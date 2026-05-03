---
name: aris-watchdog-service
description: Use when the user wants the original Auto-claude-code-research-in-sleep ARIS watchdog background capability, including install, update, start, status, stop, register, unregister, authorization boundary, and rollback through scripts/codex.ps1 aris watchdog.
metadata:
  role: service_adapter
---

# ARIS Watchdog Service

Use this skill for the original
`Auto-claude-code-research-in-sleep` watchdog runtime. This is separate from the
local Markdown research queue and review gate.

## Trigger Boundary

Use when the user asks for:

- original ARIS background/watchdog capability;
- installing or updating `Auto-claude-code-research-in-sleep`;
- starting, checking, or stopping the watchdog;
- registering or unregistering a watchdog task;
- clarifying what can run in the background.

Do not use this skill for ordinary research queue entries, literature notes, or
claim review. Those belong to the local research workflow.

## Public Entry

Run from the repository root:

```powershell
.\scripts\codex.ps1 aris install
.\scripts\codex.ps1 aris update
.\scripts\codex.ps1 aris watchdog start -Interval 60
.\scripts\codex.ps1 aris watchdog status
.\scripts\codex.ps1 aris watchdog register -Name <name> -Type <type> -Session <session>
.\scripts\codex.ps1 aris watchdog unregister -Name <name>
.\scripts\codex.ps1 aris watchdog stop
```

The wrapper clones the original repository into `.runtime/aris/`, runs
`tools/watchdog.py`, writes logs/state under `.runtime/aris/`, and reports stale
PID state instead of pretending the watchdog is active.

## Operator Rules

- Do not start the watchdog without user intent for a background service.
- Check `aris watchdog status` before `start`.
- Use `register` only for tasks the user authorized to keep monitoring.
- Keep repository-local runtime state under `.runtime/aris/`; do not write to
  external accounts or services unless separately authorized.
- Stop the watchdog when the task is complete or when the user asks for cleanup.

## Output Contract

Report:

- command used;
- install path;
- PID/status/base directory;
- registered task name when applicable;
- stdout/stderr log paths;
- rollback command.

Rollback is `.\scripts\codex.ps1 aris watchdog stop`; remove `.runtime/aris/`
only when the user asks to remove the local runtime clone and logs.
