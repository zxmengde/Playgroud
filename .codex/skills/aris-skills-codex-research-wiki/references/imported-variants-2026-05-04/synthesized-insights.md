# Synthesized Imported Variant Insights

This file is synthesized from full reads of disabled overlapping skills. Treat these notes as active guidance for the keeper skill, not as an archive. Read the source folders only when this synthesis is insufficient.

Keeper: aris-skills-codex-research-wiki

## How To Apply

- Prefer the keeper skill workflow as the default path.
- Add the trigger phrases, verification checks, output contracts, and resource pointers below when they fit the task.
- If a disabled variant contains scripts, templates, references, examples, or assets, treat them as reusable resources from this keeper skill.
- Do not resurrect a disabled variant as a separate active skill unless the keeper cannot express its behavior cleanly.

## Source: aris-research-wiki

Trigger/description delta: Persistent research knowledge base that accumulates papers, ideas, experiments, claims, and their relationships across the entire research lifecycle. Inspired by Karpathy's LLM Wiki pattern. Use when user says \"知识库\", \"research wiki\", \"add paper\", \"wiki query\", \"查知识库\", or wants to build/query a persistent field map.
Actionable imported checks:
- **Check dedup** — skip an existing page unless `--update-on-exist`
- diagnostic — `tools/verify_wiki_coverage.sh`
- **Reviewer independence applies.** When the wiki is read by cross-model review skills, pass file paths only — do not summarize wiki content for the reviewer.
