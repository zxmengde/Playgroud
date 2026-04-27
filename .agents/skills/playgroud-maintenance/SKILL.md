---
name: playgroud-maintenance
description: "Use inside D:\\Code\\Playgroud for maintaining the controlled personal work system: prune obsolete files, audit MCP and hooks, validate task recovery, and keep system changes evidence-backed."
---

# Playgroud Maintenance

## Trigger

Use when working in `D:\Code\Playgroud` on repository structure, system rules, hooks, evals, automations, skills, MCP governance, task recovery, or self-improvement.

## Read

Read `AGENTS.md`, `docs/core/index.md`, `docs/profile/user-model.md`, `docs/profile/preference-map.md`, `docs/tasks/active.md`, `docs/capabilities/index.md`, and the relevant workflow or reference file.

## Act

Prefer small, verifiable mechanisms over new prose. Keep the repository minimal: remove duplicated entrypoints, obsolete sync copies, unused templates, and stale task records when an audited replacement exists. Treat user-level `.codex/skills` and plugin cache as external runtime state; inspect them with scripts instead of syncing copies into this repository.

## Output

Produce a patch, validation result, task-state update, system-improvement proposal, or explicit blocker. Do not treat a plan or broad analysis as the deliverable when safe repository work remains.

## Verify

Run `scripts/eval-agent-system.ps1`, `scripts/validate-system.ps1`, and `scripts/check-finish-readiness.ps1` when changing system structure. Ask before external account writes, persistent user-level configuration changes, or storing sensitive information.
