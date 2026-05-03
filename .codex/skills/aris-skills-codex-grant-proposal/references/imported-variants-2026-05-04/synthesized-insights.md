# Synthesized Imported Variant Insights

This file is synthesized from full reads of disabled overlapping skills. Treat these notes as active guidance for the keeper skill, not as an archive. Read the source folders only when this synthesis is insufficient.

Keeper: aris-skills-codex-grant-proposal

## How To Apply

- Prefer the keeper skill workflow as the default path.
- Add the trigger phrases, verification checks, output contracts, and resource pointers below when they fit the task.
- If a disabled variant contains scripts, templates, references, examples, or assets, treat them as reusable resources from this keeper skill.
- Do not resurrect a disabled variant as a separate active skill unless the keeper cannot express its behavior cleanly.

## Source: aris-grant-proposal

Trigger/description delta: Draft a structured grant proposal from research ideas and literature. Supports KAKENHI (Japan), NSF (US), NSFC (China, including 面上/青年/优青/杰青/海外优青/重点), ERC (EU), DFG (Germany), SNSF (Switzerland), ARC (Australia), NWO (Netherlands), and generic formats. Use when user says \"write grant\", \"grant proposal\", \"申請書\", \"write KAKENHI\", \"科研費\", \"基金申请\", \"写基金\", \"NSF proposal\", or wants to turn research ideas into a funding application.
Unique headings to preserve:
- Optional: Style reference (`— style-ref: <source>`, opt-in)
Actionable imported checks:
- Go to `/experiment-bridge` → `/auto-review-loop` → `/paper-writing` (implement & publish)
- Go to `/grant-proposal` (write funding application first, then implement after funding)
- **REVIEWER_MODEL = `gpt-5.4`** — Model used via Codex MCP for proposal review. Must be an OpenAI model (e.g., `gpt-5.4`, `o3`, `gpt-4o`).
- **OUTPUT_FORMAT = `markdown`** — Output format. Supported: `markdown`, `latex`. LaTeX uses grant-specific templates when available.
- **MAX_REVIEW_ROUNDS = 2** — Maximum external review-revise cycles before finalizing.
- **OUTPUT_DIR = `grant-proposal/`** — Directory for generated proposal files.
- **Never pass `— style-ref` (or the cache contents) to the GPT-5.4 reviewer sub-agent** when it scores the draft — the proposal must be judged on its own merits.
- If `status: "in_progress"` and within 24h → **resume** from saved phase (read `GRANT_PROPOSAL.md` and `GRANT_REVIEW.md` to restore context)
- **Overrides** — output format, language, review rounds
- Read `review-stage/AUTO_REVIEW.md` if it exists (from `/auto-review-loop` — prior review feedback is gold for grants); fall back to `./AUTO_REVIEW.md` if not found
- Check for `grant-proposal/GRANT_STATE.json` (resume from prior interrupted run)
- Has review-stage/AUTO_REVIEW.md → extract reviewer feedback and use it to strengthen the feasibility narrative
- Run `/novelty-check` on the proposed research direction to verify the gap is real:
- Reply with **adjustments** (e.g., "focus more on X", "the gap should emphasize Y") → refine and re-present
- **Concrete deliverables** — each aim maps to specific outputs (papers, datasets, tools, benchmarks)
- **What We Will Deliver**: Concrete outputs, timeline, expected publications
- Expected outputs: [papers, datasets]
- Expected outputs: [papers, tools, final report]
Workflow excerpt to incorporate:
```text
## Workflow
### Phase 0: Input Parsing & Context Gathering
Parse `$ARGUMENTS` to extract:
1. **Research direction/idea** — may reference existing files or be a freeform description
2. **Grant type** — detect from keywords (e.g., "科研費"→KAKENHI, "NSF"→NSF, "国自然"→NSFC, "基金"→NSFC)
3. **Grant sub-type** — detect from keywords (e.g., "Start-up", "若手", "青年", "CAREER", "优青", "海外优青")
4. **Overrides** — output format, language, review rounds
Then gather context from the project directory:
1. Read `idea-stage/IDEA_REPORT.md` if it exists (from `/idea-discovery`); fall back to `./IDEA_REPORT.md` if not found
2. Read `refine-logs/FINAL_PROPOSAL.md` if it exists (from `/research-refine`)
3. Read `refine-logs/EXPERIMENT_PLAN.md` if it exists (from `/experiment-plan`)
4. Read `review-stage/AUTO_REVIEW.md` if it exists (from `/auto-review-loop` — prior review feedback is gold for grants); fall back to `./AUTO_REVIEW.md` if not found
5. Read `NARRATIVE_REPORT.md` or `STORY.md` if they exist
6. Read any existing literature notes or survey documents
7. Scan for the user's publication list (e.g., `publications.md`, `cv.md`, `bio.md`, `CV.pdf`)
8. Check for `grant-proposal/GRANT_STATE.json` (resume from prior interrupted run)
If insufficient context exists:
- No research idea at all → suggest running `/idea-discovery` first
- No literature survey → will invoke `/research-lit` inline in Phase 1
- No publication list → leave PI qualification section with `[TODO: Add publications]` placeholders
- Has review-stage/AUTO_REVIEW.md → extract reviewer feedback and use it to strengthen the feasibility narrative
```

## Source: aris-skills-codex-gemini-review-grant-proposal

Trigger/description delta: Draft a structured grant proposal from research ideas and literature. Supports KAKENHI (Japan), NSF (US), NSFC (China, including 面上/青年/优青/杰青/海外优青/重点), ERC (EU), DFG (Germany), SNSF (Switzerland), ARC (Australia), NWO (Netherlands), and generic formats. Use when user says \"write grant\", \"grant proposal\", \"申請書\", \"write KAKENHI\", \"科研費\", \"基金申请\", \"写基金\", \"NSF proposal\", or wants to turn research ideas into a funding application.
Actionable imported checks:
- Go to `/experiment-bridge` → `/auto-review-loop` → `/paper-writing` (implement & publish)
- Go to `/grant-proposal` (write funding application first, then implement after funding)
- **REVIEWER_MODEL = `gemini-review`** — Gemini reviewer invoked through the local `gemini-review` MCP bridge for proposal review. Set `GEMINI_REVIEW_MODEL` if you need a specific Gemini model override.
- **OUTPUT_FORMAT = `markdown`** — Output format. Supported: `markdown`, `latex`. LaTeX uses grant-specific templates when available.
- **MAX_REVIEW_ROUNDS = 2** — Maximum external review-revise cycles before finalizing.
- **OUTPUT_DIR = `grant-proposal/`** — Directory for generated proposal files.
- If `status: "in_progress"` and within 24h → **resume** from saved phase (read `GRANT_PROPOSAL.md` and `GRANT_REVIEW.md` to restore context)
- **Overrides** — output format, language, review rounds
- Read `review-stage/AUTO_REVIEW.md` if it exists (from `/auto-review-loop` — prior review feedback is gold for grants); fall back to `./AUTO_REVIEW.md` if not found
- Check for `grant-proposal/GRANT_STATE.json` (resume from prior interrupted run)
- Has `review-stage/AUTO_REVIEW.md` → extract reviewer feedback and use it to strengthen the feasibility narrative
- Run `/novelty-check` on the proposed research direction to verify the gap is real:
- Reply with **adjustments** (e.g., "focus more on X", "the gap should emphasize Y") → refine and re-present
- **Concrete deliverables** — each aim maps to specific outputs (papers, datasets, tools, benchmarks)
- **What We Will Deliver**: Concrete outputs, timeline, expected publications
- Expected outputs: [papers, datasets]
- Expected outputs: [papers, tools, final report]
- Gemini acts as a grant review panelist (not a paper reviewer)
Workflow excerpt to incorporate:
```text
## Workflow
### Phase 0: Input Parsing & Context Gathering
Parse `$ARGUMENTS` to extract:
1. **Research direction/idea** — may reference existing files or be a freeform description
2. **Grant type** — detect from keywords (e.g., "科研費"→KAKENHI, "NSF"→NSF, "国自然"→NSFC, "基金"→NSFC)
3. **Grant sub-type** — detect from keywords (e.g., "Start-up", "若手", "青年", "CAREER", "优青", "海外优青")
4. **Overrides** — output format, language, review rounds
Then gather context from the project directory:
1. Read `idea-stage/IDEA_REPORT.md` if it exists (from `/idea-discovery`); fall back to `./IDEA_REPORT.md` if not found
2. Read `refine-logs/FINAL_PROPOSAL.md` if it exists (from `/research-refine`)
3. Read `refine-logs/EXPERIMENT_PLAN.md` if it exists (from `/experiment-plan`)
4. Read `review-stage/AUTO_REVIEW.md` if it exists (from `/auto-review-loop` — prior review feedback is gold for grants); fall back to `./AUTO_REVIEW.md` if not found
5. Read `NARRATIVE_REPORT.md` or `STORY.md` if they exist
6. Read any existing literature notes or survey documents
7. Scan for the user's publication list (e.g., `publications.md`, `cv.md`, `bio.md`, `CV.pdf`)
8. Check for `grant-proposal/GRANT_STATE.json` (resume from prior interrupted run)
If insufficient context exists:
- No research idea at all → suggest running `/idea-discovery` first
- No literature survey → will invoke `/research-lit` inline in Phase 1
- No publication list → leave PI qualification section with `[TODO: Add publications]` placeholders
- Has `review-stage/AUTO_REVIEW.md` → extract reviewer feedback and use it to strengthen the feasibility narrative
```
