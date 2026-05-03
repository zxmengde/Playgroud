# Synthesized Imported Variant Insights

This file is synthesized from full reads of disabled overlapping skills. Treat these notes as active guidance for the keeper skill, not as an archive. Read the source folders only when this synthesis is insufficient.

Keeper: omx-autopilot

## How To Apply

- Prefer the keeper skill workflow as the default path.
- Add the trigger phrases, verification checks, output contracts, and resource pointers below when they fit the task.
- If a disabled variant contains scripts, templates, references, examples, or assets, treat them as reusable resources from this keeper skill.
- Do not resurrect a disabled variant as a separate active skill unless the keeper cannot express its behavior cleanly.

## Source: omx-plugin-autopilot

Trigger/description delta: [OMX] Strict autonomous loop: $ralplan -> $ralph -> $code-review
Actionable imported checks:
- User wants hands-off execution from a concrete idea, issue, PRD, or requirements artifact to reviewed code
- Task needs planning, implementation, verification, and code review with automatic follow-up when review is not clean
- User wants only review/critique of existing code -- use `$code-review`
- Run or resume `$ralplan` to produce/update PRD and test-spec artifacts.
- When returning from a non-clean review, include `return_to_ralplan_reason` and the review findings as first-class planning input.
- Required handoff artifact: an approved plan/test spec suitable for `$ralph`.
- Ralph owns implementation, tests, build/lint/typecheck evidence, deslop where applicable, and architect verification.
- Required handoff artifact: implementation evidence and changed-file summary suitable for `$code-review`.
- **Phase `code-review`** — merge-readiness gate
- Run `$code-review` on the diff/artifacts produced by `$ralph`.
- A clean review means final recommendation `APPROVE` with architectural status `CLEAR`.
- If not clean, increment the review cycle, persist `review_verdict`, set `return_to_ralplan_reason`, and transition back to Phase `ralplan`.
- known facts/evidence
- If ambiguity remains high, run `explore` first for brownfield facts, then run the Socratic `$deep-interview --quick <task>` before `$ralplan`.
- Always execute phases in order: `ralplan`, then `ralph`, then `code-review`.
- Never skip directly from vague/freeform expansion to implementation; unclear input must be clarified or planned through `$ralplan`.
- A non-clean `$code-review` always returns to `$ralplan`; do not patch findings ad hoc outside the loop.
- Each phase must write/update Autopilot state before handing off.
