---
name: context-mode-command-adapters
description: "Use for original context-mode subcommands and local operator commands: ctx-doctor, ctx-stats, ctx-insight, ctx-purge, and ctx-upgrade. Trigger only when the user asks for one of these context-mode command operations, diagnostics, stats, dashboard insight, purge, or upgrade."
metadata:
  role: command_adapter
---

# Context-Mode Command Adapters

This skill is the short keeper for original context-mode command fragments. It
keeps command adapters separate from `context-mode-context-mode-ops`, which is a
GitHub issue, PR, and release operations skill.

## Trigger Boundary

Use this skill only for explicit context-mode command operations:

- `ctx-doctor`: diagnostics and smallest repair step.
- `ctx-stats`: read-only session/token savings report.
- `ctx-insight`: analytics/dashboard URL or inspection summary.
- `ctx-purge`: destructive reset of indexed/session data.
- `ctx-upgrade`: update/build/install context-mode and report restart needs.

For ordinary context budgeting, use `context-mode-context-mode`. For GitHub
triage, PR review, or release work in the context-mode upstream project, use
`context-mode-context-mode-ops`.

## Command Rules

- Prefer the official `context-mode` CLI or MCP operation when available.
- Do not purge, upgrade, open dashboards, or change hooks as a side effect of
  ordinary context analysis.
- `purge` requires explicit user intent because it deletes local indexed or
  session data.
- `upgrade` must report the version before and after, and whether a session
  restart is required.
- If the command is unavailable, report the missing binary or MCP tool and stop
  at a diagnostic result.

## Output Contract

Report:

- command or tool used;
- observed result;
- files or local data changed;
- whether restart is required;
- rollback or recovery path.

For purge and upgrade, include the user's requested trigger in the report.
