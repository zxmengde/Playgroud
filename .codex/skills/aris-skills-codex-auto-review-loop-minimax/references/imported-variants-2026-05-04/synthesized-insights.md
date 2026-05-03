# Synthesized Imported Variant Insights

This file is synthesized from full reads of disabled overlapping skills. Treat these notes as active guidance for the keeper skill, not as an archive. Read the source folders only when this synthesis is insufficient.

Keeper: aris-skills-codex-auto-review-loop-minimax

## How To Apply

- Prefer the keeper skill workflow as the default path.
- Add the trigger phrases, verification checks, output contracts, and resource pointers below when they fit the task.
- If a disabled variant contains scripts, templates, references, examples, or assets, treat them as reusable resources from this keeper skill.
- Do not resurrect a disabled variant as a separate active skill unless the keeper cannot express its behavior cleanly.

## Source: aris-auto-review-loop-minimax

Trigger/description delta: Autonomous multi-round research review loop using MiniMax API. Use when you want to use MiniMax instead of Codex MCP for external review. Trigger with "auto review loop minimax" or "minimax review".
Actionable imported checks:
- REVIEW_DOC: `review-stage/AUTO_REVIEW.md` (cumulative log) *(fall back to `./AUTO_REVIEW.md` for legacy projects)*
- REVIEWER_MODEL = `MiniMax-M2.7` — Model used via MiniMax API
- **Check for `review-stage/REVIEW_STATE.json`** *(fall back to `./REVIEW_STATE.json` if not found — legacy path)*:
- If it exists AND `status` is `"in_progress"` AND `timestamp` is within 24 hours: **resume**
- Read `review-stage/AUTO_REVIEW.md` to restore full context of prior rounds *(fall back to `./AUTO_REVIEW.md`)*
- If `pending_experiments` is non-empty, check if they have completed (e.g., check screen sessions)
- Resume from the next round (round = saved round + 1)
- Read project narrative documents, memory files, and any prior review documents
- Read recent experiment results (check output directories, logs)
- Identify current weaknesses and open TODOs from prior reviews
- Create/update `review-stage/AUTO_REVIEW.md` with header and timestamp
- system: "You are a senior machine learning researcher serving as a reviewer for top-tier conferences like NeurIPS, ICML, and ICLR. Provide rigorous, constructive feedback."
- prompt: [Full review prompt with context]
- **Documentation**: Update project notes and review document
- Collect results from output files and logs
- Update `review-stage/REVIEW_STATE.json` with `"status": "completed"`
- Write final summary to `review-stage/AUTO_REVIEW.md`
- **Large file handling**: If the Write tool fails due to file size, immediately retry using Bash (`cat << 'EOF' > file`) to write in chunks. Do NOT ask the user for permission — just do it silently.
Workflow excerpt to incorporate:
```text
## Workflow
### Initialization
1. **Check for `review-stage/REVIEW_STATE.json`** *(fall back to `./REVIEW_STATE.json` if not found — legacy path)*:
   - If neither path exists: **fresh start** (normal case)
   - If it exists AND `status` is `"completed"`: **fresh start** (previous loop finished normally)
   - If it exists AND `status` is `"in_progress"` AND `timestamp` is older than 24 hours: **fresh start** (stale state from a killed/abandoned run — delete the file and start over)
   - If it exists AND `status` is `"in_progress"` AND `timestamp` is within 24 hours: **resume**
     - Read the state file to recover `round`, `last_score`, `pending_experiments`
     - Read `review-stage/AUTO_REVIEW.md` to restore full context of prior rounds *(fall back to `./AUTO_REVIEW.md`)*
     - If `pending_experiments` is non-empty, check if they have completed (e.g., check screen sessions)
     - Resume from the next round (round = saved round + 1)
     - Log: "Recovered from context compaction. Resuming at Round N."
2. Read project narrative documents, memory files, and any prior review documents
3. Read recent experiment results (check output directories, logs)
4. Identify current weaknesses and open TODOs from prior reviews
5. Initialize round counter = 1 (unless recovered from state file)
6. Create/update `review-stage/AUTO_REVIEW.md` with header and timestamp
```
