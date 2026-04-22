---
name: coding-workflow
description: Use for codebase exploration, implementation, debugging, testing, refactoring, code review, project maps, dependency checks, Git-based work, and software engineering tasks in the controlled personal work system.
---

# Coding Workflow

## Context

Read the repository structure before editing. Use local conventions, dependency files, tests, and existing helpers. Do not revert user changes unless explicitly asked.

## Process

Before editing, infer the user's real engineering goal and identify desired behavior, affected surface, compatibility needs, testing expectations, and rollback risk. Use `intent-interviewer` when the task is broad, architectural, or underspecified.

Find relevant files, implement scoped changes, run relevant tests or checks, and report what changed. For broad or unfamiliar projects, create or update a project map using `D:\Code\Playgroud\templates\coding\project-map.md`.

## Verification

Use `git status`, targeted tests, build commands, linters, or direct scripts. If checks fail, inspect the failure and continue when the fix is within scope.
