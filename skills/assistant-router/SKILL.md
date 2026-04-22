---
name: assistant-router
description: Use when the user asks for broad personal assistant behavior, controlled personal work system behavior, Windows research, coding, office, web, knowledge, automation, or multi-domain task handling. Routes work to the correct Codex skills and local workflow files.
---

# Assistant Router

## Core Rule

This skill is the routing entry for the controlled personal work system. Its first responsibility is to help Codex understand the user's real need, then route and execute. Before starting work in `D:\Code\Playgroud`, sync or check the repository, read the local `AGENTS.md`, then load the workflow file that matches the task.

## Startup

- Local workspace: run `git pull` unless the working tree has uncommitted changes or Git/network errors. If it cannot sync, report the state and continue only when safe.
- Cloud workspace: check the current branch against `origin/main` before starting substantial work.
- Read `docs/assistant/execution-contract.md`, `docs/assistant/preferences.md`, and `docs/assistant/permissions.md` for complex tasks.

## Route Map

- Complex or ambiguous task: use `intent-interviewer` before execution. Do not ask generic checklists; infer from context and ask only high-impact questions.
- Research, papers, literature, PDF study, technical investigation: use `research-workflow` and read `docs/workflows/research.md`.
- Codebase analysis, editing, testing, debugging, review: use `coding-workflow` and read `docs/workflows/coding.md`.
- Word, PowerPoint, Excel, PDF, Markdown, report writing: use `office-workflow` and read `docs/workflows/office.md`.
- Website access, browser automation, screenshots, web data extraction: use `web-workflow` and read `docs/workflows/web.md`.
- Durable user preference, project background, templates, sources, notes: use `knowledge-capture` and read `docs/workflows/knowledge.md`.
- User feedback about work quality, style, repeated errors, insufficient verification: use `harness-capture`.
- Any user-facing response: apply `style-governor`.
- Any task with a concrete outcome: apply `execution-governor`.

## Execution

Do not stop at routing or interview. Route, clarify when needed, then continue executing the selected workflow until there is a usable artifact, necessary explanation, verification result, or explicit blocker.
