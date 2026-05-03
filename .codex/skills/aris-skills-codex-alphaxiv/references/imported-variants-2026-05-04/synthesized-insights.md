# Synthesized Imported Variant Insights

This file is synthesized from full reads of disabled overlapping skills. Treat these notes as active guidance for the keeper skill, not as an archive. Read the source folders only when this synthesis is insufficient.

Keeper: aris-skills-codex-alphaxiv

## How To Apply

- Prefer the keeper skill workflow as the default path.
- Add the trigger phrases, verification checks, output contracts, and resource pointers below when they fit the task.
- If a disabled variant contains scripts, templates, references, examples, or assets, treat them as reusable resources from this keeper skill.
- Do not resurrect a disabled variant as a separate active skill unless the keeper cannot express its behavior cleanly.

## Source: aris-alphaxiv

Trigger/description delta: Quick single-paper lookup via AlphaXiv LLM-optimized summaries with tiered source fallback. Use when user says "explain this paper", "summarize paper", pastes an arXiv/AlphaXiv URL, or provides a bare arXiv ID for quick understanding - not for broad literature search.
Actionable imported checks:
- **Overview first**: `overview` is the fastest path and must always be tried before deeper tiers. Only escalate when needed.
- **Minimal reads**: At `src` tier, read only the files that answer the question. Full-tree reads waste tokens.
- **Complementary, not competing**: This skill complements `/arxiv` (search + download) and `/deepxiv` (progressive reading). Do not re-implement their functionality.
Workflow excerpt to incorporate:
```text
## Workflow
### Step 1: Parse Arguments & Extract Paper ID
Parse `$ARGUMENTS` to extract a bare arXiv paper ID. Accept these input formats:
- `https://arxiv.org/abs/2401.12345` or `https://arxiv.org/abs/2401.12345v2`
- `https://arxiv.org/pdf/2401.12345`
- `https://alphaxiv.org/overview/2401.12345`
- `https://alphaxiv.org/abs/2401.12345`
- `2401.12345` or `2401.12345v2`
Strip version suffixes (`v1`, `v2`, ...) for API calls. Store as `PAPER_ID`.
Parse optional directives:
- **`- depth: overview|abs|src`**: force a specific tier instead of cascading
```
