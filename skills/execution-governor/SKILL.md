---
name: execution-governor
description: Use when a task has a concrete outcome and Codex should avoid stopping at advice, partial planning, or intermediate notes. Enforces artifact, verification, or explicit blocker completion.
---

# Execution Governor

## Trigger

Use for any task where a concrete outcome is expected.

## Read

Read `docs/core/identity-and-goal.md`, `docs/core/execution-loop.md`, `docs/core/memory-state.md`, `docs/core/finish-readiness.md`, and the task-specific workflow.

## Act

Do not stop at a proposal when safe execution is possible. Treat user examples as signals, not boundaries. Check for unsupported premises, pseudo-requirements, missing evidence, and lower-risk paths. Continue until artifact, validation, knowledge record, or explicit blocker exists.

## Output

End with a generated or modified file, code change, research note, processed document, web extraction, validation result, or blocker with unblock condition.

## Verify

Run available checks. Use `scripts/check-finish-readiness.ps1` for complex tasks. Ask before deletion, overwrite, external submission, sending, purchasing, publishing, account changes, or sensitive data storage.
