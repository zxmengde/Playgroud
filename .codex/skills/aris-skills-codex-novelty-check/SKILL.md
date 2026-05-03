---
name: aris-skills-codex-novelty-check
description: "Verify research idea novelty against recent literature. Use when user says \"\u67e5\u65b0\", \"novelty check\", \"\u6709\u6ca1\u6709\u4eba\u505a\u8fc7\", \"check novelty\", or wants to verify a research idea is novel before implementing."
metadata:
  role: domain_specialist
---

# Novelty Check Skill

Check whether a proposed method/idea has already been done in the literature: **$ARGUMENTS**

## Constants

- REVIEWER_MODEL = `gpt-5.4` — Model used via a secondary Codex agent. Must be an OpenAI model (e.g., `gpt-5.4`, `o3`, `gpt-4o`)
- **REVIEWER_BACKEND = `codex`** — Default: Codex xhigh reviewer. Use `--reviewer: oracle-pro` only when explicitly requested; if Oracle is unavailable, warn and fall back to Codex xhigh.

## Instructions

Given a method description, systematically verify its novelty:

### Phase A: Extract Key Claims
1. Read the user's method description
2. Identify 3-5 core technical claims that would need to be novel:
   - What is the method?
   - What problem does it solve?
   - What is the mechanism?
   - What makes it different from obvious baselines?

### Phase B: Multi-Source Literature Search
For EACH core claim, search using ALL available sources:

1. **Web Search** (via `WebSearch`):
   - Search arXiv, Google Scholar, Semantic Scholar
   - Use specific technical terms from the claim
   - Try at least 3 different query formulations per claim
   - Include year filters for 2024-2026

2. **Known paper databases**: Check against:
   - ICLR 2025/2026, NeurIPS 2025, ICML 2025/2026
   - Recent arXiv preprints (2025-2026)

3. **Read abstracts**: For each potentially overlapping paper, WebFetch its abstract and related work section

### Phase C: Cross-Model Verification
Call REVIEWER_MODEL via `spawn_agent` (`spawn_agent`) with xhigh reasoning:
```
reasoning_effort: xhigh
```
Prompt should include:
- The proposed method description
- All papers found in Phase B
- Ask: "Is this method novel? What is the closest prior work? What is the delta?"

### Phase D: Novelty Report
Output a structured report:

```markdown
## Novelty Check Report

### Proposed Method
[1-2 sentence description]

### Core Claims
1. [Claim 1] — Novelty: HIGH/MEDIUM/LOW — Closest: [paper]
2. [Claim 2] — Novelty: HIGH/MEDIUM/LOW — Closest: [paper]
...

### Closest Prior Work
| Paper | Year | Venue | Overlap | Key Difference |
|-------|------|-------|---------|----------------|

### Overall Novelty Assessment
- Score: X/10
- Recommendation: PROCEED / PROCEED WITH CAUTION / ABANDON
- Key differentiator: [what makes this unique, if anything]
- Risk: [what a reviewer would cite as prior work]

### Suggested Positioning
[How to frame the contribution to maximize novelty perception]
```

### Important Rules
- Be BRUTALLY honest — false novelty claims waste months of research time
- "Applying X to Y" is NOT novel unless the application reveals surprising insights
- Check both the method AND the experimental setting for novelty
- If the method is not novel but the FINDING would be, say so explicitly
- Always check the most recent 6 months of arXiv — the field moves fast

## Review Tracing

After each `spawn_agent` or optional `oracle-pro` reviewer call, save the trace following `../shared-references/review-tracing.md`. Write files directly to `.aris/traces/novelty-check/<date>_run<NN>/` and record searched claims, closest papers, reviewer route, raw response, and final novelty decision. Respect the `--- trace:` parameter when present (default: `full`).

## Consolidated ARIS Source Merge

This keeper is the active Codex-facing ARIS skill for this capability. Imported base and reviewer-overlay variants were read and folded into this keeper; source copies remain only for rollback/deep reference.

### Merged Sources
- `aris-novelty-check`: 90 lines, sha `9148d5e9f0464972`, source-overlap `0.93`. Trigger: Verify research idea novelty against recent literature. Use when user says "查新", "novelty check", "有没有人做过", "check novelty", or wants to verify a research idea is novel before implementing.
- `aris-skills-codex-claude-review-novelty-check`: 90 lines, sha `86789cf1b23644a2`, source-overlap `0.89`. Trigger: Verify research idea novelty against recent literature. Use when user says \"查新\", \"novelty check\", \"有没有人做过\", \"check novelty\", or wants to verify a research idea is novel before implementing.
- `aris-skills-codex-gemini-review-novelty-check`: 90 lines, sha `5da75802ec48a0e6`, source-overlap `0.89`. Trigger: Verify research idea novelty against recent literature. Use when user says \"查新\", \"novelty check\", \"有没有人做过\", \"check novelty\", or wants to verify a research idea is novel before implementing.

### Retained Operating Rules
- Keep review rounds, reviewer backend, score/verdict, unresolved weaknesses, and next fixes in a durable review log.
- Do not treat a positive review as evidence unless the reviewed artifacts and reviewer scope are named.
- Source-specific retained points from `aris-novelty-check`:
  - REVIEWER_MODEL = `gpt-5.4` — Model used via Codex MCP. Must be an OpenAI model (e.g., `gpt-5.4`, `o3`, `gpt-4o`)
  - Call REVIEWER_MODEL via Codex MCP (`mcp__codex__codex`) with xhigh reasoning:
  - config: {"model_reasoning_effort": "xhigh"}
  - After each `mcp__codex__codex` or `mcp__codex__codex-reply` reviewer call, save the trace following `shared-references/review-tracing.md`. Use `tools/save_trace.sh` or write files directly to `.aris/traces/<skill>/<date>
- Source-specific retained points from `aris-skills-codex-claude-review-novelty-check`:
  - > Override for Codex users who want **Claude Code**, not a second Codex agent, to act as the reviewer. Install this package **after** `skills/skills-codex/*`.
  - **REVIEWER_MODEL = `claude-review`** — Claude reviewer invoked through the local `claude-review` MCP bridge. Set `CLAUDE_REVIEW_MODEL` if you need a specific Claude model override.
  - Call REVIEWER_MODEL via `mcp__claude-review__review_start` with high-rigor review:
  - mcp__claude-review__review_start:
- Source-specific retained points from `aris-skills-codex-gemini-review-novelty-check`:
  - > Override for Codex users who want **Gemini**, not a second Codex agent, to act as the reviewer. Install this package **after** `skills/skills-codex/*`.
  - **REVIEWER_MODEL = `gemini-review`** — Gemini reviewer invoked through the local `gemini-review` MCP bridge. Set `GEMINI_REVIEW_MODEL` if you need a specific Gemini model override.
  - Call REVIEWER_MODEL via `mcp__gemini-review__review_start` with high-rigor review:
  - mcp__gemini-review__review_start:

### Merge Discipline
- Do not reactivate the imported ARIS/base/reviewer variant as a separate skill for ordinary use.
- If a source-specific retained point is stronger than the keeper text, apply that point directly in the task output.
- If a reviewer-overlay source names Claude or Gemini backends, treat that as an explicit alternate reviewer route only when the user asks for that backend or the local environment exposes it; default Codex work should not auto-open external reviewers.
- If the task touches external services, notifications, paid compute, or credentials, state the boundary and obtain authorization when required.
