# Synthesized Imported Variant Insights

This file is synthesized from full reads of disabled overlapping skills. Treat these notes as active guidance for the keeper skill, not as an archive. Read the source folders only when this synthesis is insufficient.

Keeper: aris-skills-codex-novelty-check

## How To Apply

- Prefer the keeper skill workflow as the default path.
- Add the trigger phrases, verification checks, output contracts, and resource pointers below when they fit the task.
- If a disabled variant contains scripts, templates, references, examples, or assets, treat them as reusable resources from this keeper skill.
- Do not resurrect a disabled variant as a separate active skill unless the keeper cannot express its behavior cleanly.

## Source: aris-novelty-check

Trigger/description delta: Verify research idea novelty against recent literature. Use when user says "查新", "novelty check", "有没有人做过", "check novelty", or wants to verify a research idea is novel before implementing.
Actionable imported checks:
- REVIEWER_MODEL = `gpt-5.4` — Model used via Codex MCP. Must be an OpenAI model (e.g., `gpt-5.4`, `o3`, `gpt-4o`)
- **Known paper databases**: Check against:
- Risk: [what a reviewer would cite as prior work]
- Check both the method AND the experimental setting for novelty
- Always check the most recent 6 months of arXiv — the field moves fast

## Source: aris-skills-codex-claude-review-novelty-check

Trigger/description delta: Verify research idea novelty against recent literature. Use when user says \"查新\", \"novelty check\", \"有没有人做过\", \"check novelty\", or wants to verify a research idea is novel before implementing.
Actionable imported checks:
- **REVIEWER_MODEL = `claude-review`** — Claude reviewer invoked through the local `claude-review` MCP bridge. Set `CLAUDE_REVIEW_MODEL` if you need a specific Claude model override.
- **Known paper databases**: Check against:
- Risk: [what a reviewer would cite as prior work]
- Check both the method AND the experimental setting for novelty
- Always check the most recent 6 months of arXiv — the field moves fast

## Source: aris-skills-codex-gemini-review-novelty-check

Trigger/description delta: Verify research idea novelty against recent literature. Use when user says \"查新\", \"novelty check\", \"有没有人做过\", \"check novelty\", or wants to verify a research idea is novel before implementing.
Actionable imported checks:
- **REVIEWER_MODEL = `gemini-review`** — Gemini reviewer invoked through the local `gemini-review` MCP bridge. Set `GEMINI_REVIEW_MODEL` if you need a specific Gemini model override.
- **Known paper databases**: Check against:
- Risk: [what a reviewer would cite as prior work]
- Check both the method AND the experimental setting for novelty
- Always check the most recent 6 months of arXiv — the field moves fast
