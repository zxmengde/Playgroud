---
name: workspace-state-workflow
description: "Use for Playgroud local state workflows: task board, task attempt, task recover, active task, research queue, research review gate, and research run log through scripts/codex.ps1. Do not use for original Vibe Kanban service or ARIS watchdog background runtime."
metadata:
  role: primary
---

# Workspace State Workflow

Use this skill for the repository-local Markdown state system. It covers the
lightweight board and research queue that make work resumable inside
Playgroud. It does not replace original Vibe Kanban or ARIS watchdog services.

## Trigger Boundary

Use when the task involves:

- `docs/tasks/active.md`, `docs/tasks/board.md`, or `docs/tasks/attempts.md`;
- `task board`, `task attempt`, `task recover`, checkpoint, next action, or
  stale attempt handling;
- `docs/knowledge/research-queue.md` or
  `docs/knowledge/research-run-log.md`;
- `research enqueue`, `research review-gate`, or research queue recovery.

Use `vibe-kanban-service` when the user wants the original Vibe Kanban web
service. Use `aris-watchdog-service` when the user wants the original ARIS
background watchdog.

## Read

Read `docs/core.md`, `docs/workflows.md`, `docs/tasks/active.md`,
`docs/tasks/board.md`, and the relevant ledger:

- task work: `docs/tasks/attempts.md`;
- research work: `docs/knowledge/research-queue.md` and
  `docs/knowledge/research-run-log.md`.

## Public Entry

```powershell
.\scripts\codex.ps1 task board
.\scripts\codex.ps1 task recover
.\scripts\codex.ps1 task attempt -Id ATT-YYYYMMDD-001 -TaskId TASK-YYYYMMDD-name -Status running -Checkpoint "..." -NextAction "..."
.\scripts\codex.ps1 research queue
.\scripts\codex.ps1 research enqueue -Id RQ-YYYYMMDD-001 -Question "..." -State queued -ReviewGate "manual review before claim"
.\scripts\codex.ps1 research review-gate -Id RQ-YYYYMMDD-001 -Decision review_needed -Evidence "..." -NextAction "..."
.\scripts\codex.ps1 research run-log
```

## State Rules

- Keep active task, board, attempts, queue, and run log consistent.
- Do not delete old attempts or queue records to hide state drift.
- Latest running or review-needed work must expose a concrete next action.
- Terminal task states are `done`, `blocked`, or `cancelled`.
- Research queue terminal states are `done`, `blocked`, or `cancelled`.
- A review gate records evidence and next action; it is not a background
  service.

## Output Contract

Report the command used, files changed, resulting state, next action, and
rollback path. Rollback is a normal Git revert or a new ledger entry that
supersedes the incorrect state; do not silently edit history unless the current
entry was just created and has not been used elsewhere.
