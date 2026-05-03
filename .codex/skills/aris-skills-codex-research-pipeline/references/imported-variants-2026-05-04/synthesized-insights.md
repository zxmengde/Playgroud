# Synthesized Imported Variant Insights

This file is synthesized from full reads of disabled overlapping skills. Treat these notes as active guidance for the keeper skill, not as an archive. Read the source folders only when this synthesis is insufficient.

Keeper: aris-skills-codex-research-pipeline

## How To Apply

- Prefer the keeper skill workflow as the default path.
- Add the trigger phrases, verification checks, output contracts, and resource pointers below when they fit the task.
- If a disabled variant contains scripts, templates, references, examples, or assets, treat them as reusable resources from this keeper skill.
- Do not resurrect a disabled variant as a separate active skill unless the keeper cannot express its behavior cleanly.

## Source: aris-research-pipeline

Trigger/description delta: Full research pipeline: Workflow 1 (idea discovery) → implementation → Workflow 2 (auto review loop) → Workflow 3 (paper writing, optional). Goes from a broad research direction all the way to a polished PDF. Use when user says \"全流程\", \"full pipeline\", \"从找idea到投稿\", \"end-to-end research\", or wants the complete autonomous research lifecycle.
Actionable imported checks:
- **Code review**: Before deploying, do a self-review:
- Check GPU availability on configured servers
- Verify experiments started successfully
- GPT-5.4 xhigh reviews the work (score, weaknesses, minimum fixes)
- Re-review → repeat until score ≥ 6/10 or 4 rounds reached
- `AUTO_REVIEW.md` (review history, weaknesses fixed, remaining limitations)
- Key quantitative results with evidence for each claim
- Review rounds: N/4, final score: X/10
- [items flagged by reviewer that weren't addressed]
- Manual figures required: [list or none]
- If `VENUE` is missing → stop and ask. Do NOT silently use a default venue.
- If manual figures are required → pause and list them. Wait for user to add them.
- **Large file handling**: If the Write tool fails due to file size, immediately retry using Bash (`cat << 'EOF' > file`) to write in chunks. Do NOT ask the user for permission — just do it silently.
- **Human checkpoint after Stage 1 is controlled by AUTO_PROCEED.** When `false`, do not proceed without user confirmation. When `true`, auto-select the top idea after presenting results.
- **If Stage 4 ends at round 4 without positive assessment**, stop and report remaining issues. Do not loop forever.
- **Documentation**: Every stage updates its own output file. The full history should be self-contained.
- **Fail gracefully**: If any stage fails (no good ideas, experiments crash, review loop stuck), report clearly and suggest alternatives rather than forcing forward.
