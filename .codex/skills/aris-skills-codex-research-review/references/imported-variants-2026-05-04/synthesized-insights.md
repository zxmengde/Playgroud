# Synthesized Imported Variant Insights

This file is synthesized from full reads of disabled overlapping skills. Treat these notes as active guidance for the keeper skill, not as an archive. Read the source folders only when this synthesis is insufficient.

Keeper: aris-skills-codex-research-review

## How To Apply

- Prefer the keeper skill workflow as the default path.
- Add the trigger phrases, verification checks, output contracts, and resource pointers below when they fit the task.
- If a disabled variant contains scripts, templates, references, examples, or assets, treat them as reusable resources from this keeper skill.
- Do not resurrect a disabled variant as a separate active skill unless the keeper cannot express its behavior cleanly.

## Source: aris-research-review

Trigger/description delta: Get a deep critical review of research from GPT via Codex MCP. Use when user says "review my research", "help me review", "get external review", or wants critical feedback on research ideas, papers, or experimental results.
Unique headings to preserve:
- Research Review via Codex MCP (xhigh reasoning)
- Review Tracing
Actionable imported checks:
- REVIEWER_MODEL = `gpt-5.4` — Model used via Codex MCP. Must be an OpenAI model (e.g., `gpt-5.4`, `o3`, `gpt-4o`)
- **REVIEWER_BACKEND = `codex`** — Default: Codex MCP (xhigh). Override with `— reviewer: oracle-pro` for GPT-5.4 Pro via Oracle MCP. See `shared-references/reviewer-routing.md`.
- **Codex MCP Server** configured in Claude Code:
- This gives Claude Code access to `mcp__codex__codex` and `mcp__codex__codex-reply` tools
- **Respond** to criticisms with evidence/counterarguments
- **Request specific deliverables**: experiment designs, paper outlines, claims matrices
- "Please write a mock NeurIPS/ICML review with scores"
- Both sides agree on the core claims and their evidence requirements
- ALWAYS use `config: {"model_reasoning_effort": "xhigh"}` for reviews
- The review document should be self-contained (readable without the conversation)
Workflow excerpt to incorporate:
```text
## Workflow
### Step 1: Gather Research Context
Before calling the external reviewer, compile a comprehensive briefing:
1. Read project narrative documents (e.g., STORY.md, README.md, paper drafts)
2. Read any memory/notes files for key findings and experiment history
3. Identify: core claims, methodology, key results, known weaknesses
```

## Source: aris-skills-codex-claude-review-research-review

Trigger/description delta: Get a deep critical review of research from Claude via claude-review MCP. Use when user says \"review my research\", \"help me review\", \"get external review\", or wants critical feedback on research ideas, papers, or experimental results.
Unique headings to preserve:
- Research Review via `claude-review` MCP (high-rigor review)
Actionable imported checks:
- **REVIEWER_MODEL = `claude-review`** — Claude reviewer invoked through the local `claude-review` MCP bridge. Set `CLAUDE_REVIEW_MODEL` if you need a specific Claude model override.
- Then install this overlay package: copy `skills/skills-codex-claude-review/*` into `~/.codex/skills/` and allow it to overwrite the same skill names.
- Register the local reviewer bridge:
- This gives Codex access to `mcp__claude-review__review_start`, `mcp__claude-review__review_reply_start`, and `mcp__claude-review__review_status`.
- **Respond** to criticisms with evidence/counterarguments
- **Request specific deliverables**: experiment designs, paper outlines, claims matrices
- "Please write a mock NeurIPS/ICML review with scores"
- Both sides agree on the core claims and their evidence requirements
- Always ask the Claude reviewer for strict, high-rigor feedback.
- The review document should be self-contained (readable without the conversation)
Workflow excerpt to incorporate:
```text
## Workflow
### Step 1: Gather Research Context
Before calling the external reviewer, compile a comprehensive briefing:
1. Read project narrative documents (e.g., STORY.md, README.md, paper drafts)
2. Read any memory/notes files for key findings and experiment history
3. Identify: core claims, methodology, key results, known weaknesses
```

## Source: aris-skills-codex-gemini-review-research-review

Trigger/description delta: Get a deep critical review of research from Gemini via gemini-review MCP. Use when user says \"review my research\", \"help me review\", \"get external review\", or wants critical feedback on research ideas, papers, or experimental results.
Unique headings to preserve:
- Research Review via `gemini-review` MCP (high-rigor review)
Actionable imported checks:
- **REVIEWER_MODEL = `gemini-review`** — Gemini reviewer invoked through the local `gemini-review` MCP bridge. Set `GEMINI_REVIEW_MODEL` if you need a specific Gemini model override.
- Then install this overlay package: copy `skills/skills-codex-gemini-review/*` into `~/.codex/skills/` and allow it to overwrite the same skill names.
- Register the local reviewer bridge:
- This gives Codex access to `mcp__gemini-review__review_start`, `mcp__gemini-review__review_reply_start`, and `mcp__gemini-review__review_status`.
- **Respond** to criticisms with evidence/counterarguments
- **Request specific deliverables**: experiment designs, paper outlines, claims matrices
- "Please write a mock NeurIPS/ICML review with scores"
- Both sides agree on the core claims and their evidence requirements
- Always ask the Gemini reviewer for strict, high-rigor feedback.
- The review document should be self-contained (readable without the conversation)
Workflow excerpt to incorporate:
```text
## Workflow
### Step 1: Gather Research Context
Before calling the external reviewer, compile a comprehensive briefing:
1. Read project narrative documents (e.g., STORY.md, README.md, paper drafts)
2. Read any memory/notes files for key findings and experiment history
3. Identify: core claims, methodology, key results, known weaknesses
```
