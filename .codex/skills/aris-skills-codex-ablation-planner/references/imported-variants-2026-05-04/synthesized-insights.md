# Synthesized Imported Variant Insights

This file is synthesized from full reads of disabled overlapping skills. Treat these notes as active guidance for the keeper skill, not as an archive. Read the source folders only when this synthesis is insufficient.

Keeper: aris-skills-codex-ablation-planner

## How To Apply

- Prefer the keeper skill workflow as the default path.
- Add the trigger phrases, verification checks, output contracts, and resource pointers below when they fit the task.
- If a disabled variant contains scripts, templates, references, examples, or assets, treat them as reusable resources from this keeper skill.
- Do not resurrect a disabled variant as a separate active skill unless the keeper cannot express its behavior cleanly.

## Source: aris-ablation-planner

Trigger/description delta: Use when main results pass result-to-claim (claim_supported=yes or partial) and ablation studies are needed for paper submission. Codex designs ablations from a reviewer's perspective, CC reviews feasibility and implements.
Actionable imported checks:
- `/auto-review-loop` reviewer identifies missing ablations
- Confirmed and intended claims (from result-to-claim output or project notes)
- Answer questions reviewers will definitely ask
- priority: 1 (must-run) to 5 (nice-to-have)
- coverage_assessment: what reviewer questions these ablations answer
- Smoke test each ablation before full run
- After all ablations complete → update findings.md with insights
- **Codex leads the design. CC does not pre-filter or bias the ablation list** before Codex sees it. Codex thinks like a reviewer; CC thinks like an engineer.
- Every ablation must have a clear `what_it_tests` and `expected_if_component_matters`. No "just try it" experiments.
- Do not generate ablations for components identical to the baseline (no-op ablations).
Workflow excerpt to incorporate:
```text
## Workflow
### Step 1: Prepare Context
CC reads available project files to build the full picture:
- Method description and components (from docs/research_contract.md or project CLAUDE.md)
- Current experiment results (from EXPERIMENT_LOG.md, EXPERIMENT_TRACKER.md, or W&B)
- Confirmed and intended claims (from result-to-claim output or project notes)
- Available compute resources (from CLAUDE.md server config, if present)
```
