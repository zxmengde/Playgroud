# Synthesized Imported Variant Insights

This file is synthesized from full reads of disabled overlapping skills. Treat these notes as active guidance for the keeper skill, not as an archive. Read the source folders only when this synthesis is insufficient.

Keeper: aris-skills-codex-paper-write

## How To Apply

- Prefer the keeper skill workflow as the default path.
- Add the trigger phrases, verification checks, output contracts, and resource pointers below when they fit the task.
- If a disabled variant contains scripts, templates, references, examples, or assets, treat them as reusable resources from this keeper skill.
- Do not resurrect a disabled variant as a separate active skill unless the keeper cannot express its behavior cleanly.

## Source: aris-paper-write

Trigger/description delta: Draft LaTeX paper section by section from an outline. Use when user says \"写论文\", \"write paper\", \"draft LaTeX\", \"开始写\", or wants to generate LaTeX content from a paper plan.
Reusable resources: templates
Unique headings to preserve:
- Optional: Style reference (`— style-ref: <source>`, opt-in)
Actionable imported checks:
- **REVIEWER_MODEL = `gpt-5.4`** — Model used via Codex MCP for section review. Must be an OpenAI model.
- **ANONYMOUS = true** — If true, use anonymous author block. Set `false` for camera-ready. Note: most IEEE venues do NOT use anonymous submission — set `false` for IEEE.
- **PAPER_PLAN.md** — outline with claims-evidence matrix, section plan, figure plan (from `/paper-plan`)
- Read `../shared-references/writing-principles.md` before drafting the Abstract, Introduction, Related Work, or when prose feels generic.
- Read `../shared-references/venue-checklists.md` during the final write-up and submission-readiness pass.
- **Read the plan** — what claims, evidence, citations belong here
- Use the 5-part flow from `../shared-references/writing-principles.md`: what, why hard, how, evidence, strongest result
- Must be self-contained (understandable without reading the paper)
- 150-250 words (check venue limit)
- Give a brief approach overview before the reader gets lost in details
- Preview the strongest result early instead of saving it for the experiments section
- Methods should begin by page 2-3 at the latest
- **MINIMUM 1 full page** (3-4 substantive paragraphs). Short related work sections are a common reviewer complaint.
- Organize methodologically, by assumption class, or by research question; do not write paper-by-paper mini-summaries
- Do NOT just list papers — synthesize and compare
- Every claim from the introduction must have supporting evidence here
- For each major experiment, make explicit what claim it supports and what the reader should notice
- Limitations (be honest — reviewers appreciate this)
Workflow excerpt to incorporate:
```text
## Workflow
### Step 0: Backup and Clean
If `paper/` already exists, back up to `paper-backup-{timestamp}/` before overwriting. Never silently destroy existing work.
```

## Source: aris-skills-codex-claude-review-paper-write

Trigger/description delta: Draft LaTeX paper section by section from an outline. Use when user says \"写论文\", \"write paper\", \"draft LaTeX\", \"开始写\", or wants to generate LaTeX content from a paper plan.
Unique headings to preserve:
- 1. Grep all \citep{...} and \citet{...} from all .tex files
- 2. Extract unique keys (handle multi-cite like \citep{a,b,c})
- Step 5: De-AI Polish (from kgraph57/paper-writer-skill)
- Output Protocols
Actionable imported checks:
- **REVIEWER_MODEL = `claude-review`** — Claude reviewer invoked through the local `claude-review` MCP bridge. Set `CLAUDE_REVIEW_MODEL` if you need a specific Claude model override.
- **PAPER_PLAN.md** — outline with claims-evidence matrix, section plan, figure plan (from `/paper-plan`)
- **Read the plan** — what claims, evidence, citations belong here
- Must be self-contained (understandable without reading the paper)
- 150-250 words (check venue limit)
- **MINIMUM 1 full page** (3-4 substantive paragraphs). Short related work sections are a common reviewer complaint.
- Do NOT just list papers — synthesize and compare
- Every claim from the introduction must have supporting evidence here
- Limitations (be honest — reviewers appreciate this)
- Check existing `.bib` files in the project/narrative docs
- **NEVER fabricate BibTeX entries** — mark unknown ones with `[VERIFY]` comment
- Every BibTeX entry must have: author, title, year, venue/journal
- Double-check year and venue for every entry
- Avoid rule-of-three lists ("X, Y, and Z" appearing repeatedly)
- Does each claim from the intro have supporting evidence?
- **Read them in sequence** — they should form a coherent narrative on their own
- **Check claim coverage** — every claim from the Claims-Evidence Matrix must appear
- **Check evidence mapping** — every experiment/figure must support a stated claim
Workflow excerpt to incorporate:
```text
## Workflow
### Step 0: Backup and Clean
If `paper/` already exists, back up to `paper-backup-{timestamp}/` before overwriting. Never silently destroy existing work.
```

## Source: aris-skills-codex-gemini-review-paper-write

Trigger/description delta: Draft LaTeX paper section by section from an outline. Use when user says \"写论文\", \"write paper\", \"draft LaTeX\", \"开始写\", or wants to generate LaTeX content from a paper plan.
Unique headings to preserve:
- 1. Grep all \citep{...} and \citet{...} from all .tex files
- 2. Extract unique keys (handle multi-cite like \citep{a,b,c})
- Step 5: De-AI Polish (from kgraph57/paper-writer-skill)
- Output Protocols
Actionable imported checks:
- **REVIEWER_MODEL = `gemini-review`** — Gemini reviewer invoked through the local `gemini-review` MCP bridge. Set `GEMINI_REVIEW_MODEL` if you need a specific Gemini model override.
- **PAPER_PLAN.md** — outline with claims-evidence matrix, section plan, figure plan (from `/paper-plan`)
- **Read the plan** — what claims, evidence, citations belong here
- Must be self-contained (understandable without reading the paper)
- 150-250 words (check venue limit)
- **MINIMUM 1 full page** (3-4 substantive paragraphs). Short related work sections are a common reviewer complaint.
- Do NOT just list papers — synthesize and compare
- Every claim from the introduction must have supporting evidence here
- Limitations (be honest — reviewers appreciate this)
- Check existing `.bib` files in the project/narrative docs
- **NEVER fabricate BibTeX entries** — mark unknown ones with `[VERIFY]` comment
- Every BibTeX entry must have: author, title, year, venue/journal
- Double-check year and venue for every entry
- Avoid rule-of-three lists ("X, Y, and Z" appearing repeatedly)
- Does each claim from the intro have supporting evidence?
- **Read them in sequence** — they should form a coherent narrative on their own
- **Check claim coverage** — every claim from the Claims-Evidence Matrix must appear
- **Check evidence mapping** — every experiment/figure must support a stated claim
Workflow excerpt to incorporate:
```text
## Workflow
### Step 0: Backup and Clean
If `paper/` already exists, back up to `paper-backup-{timestamp}/` before overwriting. Never silently destroy existing work.
```
