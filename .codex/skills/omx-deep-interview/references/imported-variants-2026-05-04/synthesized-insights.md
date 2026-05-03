# Synthesized Imported Variant Insights

This file is synthesized from full reads of disabled overlapping skills. Treat these notes as active guidance for the keeper skill, not as an archive. Read the source folders only when this synthesis is insufficient.

Keeper: omx-deep-interview

## How To Apply

- Prefer the keeper skill workflow as the default path.
- Add the trigger phrases, verification checks, output contracts, and resource pointers below when they fit the task.
- If a disabled variant contains scripts, templates, references, examples, or assets, treat them as reusable resources from this keeper skill.
- Do not resurrect a disabled variant as a separate active skill unless the keeper cannot express its behavior cleanly.

## Source: omx-plugin-deep-interview

Trigger/description delta: Socratic deep interview with mathematical ambiguity gating before execution
Actionable imported checks:
- The user wants to avoid misaligned implementation from underspecified requirements
- You need a requirements artifact before handing off to `ralplan`, `autopilot`, `ralph`, or `team`
- A complete PRD/plan already exists and execution should start
- Ask about intent and boundaries before implementation detail
- Target the weakest clarity dimension each round after applying the stage-priority rules below
- Treat every answer as a claim to pressure-test before moving on: the next question should usually demand evidence or examples, expose a hidden assumption, force a tradeoff or boundary, or reframe root cause vs symptom
- Do not rotate to a new clarity dimension just for coverage when the current answer is still vague; stay on the same thread until one layer deeper, one assumption clearer, or one boundary tighter
- Before crystallizing, complete at least one explicit pressure pass that revisits an earlier answer with a deeper, assumption-focused, or tradeoff-focused follow-up
- Gather codebase facts via `explore` before asking user about internals
- Always run a preflight context intake before the first interview question
- If initial context is oversized or would exceed the prompt budget, do not paste or forward the raw payload into interview prompts; request and record a prompt-safe initial-context summary first
- The oversized initial-context summary gate is blocking: wait for the concise summary before ambiguity scoring, crystallizing artifacts, or any downstream execution handoff
- The summary must preserve goals, constraints, success criteria, non-goals, decision boundaries, and references to any full source documents so downstream consumers receive a prompt-safe but faithful context
- For brownfield work, prefer evidence-backed confirmation questions such as "I found X in Y. Should this change follow that pattern?"
- In attached-tmux Codex CLI, deep-interview uses `omx question` as the required OMX-owned structured questioning path for every interview round
- If you launch `omx question` in a background terminal, immediately wait for that background terminal to finish and read its JSON answer before scoring ambiguity, asking another round, or handing off
- Treat `answers[]` as the primary `omx question` success contract. For a single interview round, read `answers[0].answer`; use legacy top-level `answer` only as a compatibility fallback when needed.
- Re-score ambiguity after each answer and show progress transparently
