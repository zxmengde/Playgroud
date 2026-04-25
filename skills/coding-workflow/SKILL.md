---
name: coding-workflow
description: Use for codebase exploration, implementation, debugging, testing, refactoring, code review, project maps, dependency checks, Git-based work, and software engineering tasks in the controlled personal work system.
---

# Coding Workflow

## Trigger

Use for codebase reading, implementation, debugging, tests, refactors, reviews, dependency checks, Git work, and project maps.

## Read

Read `docs/core/execution-loop.md`, `docs/workflows/coding.md`, `docs/profile/user-model.md`, and `docs/profile/preference-map.md`. For unfamiliar projects, read local `AGENTS.md`, README, manifests, test config, and relevant source files.

## Act

Build a lightweight project map when scope is broad. Follow existing style, keep changes scoped, do not revert user changes, and separate understanding, implementation, and verification.

## Output

Produce a patch, project map, review findings, test result, failure summary, or blocker.

## Verify

Run targeted tests, build, lint, direct scripts, or at minimum `git status` and a diff review. Explain any check that cannot run.

