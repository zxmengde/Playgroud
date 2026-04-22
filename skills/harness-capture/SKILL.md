---
name: harness-capture
description: Use when Codex makes a repeated mistake, misses context, stops too early, asks unnecessary questions, lacks verification, uses the wrong tone, or the user gives feedback about assistant behavior that should improve future work.
---

# Harness Capture

## Purpose

Convert feedback and failure into durable system changes. Do not leave the correction only in the conversation.

## Process

Append an entry to `D:\Code\Playgroud\docs\assistant\harness-log.md` with date, event, cause, correction, verification, and status. Then update the relevant rule, workflow, skill, template, script, or tool registry.

## Examples

- If work stops at a plan, update `execution-contract.md` or `execution-governor`.
- If tone is unsuitable, update `preferences.md` or `style-governor`.
- If a tool fails repeatedly, update `tool-registry.md` and add a check or fallback.
- If context must be repeated, add a knowledge item or workflow note.
