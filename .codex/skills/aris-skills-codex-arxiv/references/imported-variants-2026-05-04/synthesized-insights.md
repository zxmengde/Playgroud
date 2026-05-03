# Synthesized Imported Variant Insights

This file is synthesized from full reads of disabled overlapping skills. Treat these notes as active guidance for the keeper skill, not as an archive. Read the source folders only when this synthesis is insufficient.

Keeper: aris-skills-codex-arxiv

## How To Apply

- Prefer the keeper skill workflow as the default path.
- Add the trigger phrases, verification checks, output contracts, and resource pointers below when they fit the task.
- If a disabled variant contains scripts, templates, references, examples, or assets, treat them as reusable resources from this keeper skill.
- Do not resurrect a disabled variant as a separate active skill unless the keeper cannot express its behavior cleanly.

## Source: aris-arxiv

Trigger/description delta: Search, download, and summarize academic papers from arXiv. Use when user says "search arxiv", "download paper", "fetch arxiv", "arxiv search", "get paper pdf", or wants to find and save papers from arXiv to the local paper library.
Actionable imported checks:
- **`- download`**: download the first result's PDF after listing
- Add a 1-second delay between consecutive downloads to avoid rate limiting
- Verify downloaded PDFs: file must be > 10 KB; warn and delete if smaller
- Rate limit: wait 1 second between consecutive PDF downloads; retry once after 5 seconds on HTTP 429
- If the arXiv API is unreachable, report the error clearly and suggest using `/research-lit` with `- sources: web` as a fallback
Workflow excerpt to incorporate:
```text
## Workflow
### Step 1: Parse Arguments
Parse `$ARGUMENTS` for directives:
- **Query or ID**: main search term or a bare arXiv ID such as `2301.07041` or `cs/0601001`
- **`- max: N`**: override MAX_RESULTS (e.g., `- max: 20`)
- **`- dir: PATH`**: override PAPER_DIR (e.g., `- dir: literature/`)
- **`- download`**: download the first result's PDF after listing
- **`- download: all`**: download PDFs for all results
If the argument matches an arXiv ID pattern (`YYMM.NNNNN` or `category/NNNNNNN`), skip the search and go directly to Step 3.
```
