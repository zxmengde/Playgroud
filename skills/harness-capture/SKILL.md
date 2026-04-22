---
name: harness-capture
description: Use when Codex makes a repeated mistake, misses context, stops too early, asks unnecessary questions, lacks verification, uses the wrong tone, or the user gives feedback about assistant behavior that should improve future work.
---

# Harness Capture

## Purpose

Convert feedback and failures into durable system changes without making the user remember internal files or skill names.

## Process

When Codex notices a mismatch, first fix the current task if possible. Then classify the cause: missing context, unclear intent, unsuitable tone, insufficient verification, tool failure, incomplete execution, or weak workflow rule.

Append an internal entry to `D:\Code\Playgroud\docs\assistant\harness-log.md` with date, event, cause, proposed correction, verification, and status. If the correction changes future behavior, ask the user to confirm the system update in plain language. After confirmation, update the relevant rule, workflow, skill, template, script, or tool registry, then validate, commit, and push.

## Examples

- If work stops at a plan, propose a future-behavior correction and ask for confirmation.
- If tone is unsuitable, propose a style-rule correction and ask for confirmation.
- If a tool fails repeatedly, update tool notes after confirmation and add a check or fallback.
- If context must be repeated, propose a knowledge item or workflow note.
