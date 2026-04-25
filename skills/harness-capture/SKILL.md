---
name: harness-capture
description: Use when Codex makes a repeated mistake, misses context, stops too early, asks unnecessary questions, lacks verification, uses the wrong tone, or the user gives feedback about assistant behavior that should improve future work.
---

# Harness Capture

## Trigger

Use when feedback or failure suggests future behavior should change: missed context, poor tone, premature stop, weak verification, tool failure, excess output, over-literal execution, or insufficient initiative.

## Read

Read `docs/knowledge/system-improvement/harness-log.md`, `docs/core/execution-loop.md`, `docs/core/finish-readiness.md`, and the workflow or skill that failed.

## Act

First fix the current task when possible. Then classify the cause and decide whether a durable change is needed. If future behavior changes, ask for confirmation unless the user already authorized that class of low-risk system update.

## Output

Produce a harness-log entry and, when authorized, a rule, workflow, skill, template, script, capability record, or tool note update.

## Verify

Run the relevant validation script, inspect the diff, and confirm the correction addresses the failure rather than only describing it.
