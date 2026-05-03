# Synthesized Imported Variant Insights

This file is synthesized from full reads of disabled overlapping skills. Treat these notes as active guidance for the keeper skill, not as an archive. Read the source folders only when this synthesis is insufficient.

Keeper: aris-skills-codex-auto-review-loop-llm

## How To Apply

- Prefer the keeper skill workflow as the default path.
- Add the trigger phrases, verification checks, output contracts, and resource pointers below when they fit the task.
- If a disabled variant contains scripts, templates, references, examples, or assets, treat them as reusable resources from this keeper skill.
- Do not resurrect a disabled variant as a separate active skill unless the keeper cannot express its behavior cleanly.

## Source: aris-auto-review-loop-llm

Trigger/description delta: Autonomous research review loop using any OpenAI-compatible LLM API. Configure via llm-chat MCP server or environment variables. Trigger with "auto review loop llm" or "llm review".
Actionable imported checks:
- REVIEW_DOC: `review-stage/AUTO_REVIEW.md` (cumulative log) *(fall back to `./AUTO_REVIEW.md` for legacy projects)*
- **Check `review-stage/REVIEW_STATE.json`** for recovery *(fall back to `./REVIEW_STATE.json` if not found — legacy path)*
- Read project context and prior reviews
- Set `review-stage/REVIEW_STATE.json` status to "completed"
- **Large file handling**: If the Write tool fails due to file size, immediately retry using Bash (`cat << 'EOF' > file`) to write in chunks. Do NOT ask the user for permission — just do it silently.
- **Anti-hallucination citations**: When adding references, NEVER fabricate BibTeX. Use DBLP → CrossRef → `[VERIFY]` chain. Do NOT generate BibTeX from memory.
- Implement fixes BEFORE re-reviewing
- Prefer MCP tool over curl when available
Workflow excerpt to incorporate:
```text
## Workflow
### Initialization
1. **Check `review-stage/REVIEW_STATE.json`** for recovery *(fall back to `./REVIEW_STATE.json` if not found — legacy path)*
2. Read project context and prior reviews
3. Initialize round counter
```
