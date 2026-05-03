# Synthesized Imported Variant Insights

This file is synthesized from full reads of disabled overlapping skills. Treat these notes as active guidance for the keeper skill, not as an archive. Read the source folders only when this synthesis is insufficient.

Keeper: aris-skills-codex-citation-audit

## How To Apply

- Prefer the keeper skill workflow as the default path.
- Add the trigger phrases, verification checks, output contracts, and resource pointers below when they fit the task.
- If a disabled variant contains scripts, templates, references, examples, or assets, treat them as reusable resources from this keeper skill.
- Do not resurrect a disabled variant as a separate active skill unless the keeper cannot express its behavior cleanly.

## Source: aris-citation-audit

Trigger/description delta: Zero-context verification that every bibliographic entry in the paper is real, correctly attributed, and used in a context the cited paper actually supports. Uses a fresh cross-model reviewer with web/DBLP/arXiv lookup to catch hallucinated authors, wrong years, fabricated venues, version mismatches, and wrong-context citations (cite present but the cited paper does not establish the claim). Use when user says \"审查引用\", \"check citations\", \"citation audit\", \"verify references\", \"引用核对\", or before submission to ensure bibliography integrity.
Actionable imported checks:
- **Metadata correctness** — author names, year, venue, and title match canonical sources (DBLP, arXiv, ACL Anthology, Nature, OpenReview, etc.).
- After `paper-write` has produced the LaTeX draft and bib file
- After `paper-claim-audit` has verified numerical claims
- Before final `paper-compile` for submission
- **REVIEWER_MODEL = `gpt-5.4`** — Used via Codex MCP. Default for cross-model review with web access.
- **CONTEXT_POLICY = `fresh`** — Each audit run uses a new reviewer thread (REVIEWER_BIAS_GUARD). Never `codex-reply`.
- **WEB_SEARCH = required** — The reviewer must perform real web/DBLP/arXiv lookups, not pattern-match from memory.
- **OUTPUT = `CITATION_AUDIT.md`** — Human-readable per-entry verdict report.
- Record the surrounding sentence (≥ 1 full sentence around the cite, for context check)
- `author2010example` — suggestion: prune (uncited; no local evidence of intent)
- `someone2015othercite` — suggestion: prune (uncited; no local evidence of intent)
- `third2024todo` — suggestion: check (a `% TODO: cite third2024todo` comment was found in `sections/3.related.tex`)
- Verifier gates and downstream skills (`paper-writing` Phase 6, `tools/verify_paper_audits.sh`) MUST NOT treat the presence of `uncited_entries` as a blocking signal.
- Pre-submission cleanup (drop dead bib entries before sharing camera-ready ZIP).
- Verifier gates and downstream skills MUST treat `unavailable` the same as the field being absent: not blocking.
- **Fresh reviewer thread per audit run** — never reuse prior review context
- **Web access required** — the reviewer must do real lookups, not memory pattern-match
- **REPLACE/REMOVE require human approval** — never auto-modify content claims
Workflow excerpt to incorporate:
```text
## Workflow
### Step 1: Discover bib file and section files
Locate:
- `references.bib` (or `paper.bib` / similar) under the paper directory
- All `*.tex` files containing `\cite{...}` calls (typically `sec/` or `sections/`)
If multiple bib files exist, audit each separately.
```
