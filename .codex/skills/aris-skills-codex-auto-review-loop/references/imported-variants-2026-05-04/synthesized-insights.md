# Synthesized Imported Variant Insights

This file is synthesized from full reads of disabled overlapping skills. Treat these notes as active guidance for the keeper skill, not as an archive. Read the source folders only when this synthesis is insufficient.

Keeper: aris-skills-codex-auto-review-loop

## How To Apply

- Prefer the keeper skill workflow as the default path.
- Add the trigger phrases, verification checks, output contracts, and resource pointers below when they fit the task.
- If a disabled variant contains scripts, templates, references, examples, or assets, treat them as reusable resources from this keeper skill.
- Do not resurrect a disabled variant as a separate active skill unless the keeper cannot express its behavior cleanly.

## Source: aris-auto-review-loop

Trigger/description delta: Autonomous multi-round research review loop. Repeatedly reviews via Codex MCP, implements fixes, and re-reviews until positive assessment or max rounds reached. Use when user says "auto review loop", "review until it passes", or wants autonomous iterative improvement.
Actionable imported checks:
- REVIEW_DOC: `review-stage/AUTO_REVIEW.md` (cumulative log) *(fall back to `./AUTO_REVIEW.md` for legacy projects)*
- REVIEWER_MODEL = `gpt-5.4` — Model used via Codex MCP. Must be an OpenAI model (e.g., `gpt-5.4`, `o3`, `gpt-4o`)
- **REVIEWER_BACKEND = `codex`** — Default: Codex MCP (xhigh). Override with `— reviewer: oracle-pro` for GPT-5.4 Pro via Oracle MCP. See `shared-references/reviewer-routing.md`.
- **OUTPUT_DIR = `review-stage/`** — All review-stage outputs go here. Create the directory if it doesn't exist.
- **COMPACT = false** — When `true`, (1) read `EXPERIMENT_LOG.md` and `findings.md` instead of parsing full logs on session recovery, (2) append key findings to `findings.md` after each round.
- **REVIEWER_DIFFICULTY = medium** — Controls how adversarial the reviewer is. Three levels:
- `medium` (default): Current behavior — MCP-based review, Claude controls what context GPT sees.
- `hard`: Adds **Reviewer Memory** (GPT tracks its own suspicions across rounds) + **Debate Protocol** (Claude can rebut, GPT rules).
- `nightmare`: Everything in `hard` + **GPT reads the repo directly** via `codex exec` (Claude cannot filter what GPT sees) + **Adversarial Verification** (GPT independently checks if code matches claims).
- **Check for `review-stage/REVIEW_STATE.json`** *(fall back to `./REVIEW_STATE.json` if not found — legacy path)*:
- If neither path exists: **fresh start** (normal case, identical to behavior before this feature existed)
- If it exists AND `status` is `"in_progress"` AND `timestamp` is within 24 hours: **resume**
- Read `review-stage/AUTO_REVIEW.md` to restore full context of prior rounds *(fall back to `./AUTO_REVIEW.md`)*
- If `pending_experiments` is non-empty, check if they have completed (e.g., check screen sessions)
- Resume from the next round (round = saved round + 1)
- Read recent experiment results (check output directories, logs)
- Identify current weaknesses and open TODOs from prior reviews
- Create/update `review-stage/AUTO_REVIEW.md` with header and timestamp
Workflow excerpt to incorporate:
```text
## Workflow
### Initialization
1. **Check for `review-stage/REVIEW_STATE.json`** *(fall back to `./REVIEW_STATE.json` if not found — legacy path)*:
   - If neither path exists: **fresh start** (normal case, identical to behavior before this feature existed)
   - If it exists AND `status` is `"completed"`: **fresh start** (previous loop finished normally)
   - If it exists AND `status` is `"in_progress"` AND `timestamp` is older than 24 hours: **fresh start** (stale state from a killed/abandoned run — delete the file and start over)
   - If it exists AND `status` is `"in_progress"` AND `timestamp` is within 24 hours: **resume**
     - Read the state file to recover `round`, `threadId`, `last_score`, `pending_experiments`
     - Read `review-stage/AUTO_REVIEW.md` to restore full context of prior rounds *(fall back to `./AUTO_REVIEW.md`)*
     - If `pending_experiments` is non-empty, check if they have completed (e.g., check screen sessions)
     - Resume from the next round (round = saved round + 1)
     - Log: "Recovered from context compaction. Resuming at Round N."
3. Read recent experiment results (check output directories, logs)
4. Identify current weaknesses and open TODOs from prior reviews
5. Initialize round counter = 1 (unless recovered from state file)
6. Create/update `review-stage/AUTO_REVIEW.md` with header and timestamp
```

## Source: aris-skills-codex-claude-review-auto-review-loop

Trigger/description delta: Autonomous multi-round research review loop. Repeatedly reviews using Claude Code via claude-review MCP, implements fixes, and re-reviews until positive assessment or max rounds reached. Use when user says \"auto review loop\", \"review until it passes\", or wants autonomous iterative improvement.
Actionable imported checks:
- REVIEW_DOC: `review-stage/AUTO_REVIEW.md` (cumulative log) *(fall back to `./AUTO_REVIEW.md` for legacy projects)*
- **OUTPUT_DIR = `review-stage/`** — Directory for review output files.
- **REVIEWER_MODEL = `claude-review`** — Claude reviewer invoked through the local `claude-review` MCP bridge. Set `CLAUDE_REVIEW_MODEL` if you need a specific Claude model override.
- **Check for `review-stage/REVIEW_STATE.json`** *(fall back to `./REVIEW_STATE.json` if not found — legacy path)*:
- If neither path exists: **fresh start** (normal case, identical to behavior before this feature existed)
- If it exists AND `status` is `"in_progress"` AND `timestamp` is within 24 hours: **resume**
- Read `review-stage/AUTO_REVIEW.md` to restore full context of prior rounds *(fall back to `./AUTO_REVIEW.md`)*
- If `pending_experiments` is non-empty, check if they have completed (e.g., check screen sessions)
- Resume from the next round (round = saved round + 1)
- Read project narrative documents, memory files, and any prior review documents
- Read recent experiment results (check output directories, logs)
- Identify current weaknesses and open TODOs from prior reviews
- Create/update `review-stage/AUTO_REVIEW.md` with header and timestamp
- **Approval** ("go", "continue", "ok", "proceed"): proceed to Phase C with all suggested fixes
- **Custom instructions** (any other text): treat as additional/replacement guidance for Phase C. Merge with reviewer suggestions where appropriate
- Send a `review_scored` notification: "Round N: X/10 — [verdict]" with top 3 weaknesses
- If **interactive** mode and verdict is "almost": send as checkpoint, wait for user reply on whether to continue or stop
- **Documentation**: Update project notes and review document
Workflow excerpt to incorporate:
```text
## Workflow
### Initialization
1. **Check for `review-stage/REVIEW_STATE.json`** *(fall back to `./REVIEW_STATE.json` if not found — legacy path)*:
   - If neither path exists: **fresh start** (normal case, identical to behavior before this feature existed)
   - If it exists AND `status` is `"completed"`: **fresh start** (previous loop finished normally)
   - If it exists AND `status` is `"in_progress"` AND `timestamp` is older than 24 hours: **fresh start** (stale state from a killed/abandoned run — delete the file and start over)
   - If it exists AND `status` is `"in_progress"` AND `timestamp` is within 24 hours: **resume**
     - Read the state file to recover `round`, `thread_id`, `last_score`, `pending_experiments`
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

## Source: aris-skills-codex-gemini-review-auto-review-loop

Trigger/description delta: Autonomous multi-round research review loop. Repeatedly reviews using Gemini via gemini-review MCP, implements fixes, and re-reviews until positive assessment or max rounds reached. Use when user says \"auto review loop\", \"review until it passes\", or wants autonomous iterative improvement.
Actionable imported checks:
- REVIEW_DOC: `review-stage/AUTO_REVIEW.md` (cumulative log) *(fall back to `./AUTO_REVIEW.md` for legacy projects)*
- **OUTPUT_DIR = `review-stage/`** — Directory for review output files.
- **REVIEWER_MODEL = `gemini-review`** — Gemini reviewer invoked through the local `gemini-review` MCP bridge. Set `GEMINI_REVIEW_MODEL` if you need a specific Gemini model override.
- **Check for `review-stage/REVIEW_STATE.json`** *(fall back to `./REVIEW_STATE.json` if not found — legacy path)*:
- If neither path exists: **fresh start** (normal case, identical to behavior before this feature existed)
- If it exists AND `status` is `"in_progress"` AND `timestamp` is within 24 hours: **resume**
- Read `review-stage/AUTO_REVIEW.md` to restore full context of prior rounds *(fall back to `./AUTO_REVIEW.md`)*
- If `pending_experiments` is non-empty, check if they have completed (e.g., check screen sessions)
- Resume from the next round (round = saved round + 1)
- Read project narrative documents, memory files, and any prior review documents
- Read recent experiment results (check output directories, logs)
- Identify current weaknesses and open TODOs from prior reviews
- Create/update `review-stage/AUTO_REVIEW.md` with header and timestamp
- **Approval** ("go", "continue", "ok", "proceed"): proceed to Phase C with all suggested fixes
- **Custom instructions** (any other text): treat as additional/replacement guidance for Phase C. Merge with reviewer suggestions where appropriate
- Send a `review_scored` notification: "Round N: X/10 — [verdict]" with top 3 weaknesses
- If **interactive** mode and verdict is "almost": send as checkpoint, wait for user reply on whether to continue or stop
- **Documentation**: Update project notes and review document
Workflow excerpt to incorporate:
```text
## Workflow
### Initialization
1. **Check for `review-stage/REVIEW_STATE.json`** *(fall back to `./REVIEW_STATE.json` if not found — legacy path)*:
   - If neither path exists: **fresh start** (normal case, identical to behavior before this feature existed)
   - If it exists AND `status` is `"completed"`: **fresh start** (previous loop finished normally)
   - If it exists AND `status` is `"in_progress"` AND `timestamp` is older than 24 hours: **fresh start** (stale state from a killed/abandoned run — delete the file and start over)
   - If it exists AND `status` is `"in_progress"` AND `timestamp` is within 24 hours: **resume**
     - Read the state file to recover `round`, `thread_id`, `last_score`, `pending_experiments`
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
