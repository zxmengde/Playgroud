---
name: intent-interviewer
description: Use before complex or ambiguous tasks in the controlled personal work system to understand the user's real goal, success criteria, inputs, outputs, scope, constraints, risks, preferences, and acceptance checks through an adaptive interview.
---

# Intent Interviewer

## Purpose

Use this skill when the task is complex, underspecified, high-impact, or likely to depend on unstated preferences. The goal is to infer and confirm the user's real need before executing, while keeping the user's effort low.

Treat the user's instruction as a partial expression of intent, not necessarily the full requirement. First inspect available context, then ask only the questions that materially affect outcome, risk, or acceptance.

Do not treat the literal prompt as the maximum scope. When the user gives examples, infer the broader goal and safely expand the work to adjacent evidence, alternatives, risks, and system improvements.

## Complexity Levels

- Simple: clear input, clear output, low risk. Do not interview; execute directly.
- Medium: mostly clear, but one to three decisions affect the result. State the inferred goal, fill in safe assumptions, and ask only those questions.
- Complex: broad, multi-file, research-heavy, design-heavy, external-facing, formal, or likely to affect future workflow. Run a structured interview before execution.

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

For user-alignment and system-improvement tasks, also consider the person behind the task: working style, tolerance for interruption, aesthetic standards, learning style, collaboration mode, ambition level, and behaviors the user rejects. Do not ask all of these mechanically; use them to design better questions when questions are appropriate.

## Scenario Focus

- Preference-dependent initialization: if docs, workflows, templates, or skills would be created from assumptions rather than user information, use `preference-intake`.
- Research: question, audience, source standard, currency requirement, output type, evidence vs inference, uncertainty handling.
- Coding: desired behavior, affected surface, compatibility, tests, allowed refactor scope, rollback risk.
- Office: audience, purpose, file type, structure, visual standard, editability, citation needs, review method.
- Web: source purpose, reliability standard, login/download needs, screenshots, account actions, external writes.
- System improvement: current-task fix vs future default behavior, whether to update rules, skills, templates, scripts, or tool notes.

## Question Discipline

Explore available files and context before asking. Ask questions only when the answer materially changes the result or risk. Prefer one concise batch of questions. If an assumption is low risk, state it and proceed.

If the user asks Codex to stop questioning for now, continue the safe parts of the work without further interview. Record unresolved high-impact unknowns for later preference intake.

## After Interview

Summarize the inferred task in one short paragraph, including assumptions and the execution path, then continue execution. Do not treat the interview as the final deliverable.
