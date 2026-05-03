# Synthesized Imported Variant Insights

This file is synthesized from full reads of disabled overlapping skills. Treat these notes as active guidance for the keeper skill, not as an archive. Read the source folders only when this synthesis is insufficient.

Keeper: aris-skills-codex-idea-discovery

## How To Apply

- Prefer the keeper skill workflow as the default path.
- Add the trigger phrases, verification checks, output contracts, and resource pointers below when they fit the task.
- If a disabled variant contains scripts, templates, references, examples, or assets, treat them as reusable resources from this keeper skill.
- Do not resurrect a disabled variant as a separate active skill unless the keeper cannot express its behavior cleanly.

## Source: aris-idea-discovery

Trigger/description delta: Workflow 1: Full idea discovery pipeline. Orchestrates research-lit → idea-creator → novelty-check → research-review to go from a broad research direction to validated, pilot-tested ideas. Use when user says \"找idea全流程\", \"idea discovery pipeline\", \"从零开始找方向\", or wants the complete idea exploration workflow.
Unique headings to preserve:
- If $ARGUMENTS already contains "— sources:", pass through unchanged
- (the user is in control of source selection):
- Otherwise (the common case), include gemini explicitly for broader discovery:
Actionable imported checks:
- **AUTO_PROCEED = true** — If user doesn't respond at a checkpoint, automatically proceed with the best option after presenting results. Set to `false` to always wait for explicit user confirmation.
- **REVIEWER_MODEL = `gpt-5.4`** — Model used via Codex MCP. Must be an OpenAI model (e.g., `gpt-5.4`, `o3`, `gpt-4o`). Passed to sub-skills.
- **OUTPUT_DIR = `idea-stage/`** — All idea-stage outputs go here. Create the directory if it doesn't exist.
- Output a literature summary (saved to working notes)
- If `idea-stage/REF_PAPER_SUMMARY.md` exists, include it as context — ideas should build on, improve, or extend the reference paper
- Deep validate top ideas (full novelty check + devil's advocate)
- Output `idea-stage/IDEA_REPORT.md`
- Cross-verify with GPT-5.4 xhigh
- Check for concurrent work (last 3-6 months)
- GPT-5.4 xhigh acts as a senior reviewer (NeurIPS/ICML level)
- Iteratively refine the method via GPT-5.4 review (up to 5 rounds, until score ≥ 9)
- Output: `refine-logs/FINAL_PROPOSAL.md`, `refine-logs/EXPERIMENT_PLAN.md`, `refine-logs/EXPERIMENT_TRACKER.md`
- Must-run experiments: [N blocks]
- **Lite mode:** If reviewer score < 6 or pilot was weak, run `/research-refine` only (skip `/experiment-plan`) and note remaining risks in the report.
- Reviewer score: X/10
- Next step: implement full experiment → /auto-review-loop
- [ ] /auto-review-loop to iterate until submission-ready
- Key evidence: [pilot result]
Workflow excerpt to incorporate:
```text
# Workflow 1: Idea Discovery Pipeline
Orchestrate a complete idea discovery workflow for: **$ARGUMENTS**
```

## Source: aris-skills-codex-gemini-review-idea-discovery

Trigger/description delta: Workflow 1: Full idea discovery pipeline. Orchestrates research-lit \u2192 idea-creator \u2192 novelty-check \u2192 research-review to go from a broad research direction to validated, pilot-tested ideas. Use when user says \\\"\u627eidea\u5168\u6d41\u7a0b\\\", \\\"idea discovery pipeline\\\", \\\"\u4ece\u96f6\u5f00\u59cb\u627e\u65b9\u5411\\\", or wants the complete idea exploration workflow.
Actionable imported checks:
- **AUTO_PROCEED = true** — If user doesn't respond at a checkpoint, automatically proceed with the best option after presenting results. Set to `false` to always wait for explicit user confirmation.
- **OUTPUT_DIR = `idea-stage/`** — All idea-stage outputs go here. Create the directory if it doesn't exist.
- **REVIEWER_MODEL = `gemini-review`** — Gemini reviewer invoked through the local `gemini-review` MCP bridge. Passed to the reviewer-aware sub-skills installed by this overlay.
- Output a literature summary (saved to working notes)
- Deep validate top ideas (full novelty check + devil's advocate)
- Output `idea-stage/IDEA_REPORT.md`
- Cross-verify with the Gemini-backed `/novelty-check` overlay
- Check for concurrent work (last 3-6 months)
- Gemini acts as a senior reviewer (NeurIPS/ICML level) via the local `gemini-review` MCP bridge
- Iteratively refine the method via Gemini review (up to 5 rounds, until score ≥ 9)
- Output: `refine-logs/FINAL_PROPOSAL.md`, `refine-logs/EXPERIMENT_PLAN.md`, `refine-logs/EXPERIMENT_TRACKER.md`
- Must-run experiments: [N blocks]
- **Lite mode:** If reviewer score < 6 or pilot was weak, run `/research-refine` only (skip `/experiment-plan`) and note remaining risks in the report.
- Reviewer score: X/10
- Next step: implement full experiment → /auto-review-loop
- [ ] /auto-review-loop to iterate until submission-ready
- **Large file handling**: If the Write tool fails due to file size, immediately retry using Bash (`cat << 'EOF' > file`) to write in chunks. Do NOT ask the user for permission — just do it silently.
- **Checkpoint between phases.** Briefly summarize what was found before moving on.
Workflow excerpt to incorporate:
```text
# Workflow 1: Idea Discovery Pipeline
Orchestrate a complete idea discovery workflow for: **$ARGUMENTS**
```
