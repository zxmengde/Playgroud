---
name: assistant-router
description: Use when the user asks for broad personal assistant behavior, controlled personal work system behavior, Windows research, coding, office, web, knowledge, automation, or multi-domain task handling. Routes work to the correct Codex skills and local workflow files.
---

# Assistant Router

## Trigger

Use for multi-domain tasks or any task inside `D:\Code\Playgroud` that requires routing across research, coding, office, web, knowledge, automation, or system maintenance.

## Read

Start with `AGENTS.md`, the five files in `docs/core/`, `docs/profile/user-model.md`, `docs/profile/preference-map.md`, and `docs/tasks/active.md`. Then read only the workflow matching the task.

## Act

Check Git state first. Do not pull if the working tree is dirty or network state is unsafe. Identify the real goal, route to the narrow workflow, and continue to artifact, validation, knowledge record, or explicit blocker.

## Output

Produce the routed workflow's artifact, extraction, patch, document, knowledge item, verification result, or blocker. Routing is not the deliverable.

## Verify

Confirm the selected workflow matches the task, permissions were respected, and available validation was run. Use `scripts/check-finish-readiness.ps1` for complex tasks.

