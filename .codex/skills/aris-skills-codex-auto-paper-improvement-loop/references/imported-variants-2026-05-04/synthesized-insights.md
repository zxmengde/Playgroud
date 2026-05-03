# Synthesized Imported Variant Insights

This file is synthesized from full reads of disabled overlapping skills. Treat these notes as active guidance for the keeper skill, not as an archive. Read the source folders only when this synthesis is insufficient.

Keeper: aris-skills-codex-auto-paper-improvement-loop

## How To Apply

- Prefer the keeper skill workflow as the default path.
- Add the trigger phrases, verification checks, output contracts, and resource pointers below when they fit the task.
- If a disabled variant contains scripts, templates, references, examples, or assets, treat them as reusable resources from this keeper skill.
- Do not resurrect a disabled variant as a separate active skill unless the keeper cannot express its behavior cleanly.

## Source: aris-auto-paper-improvement-loop

Trigger/description delta: Autonomously improve a generated paper via GPT-5.4 xhigh review → implement fixes → recompile, for 2 rounds. Use when user says \"改论文\", \"improve paper\", \"论文润色循环\", \"auto improve\", or wants to iteratively polish a generated paper.
Unique headings to preserve:
- Optional: Style reference (`— style-ref: <source>`, opt-in)
Actionable imported checks:
- **REVIEWER_MODEL = `gpt-5.4`** — Model used via Codex MCP for paper review.
- **REVIEW_LOG = `PAPER_IMPROVEMENT_LOG.md`** — Cumulative log of all rounds, stored in paper directory.
- **All section `.tex` files** — concatenated for review prompt
- Every round starts with `mcp__codex__codex`, not `mcp__codex__codex-reply`.
- Never pass a prior threadId into the next review prompt.
- Never include "since last round", "we fixed", "after applying", or any fix summary in the reviewer prompt.
- The only acceptable evidence of improvement is the current `.tex` source and compiled PDF.
- If a fix cannot be observed in the files, the reviewer should not be told it happened.
- If recovery metadata is needed, store the returned threadId for crash recovery only; do not use it to preserve review context.
- **Visual Review** (from the PDF):
- Classify files by `main.tex` input order: files before `\appendix` are main body; files after `\appendix` are appendix.
- Six named drift signatures classified by reviewer: `conditional_loss`, `scope_change`, `quantifier_loss`, `regime_envelope_change`, `constant_change`, `variable_rename`.
- **Visual Review** (from the PDF):
- Prompt: "Now defend the paper against the attack memo. For each rejection point, classify it as already fixed, partially fixed, or still unresolved, and cite the current files. Do not reuse prior review context."
- Append any novel unresolved attack point to the Step 6 fix list before implementation.
- If the defense shows the issue is already fixed in the current files, only downgrade after verifying the file evidence.
- If `HUMAN_CHECKPOINT = true`, include the merged findings in the checkpoint summary before asking the user to proceed.
- `main_round1.pdf` — After Round 1 fixes
Workflow excerpt to incorporate:
```text
## Workflow
### Step 0: Preserve Original
```bash
cp paper/main.pdf paper/main_round0_original.pdf
```
```

## Source: aris-skills-codex-claude-review-auto-paper-improvement-loop

Trigger/description delta: Autonomously improve a generated paper via Claude review through claude-review MCP → implement fixes → recompile, for 2 rounds. Use when user says \"改论文\", \"improve paper\", \"论文润色循环\", \"auto improve\", or wants to iteratively polish a generated paper.
Unique headings to preserve:
- 2. Overfull hbox warnings (content exceeding margins)
- 3. Underfull hbox warnings (loose spacing)
- 4. Bad boxes summary
- Output Protocols
Actionable imported checks:
- **REVIEWER_MODEL = `claude-review`** — Claude reviewer invoked through the local `claude-review` MCP bridge. Set `CLAUDE_REVIEW_MODEL` if you need a specific Claude model override.
- **REVIEW_LOG = `PAPER_IMPROVEMENT_LOG.md`** — Cumulative log of all rounds, stored in paper directory.
- **All section `.tex` files** — concatenated for review prompt
- `main_round1.pdf` — After Round 1 fixes
- `main_round2.pdf` — Final version after Round 2 fixes
- **After each round**: Send `review_scored` — "Round N: X/10 — [key changes]"
- **After final round**: Send `pipeline_done` — score progression table + final page count
- **Large file handling**: If the Write tool fails due to file size, immediately retry using Bash (`cat << 'EOF' > file`) to write in chunks. Do NOT ask the user for permission — just do it silently.
- **Save FULL raw review text** — do not summarize or truncate Claude reviewer responses
- **Use `mcp__claude-review__review_reply_start` plus `mcp__claude-review__review_status`** for Round 2 to maintain conversation context
- **Always recompile after fixes** — verify 0 errors before proceeding
- **Do not fabricate experimental results** — synthetic validation must describe methodology, not invent numbers
- **Global consistency** — when renaming notation or softening claims, check ALL files (abstract, intro, method, experiments, theory sections, conclusion, tables, figure captions)
Workflow excerpt to incorporate:
```text
## Workflow
### Step 0: Preserve Original
```bash
cp paper/main.pdf paper/main_round0_original.pdf
```
```

## Source: aris-skills-codex-gemini-review-auto-paper-improvement-loop

Trigger/description delta: Autonomously improve a generated paper via Gemini review through gemini-review MCP → implement fixes → recompile, for 2 rounds. Use when user says \"改论文\", \"improve paper\", \"论文润色循环\", \"auto improve\", or wants to iteratively polish a generated paper.
Unique headings to preserve:
- 2. Overfull hbox warnings (content exceeding margins)
- 3. Underfull hbox warnings (loose spacing)
- 4. Bad boxes summary
- Output Protocols
Actionable imported checks:
- **REVIEWER_MODEL = `gemini-review`** — Gemini reviewer invoked through the local `gemini-review` MCP bridge. Set `GEMINI_REVIEW_MODEL` if you need a specific Gemini model override.
- **REVIEW_LOG = `PAPER_IMPROVEMENT_LOG.md`** — Cumulative log of all rounds, stored in paper directory.
- **All section `.tex` files** — concatenated for review prompt
- `main_round1.pdf` — After Round 1 fixes
- `main_round2.pdf` — Final version after Round 2 fixes
- **After each round**: Send `review_scored` — "Round N: X/10 — [key changes]"
- **After final round**: Send `pipeline_done` — score progression table + final page count
- **Large file handling**: If the Write tool fails due to file size, immediately retry using Bash (`cat << 'EOF' > file`) to write in chunks. Do NOT ask the user for permission — just do it silently.
- **Save FULL raw review text** — do not summarize or truncate Gemini reviewer responses
- **Use `mcp__gemini-review__review_reply_start` plus `mcp__gemini-review__review_status`** for Round 2 to maintain conversation context
- **Always recompile after fixes** — verify 0 errors before proceeding
- **Do not fabricate experimental results** — synthetic validation must describe methodology, not invent numbers
- **Global consistency** — when renaming notation or softening claims, check ALL files (abstract, intro, method, experiments, theory sections, conclusion, tables, figure captions)
Workflow excerpt to incorporate:
```text
## Workflow
### Step 0: Preserve Original
```bash
cp paper/main.pdf paper/main_round0_original.pdf
```
```
