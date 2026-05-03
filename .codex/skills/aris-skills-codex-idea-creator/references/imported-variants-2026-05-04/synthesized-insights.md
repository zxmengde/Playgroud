# Synthesized Imported Variant Insights

This file is synthesized from full reads of disabled overlapping skills. Treat these notes as active guidance for the keeper skill, not as an archive. Read the source folders only when this synthesis is insufficient.

Keeper: aris-skills-codex-idea-creator

## How To Apply

- Prefer the keeper skill workflow as the default path.
- Add the trigger phrases, verification checks, output contracts, and resource pointers below when they fit the task.
- If a disabled variant contains scripts, templates, references, examples, or assets, treat them as reusable resources from this keeper skill.
- Do not resurrect a disabled variant as a separate active skill unless the keeper cannot express its behavior cleanly.

## Source: aris-idea-creator

Trigger/description delta: Generate and rank research ideas given a broad direction. Use when user says "找idea", "brainstorm ideas", "generate research ideas", "what can we work on", or wants to explore a research area for publishable directions.
Actionable imported checks:
- **REVIEWER_MODEL = `gpt-5.4`** — Model used via Codex MCP for brainstorming and review. Must be an OpenAI model (e.g., `gpt-5.4`, `o3`, `gpt-4o`).
- **REVIEWER_BACKEND = `codex`** — Default: Codex MCP (xhigh). Override with `— reviewer: oracle-pro` for GPT-5.4 Pro via Oracle MCP. See `shared-references/reviewer-routing.md`.
- **OUTPUT_DIR = `idea-stage/`** — All idea-stage outputs go here. Create the directory if it doesn't exist.
- Treat failed ideas as a banlist (do NOT regenerate similar ideas)
- Treat top papers as known prior work (do not re-search them)
- **Feasibility check**: Can we actually run this experiment with available resources?
- **Novelty quick-check**: For each idea, do 2-3 targeted searches to see if it's already been done. Full `/novelty-check` comes later for survivors.
- **Impact estimation**: Would a reviewer care about the result?
- **Novelty check**: Use the `/novelty-check` workflow (multi-source search + GPT-5.4 cross-verification) for each idea
- **Critical review**: Use GPT-5.4 via `mcp__codex__codex-reply` (same thread):
- What's the strongest objection a reviewer would raise?
- **Estimate GPU-hours BEFORE launching.** If estimated time > PILOT_MAX_HOURS, reduce scale (fewer epochs, smaller subset) or flag as "needs manual pilot"
- **Collect results**: Use `/monitor-experiment` to check progress. If any pilot exceeds PILOT_TIMEOUT_HOURS, kill it and collect partial results. Once all pilots complete (or timeout), compare:
- **Re-rank based on empirical evidence**: Update the idea ranking using pilot results. An idea with strong pilot signal jumps ahead of a theoretically appealing but untested idea.
- **Reviewer's likely objection**: [strongest counterargument]
- **Why we should do this**: [1-2 sentences]
- [ ] If confirmed, invoke /auto-review-loop for full iteration
- **Large file handling**: If the Write tool fails due to file size, immediately retry using Bash (`cat << 'EOF' > file`) to write in chunks. Do NOT ask the user for permission — just do it silently.
Workflow excerpt to incorporate:
```text
## Workflow
### Phase 0: Load Research Wiki (if active)
**Skip this phase entirely if `research-wiki/` does not exist.**
```
if research-wiki/query_pack.md exists AND is less than 7 days old:
    Read query_pack.md and use it as initial landscape context:
    - Treat listed gaps as priority search seeds
    - Treat failed ideas as a banlist (do NOT regenerate similar ideas)
    - Treat top papers as known prior work (do not re-search them)
    Still run Phase 1 below for papers from the last 3-6 months (wiki may be stale)
else if research-wiki/ exists but query_pack.md is stale or missing:
    python3 tools/research_wiki.py rebuild_query_pack research-wiki/
    Then read query_pack.md as above
```
```

## Source: aris-skills-codex-gemini-review-idea-creator

Trigger/description delta: Generate and rank research ideas given a broad direction. Use when user says \"\u627eidea\", \"brainstorm ideas\", \"generate research ideas\", \"what can we work on\", or wants to explore a research area for publishable directions.
Actionable imported checks:
- **REVIEWER_MODEL = `gemini-review`** — Gemini reviewer invoked through the local `gemini-review` MCP bridge for brainstorming and critique. Set `GEMINI_REVIEW_MODEL` if you need a specific Gemini model override.
- **OUTPUT_DIR = `idea-stage/`** — Directory for idea output files.
- **Feasibility check**: Can we actually run this experiment with available resources?
- **Novelty quick-check**: For each idea, do 2-3 targeted searches to see if it's already been done. Full `/novelty-check` comes later for survivors.
- **Impact estimation**: Would a reviewer care about the result?
- **Novelty check**: Use the `/novelty-check` workflow (multi-source search + Gemini cross-verification) for each idea
- **Critical review**: Use `mcp__gemini-review__review_reply_start` with the saved completed `threadId`:
- What's the strongest objection a reviewer would raise?
- **Estimate GPU-hours BEFORE launching.** If estimated time > PILOT_MAX_HOURS, reduce scale (fewer epochs, smaller subset) or flag as "needs manual pilot"
- **Collect results**: Use `/monitor-experiment` to check progress. If any pilot exceeds PILOT_TIMEOUT_HOURS, kill it and collect partial results. Once all pilots complete (or timeout), compare:
- **Re-rank based on empirical evidence**: Update the idea ranking using pilot results. An idea with strong pilot signal jumps ahead of a theoretically appealing but untested idea.
- **Reviewer's likely objection**: [strongest counterargument]
- **Why we should do this**: [1-2 sentences]
- [ ] If confirmed, invoke /auto-review-loop for full iteration
- **Large file handling**: If the Write tool fails due to file size, immediately retry using Bash (`cat << 'EOF' > file`) to write in chunks. Do NOT ask the user for permission — just do it silently.
- Don't fall in love with any idea before validating it. Be willing to kill ideas.
Workflow excerpt to incorporate:
```text
## Workflow
### Phase 1: Landscape Survey (5-10 min)
Map the research area to understand what exists and where the gaps are.
2. **Search recent literature** using WebSearch:
   - Top venues in the last 2 years (NeurIPS, ICML, ICLR, ACL, EMNLP, etc.)
   - Recent arXiv preprints (last 6 months)
   - Use 5+ different query formulations
   - Read abstracts and introductions of the top 10-15 papers
2. **Build a landscape map**:
   - Group papers by sub-direction / approach
   - Identify what has been tried and what hasn't
   - Note recurring limitations mentioned in "Future Work" sections
   - Flag any open problems explicitly stated by multiple papers
3. **Identify structural gaps**:
   - Methods that work in domain A but haven't been tried in domain B
   - Contradictory findings between papers (opportunity for resolution)
   - Assumptions that everyone makes but nobody has tested
   - Scaling regimes that haven't been explored
   - Diagnostic questions that nobody has asked
```
