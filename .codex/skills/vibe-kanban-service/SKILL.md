---
name: vibe-kanban-service
description: Use when the user wants the original Vibe Kanban service, not the local Markdown task board. Covers starting, checking, stopping, boundaries, state file, URL, stale PID handling, and rollback through scripts/codex.ps1 vibe.
metadata:
  role: service_adapter
---

# Vibe Kanban Service

Use this skill for the original Vibe Kanban runtime service. This is separate
from the local `task board / attempt / recover` Markdown workflow.

## Trigger Boundary

Use when the user asks for:

- original Vibe Kanban service;
- a browser/task-board service runtime;
- `vibe start`, `vibe status`, or `vibe stop`;
- checking whether the service is running or stale;
- stopping or rolling back the local Vibe Kanban runtime.

Do not use this skill for ordinary task notes, `docs/tasks/board.md`, attempt
ledger updates, or session recovery. Those belong to the local task workflow.

## Public Entry

Run from the repository root:

```powershell
.\scripts\codex.ps1 vibe start -Port 3210
.\scripts\codex.ps1 vibe status
.\scripts\codex.ps1 vibe stop
```

The wrapper starts the original service through `npx --yes vibe-kanban`, records
runtime state under `.runtime/vibe-kanban/`, and checks stale PIDs before
claiming the service is running.

## Operator Rules

- Check `vibe status` before starting a new instance.
- If status is `running`, reuse the reported URL.
- If status is `stale`, stop or clean the stale state before restarting.
- Do not describe the Markdown board as the original Vibe Kanban service.
- Do not leave a long-running service active unless the user asked for it.

## Output Contract

Report:

- command used;
- running/stopped/stale status;
- PID and URL when running;
- state path under `.runtime/vibe-kanban/`;
- stop command and rollback path.

Rollback is `.\scripts\codex.ps1 vibe stop`; if state is stale, remove only the
stale `.runtime/vibe-kanban/state.json` after checking the PID is not running.
