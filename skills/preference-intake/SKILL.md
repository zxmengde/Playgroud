---
name: preference-intake
description: Use when a task depends on user-specific preferences, templates, research habits, office document style, coding habits, knowledge organization, or any missing personal context that should be collected before initializing or updating docs and skills.
---

# Preference Intake

## Purpose

Use this skill to collect user-specific information before Codex creates or updates specialized documents, templates, workflows, or skills. Do not treat generic best practices as if they were the user's preferences.

Preference intake is not only a form about the current task. It should gradually model the user's working style, thinking style, aesthetic standards, research standards, office templates, risk tolerance, collaboration preferences, and rejected assistant behaviors.

## Source Of Truth

Read `D:\Code\Playgroud\docs\profile\user-model.md` first. If needed, use `D:\Code\Playgroud\docs\profile\intake-questionnaire.md` to choose relevant questions.

## Method

Ask only questions that materially affect the current task or future reusable behavior. For full preference collection, ask in batches of at most three high-impact questions. After receiving answers, update `user-model.md` and any affected workflow, template, or skill.

If the user says not to ask more questions, stop asking. Continue with safe inference from existing files, prior feedback, and public research. Mark high-impact unknowns as pending rather than pretending they are known.

When designing questions, prefer questions that reveal durable preference patterns over narrow one-off choices. For example, ask what makes a PPT useful for the user's research communication before asking only for colors.

## Trigger Examples

- Office task but no Word/PPT template, style, audience, or citation preference is known.
- Research task but source standards, output style, or target audience are unknown.
- Coding task but testing, refactor boundary, or commit preference is unknown.
- System initialization task where docs or skills would otherwise be based on assumptions.

## Safety

Do not ask for secrets, passwords, tokens, private account credentials, or sensitive personal identifiers. If a credential is needed, ask the user to configure it outside the knowledge base.
