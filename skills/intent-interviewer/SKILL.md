---
name: intent-interviewer
description: Use before complex or ambiguous tasks in the controlled personal work system to understand the user's real goal, success criteria, inputs, outputs, scope, constraints, risks, preferences, and acceptance checks through an adaptive interview.
---

# Intent Interviewer

## Purpose

Use this skill when the task is complex, underspecified, high-impact, or likely to depend on unstated preferences. The goal is to understand what the user actually wants before executing, while keeping the user's effort low.

## Complexity Levels

- Simple: clear input, clear output, low risk. Do not interview; execute directly.
- Medium: mostly clear, but one to three decisions affect the result. State the inferred goal and ask only those questions.
- Complex: broad, multi-file, research-heavy, design-heavy, external-facing, or likely to affect future workflow. Run a structured interview before execution.

## Interview Coverage

For complex tasks, confirm these points:

- Goal: what outcome matters.
- Success criteria: how the result will be judged.
- Inputs: files, links, folders, data, prior context.
- Output: file type, location, format, level of detail.
- Scope: what is included and excluded.
- Constraints: time, tools, style, privacy, compatibility.
- Risks: destructive actions, external writes, uncertainty, verification limits.
- Preferences: implicit style, audience, depth, examples, tradeoffs.
- Acceptance checks: tests, rendering, screenshots, source citations, review criteria.

## Question Discipline

Explore available files and context before asking. Ask questions only when the answer materially changes the result or risk. Prefer one concise batch of questions. If an assumption is low risk, state it and proceed.

## After Interview

Summarize the inferred task in one short paragraph, then continue execution. Do not treat the interview as the final deliverable.
