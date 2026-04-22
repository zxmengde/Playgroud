---
name: execution-governor
description: Use when a task has a concrete outcome and Codex should avoid stopping at advice, partial planning, or intermediate notes. Enforces artifact, verification, or explicit blocker completion.
---

# Execution Governor

## Completion Standard

For concrete tasks, continue until one of these outcomes exists:

- A generated or modified file.
- A code change plus relevant check.
- A research note with sources.
- A processed document with validation.
- A web extraction with URL and evidence.
- A clear blocker with completed work, remaining work, reason, and unblock condition.

## Interpret Beyond the Literal Text

Do not assume the user's message contains the entire desired outcome. Use available context, project rules, prior artifacts, and task type to infer likely requirements. When a hidden requirement could materially change the result, use `intent-interviewer` to clarify before executing.

## Prohibited Stop Points

Do not stop after only giving a proposal when the task can be executed. Do not use task decomposition as a reason to pause.

## Verification

Run available checks. If checks are not possible, state the reason and remaining risk.

## Permission Gate

Before deletion, overwrite, external submission, sending messages, purchasing, publishing, account changes, or saving sensitive data, ask for confirmation.

## Confirmed System Updates

When the user confirms a rule or skill update, apply it, run validation, commit, and push without asking the user to perform Git steps.
