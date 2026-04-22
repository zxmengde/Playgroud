---
name: assistant-router
description: Use when the user asks for broad personal assistant behavior, controlled personal work system behavior, Windows research, coding, office, web, knowledge, automation, or multi-domain task handling. Routes work to the correct Codex skills and local workflow files.
---

# Assistant Router

## Core Rule

This skill is the routing entry for the controlled personal work system. Before starting a complex task in `D:\Code\Playgroud`, read the local `AGENTS.md`, then load the workflow file that matches the task.

## Route Map

- Research, papers, literature, PDF study, technical investigation: use `research-workflow` and read `docs/workflows/research.md`.
- Codebase analysis, editing, testing, debugging, review: use `coding-workflow` and read `docs/workflows/coding.md`.
- Word, PowerPoint, Excel, PDF, Markdown, report writing: use `office-workflow` and read `docs/workflows/office.md`.
- Website access, browser automation, screenshots, web data extraction: use `web-workflow` and read `docs/workflows/web.md`.
- Durable user preference, project background, templates, sources, notes: use `knowledge-capture` and read `docs/workflows/knowledge.md`.
- User feedback about work quality, style, repeated errors, insufficient verification: use `harness-capture`.
- Any user-facing response: apply `style-governor`.
- Any task with a concrete outcome: apply `execution-governor`.

## Execution

Do not stop at routing. Route, then continue executing the selected workflow until there is an artifact, verification result, or explicit blocker.
