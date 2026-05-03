# Synthesized Imported Variant Insights

This file is synthesized from full reads of disabled overlapping skills. Treat these notes as active guidance for the keeper skill, not as an archive. Read the source folders only when this synthesis is insufficient.

Keeper: aris-skills-codex-rebuttal

## How To Apply

- Prefer the keeper skill workflow as the default path.
- Add the trigger phrases, verification checks, output contracts, and resource pointers below when they fit the task.
- If a disabled variant contains scripts, templates, references, examples, or assets, treat them as reusable resources from this keeper skill.
- Do not resurrect a disabled variant as a separate active skill unless the keeper cannot express its behavior cleanly.

## Source: aris-rebuttal

Trigger/description delta: Workflow 4: Submission rebuttal pipeline. Parses external reviews, enforces coverage and grounding, drafts a safe text-only rebuttal under venue limits, and manages follow-up rounds. Use when user says \"rebuttal\", \"reply to reviewers\", \"ICML rebuttal\", \"OpenReview response\", or wants to answer external reviews safely.
Unique headings to preserve:
- Phase 6: Codex MCP Stress Test
- Phase 7: Finalize
Actionable imported checks:
- **per-reviewer thread responses** where each reviewer renders independently (e.g. OpenReview-style)
- **multiple reviewers** with shared and reviewer-specific concerns
- **follow-up rounds** after the initial rebuttal
- submit to OpenReview / CMT / HotCRP
- **REVIEWER_MODEL = `gpt-5.4`** — Used via Codex MCP for internal stress-testing.
- **REVIEWER_BACKEND = `codex`** — Default: Codex MCP (xhigh). Override with `— reviewer: oracle-pro` for GPT-5.4 Pro via Oracle MCP. See `shared-references/reviewer-routing.md`.
- **MAX_FOLLOWUP_ROUNDS = 3** — per reviewer thread.
- **Raw reviews** — pasted text, markdown, or PDF with reviewer IDs
- **Venue rules** — venue name, character/word limit, text-only or revised PDF allowed, rendering mode (one shared response or independent reviewer threads)
- **Provenance gate** — every factual statement maps to: `paper`, `review`, `user_confirmed_result`, `user_confirmed_derivation`, or `future_work`. No source = blocked.
- **Coverage gate** — every reviewer concern ends in: `answered`, `deferred_intentionally`, or `needs_user_input`. No issue disappears.
- If `rebuttal/REBUTTAL_STATE.md` exists → resume from recorded phase
- Otherwise → create `rebuttal/`, initialize all output documents
- Load paper, reviews, venue rules, any user-confirmed evidence
- Normalize all reviewer text into `rebuttal/REVIEWS_RAW.md` (verbatim)
- `reviewer`, `round`, `raw_anchor` (short quote)
- `reviewer_stance`: positive / swing / negative / unknown
- `reviewer_priority`: standard / pivotal
Workflow excerpt to incorporate:
```text
# Workflow 4: Rebuttal
Prepare and maintain a grounded, venue-compliant rebuttal for: **$ARGUMENTS**
```
