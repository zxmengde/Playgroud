---
name: aris-openalex
description: Search academic papers via OpenAlex API for open citation data, institutional affiliations, and funding information. Use when user says "openalex search", "search openalex", "open citation graph", or wants comprehensive academic metadata beyond arXiv/Semantic Scholar.
allowed-tools: Bash(*), Read, Write
metadata:
  role: provider_variant
---

# OpenAlex Academic Search

Search query: $ARGUMENTS

## Role & Positioning

This skill uses OpenAlex as a **comprehensive open academic graph** source:

| Skill | Source | Best for |
|-------|--------|----------|
| `/arxiv` | arXiv API | Latest preprints, cutting-edge unrefereed work |
| `/semantic-scholar` | Semantic Scholar API | Published venue papers (IEEE, ACM, Springer) with citation counts |
| `/openalex` | OpenAlex API | **Open citation graph, institutional affiliations, funding data, comprehensive metadata** |
| `/deepxiv` | DeepXiv CLI | Layered reading: search, brief, section map, section reads |
| `/exa-search` | Exa API | Broad web search: blogs, docs, news, companies, research papers |
| `/gemini-search` | Gemini MCP / CLI | AI-powered broad literature discovery |

Use OpenAlex when you want:
- **Open citation data** — fully open citation graph (no API key required for basic use)
- **Institutional affiliations** — author institutions and collaborations
- **Funding information** — NSF, NIH, and other funding sources
- **Comprehensive metadata** — topics, keywords, abstract, open access status
- **Cross-database coverage** — indexes 250M+ works from multiple sources

## Constants

- **MAX_RESULTS = 10** — Default number of results. Override with `— max: 20`.
- **DEFAULT_SORT = relevance** — Sort by relevance. Override with `— sort: citations` or `— sort: date`.
- **FETCH_SCRIPT** — `tools/openalex_fetch.py` relative to the project root.

> Overrides (append to arguments):
> - `/openalex "topic" — max: 20` — return up to 20 results
> - `/openalex "topic" — year: 2023-` — papers from 2023 onward
> - `/openalex "topic" — year: 2020-2023` — papers from 2020 to 2023
> - `/openalex "topic" — type: article` — only journal articles
> - `/openalex "topic" — type: preprint` — only preprints
> - `/openalex "topic" — open-access` — only open access papers
> - `/openalex "topic" — min-citations: 50` — minimum 50 citations
> - `/openalex "topic" — sort: citations` — sort by citation count (descending)
> - `/openalex "topic" — sort: date` — sort by publication date (newest first)

## Setup

### Prerequisites

1. **Python 3.7+** with `requests` library:
   ```bash
   pip install requests
   ```

2. **Optional: API keys** — Create `.claude/.env` in project root:
   ```bash
   # Copy from template
   cp .claude/.env.example .claude/.env

   # Edit and add your keys
   # .claude/.env
   OPENALEX_API_KEY=your-key-here
   OPENALEX_EMAIL=your-email@example.com
   ```

   Claude Code automatically loads `.claude/.env` as environment variables.

3. **Get API keys** (optional but recommended):
   - **OpenAlex API key**: Free tier $1/day (10,000 list calls, 1,000 search calls) from [openalex.org](https://openalex.org/)
   - **Email for polite pool**: Faster response times (no registration needed)

### Verify Setup

```bash
python3 tools/openalex_fetch.py search "machine learning" --max 3
```

## Workflow

### Step 1: Parse Arguments

Parse `$ARGUMENTS` for:
- **query**: The research topic (required)
- **max**: Override MAX_RESULTS
- **year**: Publication year filter (e.g., `2023-`, `2020-2023`)
- **type**: Work type filter (`article`, `preprint`, `book`, `book-chapter`, `dataset`, `dissertation`)
- **open-access**: Only include open access papers
- **min-citations**: Minimum citation count threshold
- **sort**: Sort order (`relevance`, `citations`, `date`)

### Step 2: Locate Script

```bash
SCRIPT=$(find tools/ -name "openalex_fetch.py" 2>/dev/null | head -1)
[ -z "$SCRIPT" ] && [ -f .runtime/aris/Auto-claude-code-research-in-sleep/tools/openalex_fetch.py ] && SCRIPT=".runtime/aris/Auto-claude-code-research-in-sleep/tools/openalex_fetch.py"
[ -z "$SCRIPT" ] && [ -f "$ARIS_REPO/tools/openalex_fetch.py" ] && SCRIPT="$ARIS_REPO/tools/openalex_fetch.py"
```

If not found, tell the user:
```
openalex_fetch.py not found. Run `.\scripts\codex.ps1 aris install` or make sure tools/openalex_fetch.py exists and requests is installed:
  pip install requests
```

### Step 3: Execute Search

**Basic search:**
```bash
python3 "$SCRIPT" search "QUERY" --max 10
```

**With filters:**
```bash
python3 "$SCRIPT" search "QUERY" --max 10 \
  --year 2023- \
  --type article \
  --open-access \
  --min-citations 20 \
  --sort citations
```

**Get specific work by DOI:**
```bash
python3 "$SCRIPT" work "10.1109/TWC.2024.1234567"
```

**Get specific work by OpenAlex ID:**
```bash
python3 "$SCRIPT" work "W2741809807"
```

### Step 4: Parse Results

The script returns structured JSON with:
- `title`: Paper title
- `authors`: List of author names
- `publication_year`: Year published
- `venue`: Journal/conference name
- `venue_type`: Type of venue (journal, repository, conference, etc.)
- `cited_by_count`: Number of citations
- `is_oa`: Boolean for open access status
- `oa_status`: Open access type (gold, green, bronze, hybrid, closed)
- `oa_url`: Direct PDF link if available
- `doi`: DOI identifier
- `openalex_id`: OpenAlex work ID
- `abstract`: Full abstract text
- `topics`: Top 3 research topics
- `keywords`: Top 5 keywords
- `type`: Work type (article, preprint, etc.)

### Step 5: Present Results

Format results as a structured table:

```
| # | Title | Venue | Year | Citations | OA | Summary |
|---|-------|-------|------|-----------|----|---------|
| 1 | ... | IEEE TWC | 2024 | 156 | ✓ | ... |
| 2 | ... | NeurIPS | 2023 | 89 | ✓ | ... |
```

For each paper, also show:
- **DOI**: Canonical identifier
- **OpenAlex ID**: For cross-reference
- **Open Access**: Status (gold/green/bronze/hybrid/closed) and PDF link
- **Topics**: Top research topics
- **Abstract**: First 200 characters or full text

### Step 6: Offer Follow-up

After presenting results, suggest:

```text
/semantic-scholar "DOI:..."     — get S2 citation context and related papers
/arxiv "arXiv:XXXX.XXXXX"      — fetch arXiv preprint if available
/research-lit "topic" — sources: openalex, semantic-scholar  — combined multi-source review
/novelty-check "idea"          — verify novelty against literature
```

## Key Rules

- **OpenAlex is fully open** — no API key required for basic use, but recommended for higher rate limits
- **Comprehensive metadata** — OpenAlex provides richer metadata than most sources (institutions, funding, topics)
- **Citation data is open** — unlike Semantic Scholar, all citation data is freely accessible
- **Rate limits**: Without API key, very limited (~$0.01/day). With free API key: 10,000 list calls/day, 1,000 search calls/day.
- **Polite pool**: Set `OPENALEX_EMAIL` environment variable for faster response times
- **Cross-reference with other sources**: OpenAlex indexes papers from arXiv, PubMed, Crossref, etc. — use DOI/arXiv ID to cross-reference
- If OpenAlex API is unreachable or rate-limited, suggest using `/semantic-scholar`, `/arxiv`, or `/research-lit "topic" — sources: web` as alternatives.

## OpenAlex vs Other Sources

| Feature | OpenAlex | Semantic Scholar | arXiv |
|---------|----------|------------------|-------|
| **Coverage** | 250M+ works | 200M+ papers | 2.4M+ preprints |
| **Citation data** | Fully open | Partially open | None |
| **Institutions** | ✓ Full affiliations | ✓ Limited | ✗ |
| **Funding** | ✓ NSF, NIH, etc. | ✗ | ✗ |
| **Open access** | ✓ Full OA status | ✓ PDF links | ✓ All papers |
| **API key** | Optional (free) | Optional (free) | Not required |
| **Rate limits** | 1,000 searches/day (free key) | Unknown | 1 req/3s |
| **Abstract** | ✓ Full text | ✓ TLDR | ✓ Full text |
| **Best for** | Comprehensive metadata, institutions, funding | Citation counts, venue info | Latest preprints |

**When to use OpenAlex over S2:**
- Need institutional affiliation data
- Need funding information
- Want fully open citation graph
- Need comprehensive topic/keyword metadata
- Working with non-CS fields (OpenAlex covers all disciplines)

**When to use S2 over OpenAlex:**
- Need real-time citation counts (S2 updates faster)
- Need "highly influential citations" metric
- Need paper recommendations
- CS/AI-focused research (S2 has better CS coverage)
