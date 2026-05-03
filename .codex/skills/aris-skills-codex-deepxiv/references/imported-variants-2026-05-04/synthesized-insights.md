# Synthesized Imported Variant Insights

This file is synthesized from full reads of disabled overlapping skills. Treat these notes as active guidance for the keeper skill, not as an archive. Read the source folders only when this synthesis is insufficient.

Keeper: aris-skills-codex-deepxiv

## How To Apply

- Prefer the keeper skill workflow as the default path.
- Add the trigger phrases, verification checks, output contracts, and resource pointers below when they fit the task.
- If a disabled variant contains scripts, templates, references, examples, or assets, treat them as reusable resources from this keeper skill.
- Do not resurrect a disabled variant as a separate active skill unless the keeper cannot express its behavior cleanly.

## Source: aris-deepxiv

Trigger/description delta: Search and progressively read open-access academic papers through DeepXiv. Use when the user wants layered paper access, section-level reading, trending papers, or DeepXiv-backed literature retrieval.
Actionable imported checks:
- Use section-level reads to save tokens.
Workflow excerpt to incorporate:
```text
## Workflow
### Step 1: Parse Arguments
Parse `$ARGUMENTS` for:
- **Query or ID**: a paper topic, arXiv ID, or Semantic Scholar ID
- **`- max: N`**: override `MAX_RESULTS`
- **`- brief`**: fetch paper brief
- **`- head`**: fetch metadata and section map
- **`- section: NAME`**: fetch one named section
- **`- trending`** or query `trending`: fetch trending papers
- **`- days: 7|14|30`**: trending time window
- **`- web`**: run DeepXiv web search
- **`- sc`**: fetch Semantic Scholar metadata by ID
If the main argument looks like an arXiv ID and no explicit mode is given, default to `- brief`.
```
