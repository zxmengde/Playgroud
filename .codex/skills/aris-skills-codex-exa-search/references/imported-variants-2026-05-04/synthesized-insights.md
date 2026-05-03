# Synthesized Imported Variant Insights

This file is synthesized from full reads of disabled overlapping skills. Treat these notes as active guidance for the keeper skill, not as an archive. Read the source folders only when this synthesis is insufficient.

Keeper: aris-skills-codex-exa-search

## How To Apply

- Prefer the keeper skill workflow as the default path.
- Add the trigger phrases, verification checks, output contracts, and resource pointers below when they fit the task.
- If a disabled variant contains scripts, templates, references, examples, or assets, treat them as reusable resources from this keeper skill.
- Do not resurrect a disabled variant as a separate active skill unless the keeper cannot express its behavior cleanly.

## Source: aris-exa-search

Trigger/description delta: AI-powered web search via Exa with content extraction. Use when user says "exa search", "web search with content", "find similar pages", or needs broad web results beyond academic databases (arXiv, Semantic Scholar).
Actionable imported checks:
- **query**: The search query (required) or a URL (for `find-similar` mode)
- **include text**: Phrase that must appear in results
- **start date**: ISO 8601 date — only results after this
- **end date**: ISO 8601 date — only results before this
- Always check that `EXA_API_KEY` is set before searching
Workflow excerpt to incorporate:
```text
## Workflow
### Step 1: Parse Arguments
Parse `$ARGUMENTS` for:
- **query**: The search query (required) or a URL (for `find-similar` mode)
- **similar**: If present, use `find-similar` mode instead of search
- **max**: Override MAX_RESULTS
- **category**: `research paper`, `news`, `company`, `personal site`, `financial report`, `people`
- **content**: `highlights` (default), `text`, `summary`, `none`
- **max chars**: Max characters for content extraction
- **type**: Search type — `auto` (default), `neural`, `fast`, `instant`
- **domains**: Comma-separated include domains
- **exclude domains**: Comma-separated exclude domains
- **include text**: Phrase that must appear in results
- **exclude text**: Phrase to exclude from results
- **start date**: ISO 8601 date — only results after this
- **end date**: ISO 8601 date — only results before this
- **location**: Two-letter ISO country code
```
