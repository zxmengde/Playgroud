# Synthesized Imported Variant Insights

This file is synthesized from full reads of disabled overlapping skills. Treat these notes as active guidance for the keeper skill, not as an archive. Read the source folders only when this synthesis is insufficient.

Keeper: aris-skills-codex-research-refine

## How To Apply

- Prefer the keeper skill workflow as the default path.
- Add the trigger phrases, verification checks, output contracts, and resource pointers below when they fit the task.
- If a disabled variant contains scripts, templates, references, examples, or assets, treat them as reusable resources from this keeper skill.
- Do not resurrect a disabled variant as a separate active skill unless the keeper cannot express its behavior cleanly.

## Source: aris-research-refine

Trigger/description delta: Turn a vague research direction into a problem-anchored, elegant, frontier-aware, implementation-oriented method plan via iterative GPT-5.4 review. Use when the user says "refine my approach", "帮我细化方案", "decompose this problem", "打磨idea", "refine research plan", "细化研究方案", or wants a concrete research method that stays simple, focused, and top-venue ready instead of a vague or overbuilt idea.
Actionable imported checks:
- **Do not lose the original problem.** Freeze an immutable **Problem Anchor** and reuse it in every round.
- **Modern leverage is a prior, not a decoration.** When LLM / VLM / Diffusion / RL / distillation / inference-time scaling naturally fit the bottleneck, use them concretely. Do not bolt them on as buzzwords.
- **REVIEWER_MODEL = `gpt-5.4`** — Reviewer model used via Codex MCP.
- **MAX_ROUNDS = 5** — Maximum review-revise rounds.
- **OUTPUT_DIR = `refine-logs/`** — Directory for round files and final report.
- **Write after each phase completes** (not before). Overwrite each time — only the latest state matters.
- **Check for `refine-logs/REFINE_STATE.json`**:
- If it exists AND `status` is `"in_progress"` AND `timestamp` is **within 24 hours** → **resume**
- **On resume**, read the state file and recover context:
- Recover `threadId` for reviewer thread continuity
- Log to the user: `"Checkpoint found. Resuming after phase: {phase}, round: {round}."`
- **Bottom-line problem**: What technical problem must be solved?
- **Must-solve bottleneck**: What specific weakness in current methods is unacceptable?
- **Success condition**: What evidence would make the user say "yes, this method addresses the actual problem"?
- **Required evidence**: what minimum proof is needed to defend that claim?
- Which route avoids contribution sprawl?
- **System graph**: modules, data flow, inputs, outputs.
- **Representation design**: what latent, embedding, plan token, reward signal, memory state, or alignment space is used?
Workflow excerpt to incorporate:
```text
## Workflow
### Initialization (Checkpoint Recovery)
Before starting any phase, check whether a previous run left a checkpoint:
1. **Check for `refine-logs/REFINE_STATE.json`**:
   - If it **does not exist** → **fresh start** (proceed to Phase 0 normally)
   - If it exists AND `status` is `"completed"` → **fresh start** (delete state file, previous run finished)
   - If it exists AND `status` is `"in_progress"` AND `timestamp` is **older than 24 hours** → **fresh start** (stale state from a killed/abandoned run — delete the file)
   - If it exists AND `status` is `"in_progress"` AND `timestamp` is **within 24 hours** → **resume**
2. **On resume**, read the state file and recover context:
   - Read all existing `refine-logs/round-*.md` files to restore prior work
   - Read `refine-logs/score-history.md` if it exists
   - Recover `threadId` for reviewer thread continuity
   - Log to the user: `"Checkpoint found. Resuming after phase: {phase}, round: {round}."`
   - **Jump to the next phase** based on the saved `phase` value:
   | Saved `phase` | What was completed | Resume from |
   |---------------|-------------------|-------------|
   | `"anchor"` | Phase 0 done | Phase 1 (read anchor from round-0 context) |
   | `"proposal"` | Phase 1 done | Phase 2 (read `round-0-initial-proposal.md`) |
   | `"review"` | Phase 2 or 4 done | Phase 3 (read latest `round-N-review.md`) |
   | `"refine"` | Phase 3 done | Phase 4 (read latest `round-N-refinement.md`) |
3. **On fresh start**, ensure `refine-logs/` directory exists and proceed to Phase 0.
```

## Source: aris-skills-codex-claude-review-research-refine

Trigger/description delta: Turn a vague research direction into a problem-anchored, elegant, frontier-aware, implementation-oriented method plan via iterative GPT-5.4 review. Use when the user says \"refine my approach\", \"帮我细化方案\", \"decompose this problem\", \"打磨idea\", \"refine research plan\", \"细化研究方案\", or wants a concrete research method that stays simple, focused, and top-venue ready instead of a vague or overbuilt idea.
Actionable imported checks:
- **Do not lose the original problem.** Freeze an immutable **Problem Anchor** and reuse it in every round.
- **Modern leverage is a prior, not a decoration.** When LLM / VLM / Diffusion / RL / distillation / inference-time scaling naturally fit the bottleneck, use them concretely. Do not bolt them on as buzzwords.
- **REVIEWER_MODEL = `claude-review`** — Claude reviewer invoked through the local `claude-review` MCP bridge. Set `CLAUDE_REVIEW_MODEL` if you need a specific Claude model override.
- **MAX_ROUNDS = 5** — Maximum review-revise rounds.
- **OUTPUT_DIR = `refine-logs/`** — Directory for round files and final report.
- **Bottom-line problem**: What technical problem must be solved?
- **Must-solve bottleneck**: What specific weakness in current methods is unacceptable?
- **Success condition**: What evidence would make the user say "yes, this method addresses the actual problem"?
- **Required evidence**: what minimum proof is needed to defend that claim?
- Which route avoids contribution sprawl?
- **System graph**: modules, data flow, inputs, outputs.
- **Representation design**: what latent, embedding, plan token, reward signal, memory state, or alignment space is used?
- **Failure handling**: what could go wrong and what fallback or diagnostic exists?
- If complexity risk exists, include one **simplification or deletion check**.
- If a frontier primitive is central, include one **necessity check** showing why that choice matters.
- Must-solve bottleneck:
- Input / output:
- Input / output:
Workflow excerpt to incorporate:
```text
## Workflow
### Phase 0: Freeze the Problem Anchor
Before proposing anything, extract the user's immutable bottom-line problem. This anchor must be copied verbatim into every proposal and every refinement round.
Write:
- **Bottom-line problem**: What technical problem must be solved?
- **Must-solve bottleneck**: What specific weakness in current methods is unacceptable?
- **Non-goals**: What is explicitly *not* the goal of this project?
- **Constraints**: Compute, data, time, tooling, venue, deployment limits.
- **Success condition**: What evidence would make the user say "yes, this method addresses the actual problem"?
If later reviewer feedback would change the problem being solved, mark that as **drift** and push back or adapt carefully.
```

## Source: aris-skills-codex-gemini-review-research-refine

Trigger/description delta: Turn a vague research direction into a problem-anchored, elegant, frontier-aware, implementation-oriented method plan via iterative Gemini review. Use when the user says \"refine my approach\", \"帮我细化方案\", \"decompose this problem\", \"打磨idea\", \"refine research plan\", \"细化研究方案\", or wants a concrete research method that stays simple, focused, and top-venue ready instead of a vague or overbuilt idea.
Actionable imported checks:
- **Do not lose the original problem.** Freeze an immutable **Problem Anchor** and reuse it in every round.
- **Modern leverage is a prior, not a decoration.** When LLM / VLM / Diffusion / RL / distillation / inference-time scaling naturally fit the bottleneck, use them concretely. Do not bolt them on as buzzwords.
- **REVIEWER_MODEL = `gemini-review`** — Gemini reviewer invoked through the local `gemini-review` MCP bridge. Set `GEMINI_REVIEW_MODEL` if you need a specific Gemini model override.
- **MAX_ROUNDS = 5** — Maximum review-revise rounds.
- **OUTPUT_DIR = `refine-logs/`** — Directory for round files and final report.
- **Bottom-line problem**: What technical problem must be solved?
- **Must-solve bottleneck**: What specific weakness in current methods is unacceptable?
- **Success condition**: What evidence would make the user say "yes, this method addresses the actual problem"?
- **Required evidence**: what minimum proof is needed to defend that claim?
- Which route avoids contribution sprawl?
- **System graph**: modules, data flow, inputs, outputs.
- **Representation design**: what latent, embedding, plan token, reward signal, memory state, or alignment space is used?
- **Failure handling**: what could go wrong and what fallback or diagnostic exists?
- If complexity risk exists, include one **simplification or deletion check**.
- If a frontier primitive is central, include one **necessity check** showing why that choice matters.
- Must-solve bottleneck:
- Input / output:
- Input / output:
Workflow excerpt to incorporate:
```text
## Workflow
### Phase 0: Freeze the Problem Anchor
Before proposing anything, extract the user's immutable bottom-line problem. This anchor must be copied verbatim into every proposal and every refinement round.
Write:
- **Bottom-line problem**: What technical problem must be solved?
- **Must-solve bottleneck**: What specific weakness in current methods is unacceptable?
- **Non-goals**: What is explicitly *not* the goal of this project?
- **Constraints**: Compute, data, time, tooling, venue, deployment limits.
- **Success condition**: What evidence would make the user say "yes, this method addresses the actual problem"?
If later reviewer feedback would change the problem being solved, mark that as **drift** and push back or adapt carefully.
```
