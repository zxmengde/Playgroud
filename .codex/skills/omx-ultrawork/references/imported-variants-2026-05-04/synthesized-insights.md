# Synthesized Imported Variant Insights

This file is synthesized from full reads of disabled overlapping skills. Treat these notes as active guidance for the keeper skill, not as an archive. Read the source folders only when this synthesis is insufficient.

Keeper: omx-ultrawork

## How To Apply

- Prefer the keeper skill workflow as the default path.
- Add the trigger phrases, verification checks, output contracts, and resource pointers below when they fit the task.
- If a disabled variant contains scripts, templates, references, examples, or assets, treat them as reusable resources from this keeper skill.
- Do not resurrect a disabled variant as a separate active skill unless the keeper cannot express its behavior cleanly.

## Source: omx-plugin-ultrawork

Trigger/description delta: Parallel execution engine for high-throughput task completion
Actionable imported checks:
- Task benefits from concurrent execution plus lightweight evidence before wrap-up
- You need a direct-tool lane plus optional background evidence lanes without entering Ralph
- User needs session persistence for resume -- use `ralph`, which adds persistence on top of ultrawork
- Gather enough context before implementation. Start with the task intent, desired outcome, constraints, likely touchpoints, and any uncertainty that would change the execution path.
- If uncertainty is still material after a quick repo read, do a focused evidence pass first instead of immediately editing.
- Define pass/fail acceptance criteria before launching execution lanes. Include the command, artifact, or manual check that will prove success.
- When useful, run a direct-tool lane and one or more background evidence lanes at the same time. Evidence lanes can cover docs, tests, regression mapping, or bounded repo analysis.
- Read `docs/shared/agent-tiers.md` before first delegation for agent selection guidance.
- Run quick commands (git status, file reads, simple checks) in the foreground.
- **Context + certainty check**:
- If confidence is low, explore first and narrow the task before editing.
- **Define acceptance criteria before execution**:
- What must be true at the end?
- Which manual QA check is required, if any?
- Background evidence lanes for tests, docs, repo analysis, or regression checks.
- **Run dependent tasks sequentially**: Wait for prerequisites before launching dependent work.
- **Close with lightweight evidence**:
- Build/typecheck passes when relevant.
