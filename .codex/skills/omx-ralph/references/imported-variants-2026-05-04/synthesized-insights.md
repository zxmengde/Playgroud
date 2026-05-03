# Synthesized Imported Variant Insights

This file is synthesized from full reads of disabled overlapping skills. Treat these notes as active guidance for the keeper skill, not as an archive. Read the source folders only when this synthesis is insufficient.

Keeper: omx-ralph

## How To Apply

- Prefer the keeper skill workflow as the default path.
- Add the trigger phrases, verification checks, output contracts, and resource pointers below when they fit the task.
- If a disabled variant contains scripts, templates, references, examples, or assets, treat them as reusable resources from this keeper skill.
- Do not resurrect a disabled variant as a separate active skill unless the keeper cannot express its behavior cleanly.

## Source: omx-plugin-ralph

Trigger/description delta: Self-referential loop until task completion with architect verification
Actionable imported checks:
- User says "ralph", "don't stop", "must complete", "finish this", or "keep going until done"
- User wants to explore or plan before committing -- use `plan` skill instead
- Read `docs/shared/agent-tiers.md` before first delegation to select correct agent tiers
- Deliver the full implementation: no scope reduction, no partial completion, no deleting tests to make them pass
- **Pre-context intake (required before planning/execution loop starts)**:
- known facts/evidence
- Do not begin Ralph execution work (delegation, implementation, or verification loops) until snapshot grounding exists. If forced to proceed quickly, note explicit risk tradeoffs.
- **Review progress**: Check TODO list and any prior iteration state
- **Visual task gate (when screenshot/reference images are present)**:
- Run `$visual-verdict` **before every next edit**.
- Require structured JSON output: `score`, `verdict`, `category_match`, `differences[]`, `suggestions[]`, `reasoning`.
- **Verify completion with fresh evidence**:
- After Step 7 passes, run `oh-my-codex:ai-slop-cleaner` on **all files changed during the Ralph session**.
- Scope the cleaner to **changed files only**; do not widen the pass beyond Ralph-owned edits.
- Run the cleaner in **standard mode** (not `--review`).
- If the prompt contains `--no-deslop`, skip Step 7.5 entirely and proceed with the most recent successful verification evidence.
- After the deslop pass, re-run all tests/build/lint and read the output to confirm they still pass.
- Do not proceed to completion until post-deslop regression is green (unless `--no-deslop` explicitly skipped the deslop pass).
