# Synthesized Imported Variant Insights

This file is synthesized from full reads of disabled overlapping skills. Treat these notes as active guidance for the keeper skill, not as an archive. Read the source folders only when this synthesis is insufficient.

Keeper: aris-skills-codex-experiment-bridge

## How To Apply

- Prefer the keeper skill workflow as the default path.
- Add the trigger phrases, verification checks, output contracts, and resource pointers below when they fit the task.
- If a disabled variant contains scripts, templates, references, examples, or assets, treat them as reusable resources from this keeper skill.
- Do not resurrect a disabled variant as a separate active skill unless the keeper cannot express its behavior cleanly.

## Source: aris-experiment-bridge

Trigger/description delta: Workflow 1.5: Bridge between idea discovery and auto review. Reads EXPERIMENT_PLAN.md, implements experiment code, deploys to GPU, collects initial results. Use when user says \"实现实验\", \"implement experiments\", \"bridge\", \"从计划到跑实验\", \"deploy the plan\", or has an experiment plan ready to execute.
Unique headings to preserve:
- Read the repo's README, understand its structure, find entry points
- Implement experiments by modifying/extending this codebase
Actionable imported checks:
- **CODE_REVIEW = true** — GPT-5.4 xhigh reviews experiment code before deployment. Catches logic bugs before wasting GPU hours. Set `false` to skip.
- **AUTO_DEPLOY = true** — Automatically deploy experiments after implementation + review. Set `false` to manually inspect code before deploying.
- **SANITY_FIRST = true** — Run the sanity-stage experiment first (smallest, fastest) before launching the rest. Catches setup bugs early.
- **COMPACT = false** — When `true`, (1) read `idea-stage/IDEA_CANDIDATES.md` instead of full `idea-stage/IDEA_REPORT.md` if available, (2) append experiment results to `EXPERIMENT_LOG.md` after collection.
- **`idea-stage/IDEA_REPORT.md`** — full brainstorm output *(fall back to `./IDEA_REPORT.md` if not found)*
- Priority (MUST-RUN vs NICE-TO-HAVE)
- Must-run experiments: [N]
- **Check existing code** — scan the project (or cloned `base_repo/`) for existing experiment scripts, model code, data loaders. Reuse as much as possible.
- **Self-review before deploying:**
- **CRITICAL: Does evaluation use the dataset's actual ground truth labels — NOT another model's output as ground truth?** This is a common and severe bug.
- **CRITICAL issues found** → fix them, then re-submit for review (max 2 rounds)
- **Codex MCP unavailable** → skip silently, proceed to Phase 3 (graceful degradation)
- Output format matches expectations
- OOM → reduce batch size or enable gradient checkpointing
- CUDA error → check GPU availability, reduce model size
- NaN/divergence → reduce learning rate, check data preprocessing
- **Still failing after 3 attempts?** → stop, report the failure with all attempted fixes and error logs. Do not proceed with broken code.
- **Parse output files** (JSON/CSV/logs) for key metrics
Workflow excerpt to incorporate:
```text
# Workflow 1.5: Experiment Bridge
Implement and deploy experiments from plan: **$ARGUMENTS**
```
