# Synthesized Imported Variant Insights

This file is synthesized from full reads of disabled overlapping skills. Treat these notes as active guidance for the keeper skill, not as an archive. Read the source folders only when this synthesis is insufficient.

Keeper: aris-skills-codex-research-lit

## How To Apply

- Prefer the keeper skill workflow as the default path.
- Add the trigger phrases, verification checks, output contracts, and resource pointers below when they fit the task.
- If a disabled variant contains scripts, templates, references, examples, or assets, treat them as reusable resources from this keeper skill.
- Do not resurrect a disabled variant as a separate active skill unless the keeper cannot express its behavior cleanly.

## Source: aris-research-lit

Trigger/description delta: Search and analyze research papers, find related work, summarize key ideas. Use when user says "find papers", "related work", "literature review", "what does this paper say", or needs to understand academic papers.
Unique headings to preserve:
- Try to find arxiv_fetch.py
- If not found, check ARIS install
- Search for published CS/Engineering papers with quality filters
- Preflight: skip OpenAlex silently if either openalex_fetch.py or the
- `requests` Python package is unavailable. Both checks must pass before
- the script is invoked, so users without `requests` installed never see
- a stack trace from a default `/research-lit` run.
Actionable imported checks:
- **REVIEWER_BACKEND = `codex`** — Default: Codex MCP (xhigh). Override with `— reviewer: oracle-pro` for GPT-5.4 Pro via Oracle MCP. See `shared-references/reviewer-routing.md`.
- **PAPER_LIBRARY** — Local directory containing user's paper collection (PDFs). Check these paths in order:
- **If not specified**: Default to `all` — search every available source in priority order (`semantic-scholar`, `deepxiv`, `exa`, `gemini`, and `openalex` are **excluded** from `all`; they must be explicitly listed).
- **Read collections**: Check if the user has a relevant collection/folder for this topic
- **Check tags**: Look for notes tagged with relevant topics (e.g., `#diffusion-models`, `#paper-review`)
- **Locate library**: Check PAPER_LIBRARY paths for PDF files
- Check arXiv, Semantic Scholar, Google Scholar
- **Do not use Gemini-reported citation counts** — they may be inaccurate. Use S2 for authoritative citation data.
- Verify each PDF > 10 KB
- If Obsidian is available, optionally create a literature review note in the vault
- Distinguish between peer-reviewed and preprints
- **Never fail because a MCP server is not configured** — always fall back gracefully to the next data source
- Zotero/Obsidian tools may have different names depending on how the user configured the MCP server (e.g., `mcp__zotero__search` or `mcp__zotero-mcp__search_items`). Try the most common patterns and adapt.
Workflow excerpt to incorporate:
```text
## Workflow
### Step 0a: Search Zotero Library (if available)
**Skip this step entirely if Zotero MCP is not configured.**
Try calling a Zotero MCP tool (e.g., search). If it succeeds:
1. **Search by topic**: Use the Zotero search tool to find papers matching the research topic
2. **Read collections**: Check if the user has a relevant collection/folder for this topic
3. **Extract annotations**: For highly relevant papers, pull PDF highlights and notes — these represent what the user found important
4. **Export BibTeX**: Get citation data for relevant papers (useful for `/paper-write` later)
5. **Compile results**: For each relevant Zotero entry, extract:
   - Title, authors, year, venue
   - User's annotations/highlights (if any)
   - Tags the user assigned
   - Which collection it belongs to
> 📚 Zotero annotations are gold — they show what the user personally highlighted as important, which is far more valuable than generic summaries.
```
