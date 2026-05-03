---
name: aris-skills-codex-research-review
description: "Get a deep critical review of research from GPT using a secondary Codex agent. Use when user says \"review my research\", \"help me review\", \"get external review\", or wants critical feedback on research ideas, papers, or experimental results."
metadata:
  role: stage_specialist
---

# Research Review via a secondary Codex agent (xhigh reasoning)

Get a multi-round critical review of research work from an external LLM with maximum reasoning depth.

## Constants

- REVIEWER_MODEL = `gpt-5.4` — Model used via a secondary Codex agent. Must be an OpenAI model (e.g., `gpt-5.4`, `o3`, `gpt-4o`)
- **REVIEWER_BACKEND = `codex`** — Default: Codex xhigh reviewer. Use `--reviewer: oracle-pro` only when explicitly requested; if Oracle is unavailable, warn and fall back to Codex xhigh.

## Context: $ARGUMENTS

## Prerequisites

- Use `spawn_agent` and `send_input` when the user has explicitly allowed delegation or subagents.
- If delegation is not allowed, run the same review loop locally and preserve the same deliverable structure.

## Workflow

### Step 1: Gather Research Context
Before calling the external reviewer, compile a comprehensive briefing:
1. Read project narrative documents (e.g., STORY.md, README.md, paper drafts)
2. Read any memory/notes files for key findings and experiment history
3. Identify: core claims, methodology, key results, known weaknesses

### Step 2: Initial Review (Round 1)
Send a detailed prompt with xhigh reasoning:

```
spawn_agent:
  reasoning_effort: xhigh
  message: |
    [Full research context + specific questions]
    Please act as a senior ML reviewer (NeurIPS/ICML level). Identify:
    1. Logical gaps or unjustified claims
    2. Missing experiments that would strengthen the story
    3. Narrative weaknesses
    4. Whether the contribution is sufficient for a top venue
    Please be brutally honest.
```

### Step 3: Iterative Dialogue (Rounds 2-N)
Use `send_input` with the returned agent id to continue the conversation:

```text
send_input:
  target: [saved reviewer id from Step 2]
  message: |
    Please continue the review using the revised materials below.

    Revised files:
    - /absolute/path/to/file1
    - /absolute/path/to/file2

    Focus on unresolved weaknesses and whether the revision actually fixed them.
```

For each round:
1. **Respond** to criticisms with evidence/counterarguments
2. **Ask targeted follow-ups** on the most actionable points
3. **Request specific deliverables**: experiment designs, paper outlines, claims matrices

Key follow-up patterns:
- "If we reframe X as Y, does that change your assessment?"
- "What's the minimum experiment to satisfy concern Z?"
- "Please design the minimal additional experiment package (highest acceptance lift per GPU week)"
- "Please write a mock NeurIPS/ICML review with scores"
- "Give me a results-to-claims matrix for possible experimental outcomes"

### Step 4: Convergence
Stop iterating when:
- Both sides agree on the core claims and their evidence requirements
- A concrete experiment plan is established
- The narrative structure is settled

### Step 5: Document Everything
Save the full interaction and conclusions to a review document in the project root:
- Round-by-round summary of criticisms and responses
- Final consensus on claims, narrative, and experiments
- Claims matrix (what claims are allowed under each possible outcome)
- Prioritized TODO list with estimated compute costs
- Paper outline if discussed

Update project memory/notes with key review conclusions.

### Step 6: Review Tracing

Save a trace for every `spawn_agent`, `send_input`, or `oracle-pro` review call following `../shared-references/review-tracing.md`. Record the reviewer route, saved agent id, prompt summary, raw response path, decisions, and action items. This preserves the Claude mainline Review Tracing semantics while using Codex-native reviewer calls.

## Key Rules

- ALWAYS use `reasoning_effort: xhigh` for reviews
- Send comprehensive context in Round 1 — the external model cannot read your files
- Be honest about weaknesses — hiding them leads to worse feedback
- Push back on criticisms you disagree with, but accept valid ones
- Focus on ACTIONABLE feedback — "what experiment would fix this?"
- Document the agent id for potential future resumption
- The review document should be self-contained (readable without the conversation)

## Prompt Templates

### For initial review:
"I'm going to present a complete ML research project for your critical review. Please act as a senior ML reviewer (NeurIPS/ICML level)..."

### For experiment design:
"Please design the minimal additional experiment package that gives the highest acceptance lift per GPU week. Our compute: [describe]. Be very specific about configurations."

### For paper structure:
"Please turn this into a concrete paper outline with section-by-section claims and figure plan."

### For claims matrix:
"Please give me a results-to-claims matrix: what claim is allowed under each possible outcome of experiments X and Y?"

### For mock review:
"Please write a mock NeurIPS review with: Summary, Strengths, Weaknesses, Questions for Authors, Score, Confidence, and What Would Move Toward Accept."



## Merged External Review Rules

Apply these rules for research review. They are synthesized from base, Claude-review, and Gemini-review variants.

- Before asking for external review, prepare a self-contained briefing: narrative, method, claims, key results, evidence files, known weaknesses, and requested deliverables.
- Default to the local Codex/OpenAI reviewer path when available. Claude-review or Gemini-review bridges are optional overlays, not separate skills.
- Ask reviewers for concrete outputs: mock venue review with scores, claim/evidence audit, experiment suggestions, paper outline critique, or rebuttal risks.
- Respond to criticisms with evidence or counterarguments, then revise claims or experiments until the evidence requirements are explicit.
- Never claim a review is complete if the review document cannot be read without the conversation.
- Read references/imported-variants-2026-05-04/synthesized-insights.md for reviewer routing details and overlay-specific MCP names.

## Consolidated ARIS Source Merge

This keeper is the active Codex-facing ARIS skill for this capability. Imported base and reviewer-overlay variants were read and folded into this keeper; source copies remain only for rollback/deep reference.

### Merged Sources
- `aris-research-review`: 111 lines, sha `10e19e0f3974b50a`, source-overlap `0.80`. Trigger: Get a deep critical review of research from GPT via Codex MCP. Use when user says "review my research", "help me review", "get external review", or wants critical feedback on research ideas, papers, or experimental results.
- `aris-skills-codex-claude-review-research-review`: 110 lines, sha `5a2961d108f4fbe3`, source-overlap `0.79`. Trigger: Get a deep critical review of research from Claude via claude-review MCP. Use when user says \"review my research\", \"help me review\", \"get external review\", or wants critical feedback on research ideas, papers, or experimental results.
- `aris-skills-codex-gemini-review-research-review`: 110 lines, sha `fffa9b4ec91ffd6e`, source-overlap `0.79`. Trigger: Get a deep critical review of research from Gemini via gemini-review MCP. Use when user says \"review my research\", \"help me review\", \"get external review\", or wants critical feedback on research ideas, papers, or experimental results.

### Retained Operating Rules
- Keep review rounds, reviewer backend, score/verdict, unresolved weaknesses, and next fixes in a durable review log.
- Do not treat a positive review as evidence unless the reviewed artifacts and reviewer scope are named.
- Source-specific retained points from `aris-research-review`:
  - Research Review via Codex MCP (xhigh reasoning)
  - REVIEWER_MODEL = `gpt-5.4` — Model used via Codex MCP. Must be an OpenAI model (e.g., `gpt-5.4`, `o3`, `gpt-4o`)
  - **REVIEWER_BACKEND = `codex`** — Default: Codex MCP (xhigh). Override with `— reviewer: oracle-pro` for GPT-5.4 Pro via Oracle MCP. See `shared-references/reviewer-routing.md`.
  - **Codex MCP Server** configured in Claude Code:
- Source-specific retained points from `aris-skills-codex-claude-review-research-review`:
  - > Override for Codex users who want **Claude Code**, not a second Codex agent, to act as the reviewer. Install this package **after** `skills/skills-codex/*`.
  - Research Review via `claude-review` MCP (high-rigor review)
  - **REVIEWER_MODEL = `claude-review`** — Claude reviewer invoked through the local `claude-review` MCP bridge. Set `CLAUDE_REVIEW_MODEL` if you need a specific Claude model override.
  - Install the base Codex-native skills first: copy `skills/skills-codex/*` into `~/.codex/skills/`.
- Source-specific retained points from `aris-skills-codex-gemini-review-research-review`:
  - > Override for Codex users who want **Gemini**, not a second Codex agent, to act as the reviewer. Install this package **after** `skills/skills-codex/*`.
  - Research Review via `gemini-review` MCP (high-rigor review)
  - **REVIEWER_MODEL = `gemini-review`** — Gemini reviewer invoked through the local `gemini-review` MCP bridge. Set `GEMINI_REVIEW_MODEL` if you need a specific Gemini model override.
  - Install the base Codex-native skills first: copy `skills/skills-codex/*` into `~/.codex/skills/`.

### Merge Discipline
- Do not reactivate the imported ARIS/base/reviewer variant as a separate skill for ordinary use.
- If a source-specific retained point is stronger than the keeper text, apply that point directly in the task output.
- If a reviewer-overlay source names Claude or Gemini backends, treat that as an explicit alternate reviewer route only when the user asks for that backend or the local environment exposes it; default Codex work should not auto-open external reviewers.
- If the task touches external services, notifications, paid compute, or credentials, state the boundary and obtain authorization when required.
