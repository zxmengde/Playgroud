# Synthesized Imported Variant Insights

This file is synthesized from full reads of disabled overlapping skills. Treat these notes as active guidance for the keeper skill, not as an archive. Read the source folders only when this synthesis is insufficient.

Keeper: aris-skills-codex-experiment-audit

## How To Apply

- Prefer the keeper skill workflow as the default path.
- Add the trigger phrases, verification checks, output contracts, and resource pointers below when they fit the task.
- If a disabled variant contains scripts, templates, references, examples, or assets, treat them as reusable resources from this keeper skill.
- Do not resurrect a disabled variant as a separate active skill unless the keeper cannot express its behavior cleanly.

## Source: aris-experiment-audit

Trigger/description delta: Audit experiment integrity before claiming results. Uses cross-model review (GPT-5.4) to check for fake ground truth, score normalization fraud, phantom results, and insufficient scope. Use when user says \"审计实验\", \"check experiment integrity\", \"audit results\", \"实验诚实度\", or after experiments complete before writing claims.
Actionable imported checks:
- **Fake ground truth** — creating synthetic "reference" from model outputs, then reporting high agreement as performance
- **REVIEWER_BACKEND = `codex`** — Default: Codex MCP (xhigh). Override with `— reviewer: oracle-pro` for GPT-5.4 Pro via Oracle MCP. See `shared-references/reviewer-routing.md`.
- Result files:          *.json, *.csv in results/, outputs/, logs/
- Is it loaded from the DATASET, or generated/derived from MODEL OUTPUTS?
- Is any metric divided by max/min/mean of the model's OWN output?
- Does its output appear in any result file?
- Evidence: exact file:line references
- **Reviewer independence**: executor collects paths, reviewer judges. Period.
- **Cross-model**: the reviewer MUST be a different model family from the executor.
Workflow excerpt to incorporate:
```text
## Workflow
### Step 1: Collect Artifacts (Executor — Claude)
Locate and list these files WITHOUT reading or summarizing their content:
```
Scan project directory for:
1. Evaluation scripts:    *eval*.py, *metric*.py, *test*.py, *benchmark*.py
2. Result files:          *.json, *.csv in results/, outputs/, logs/
3. Ground truth paths:    look in eval scripts for data loading (dataset paths, GT references)
4. Experiment tracker:    EXPERIMENT_TRACKER.md, EXPERIMENT_LOG.md
5. Paper claims:          NARRATIVE_REPORT.md, paper/sections/*.tex, PAPER_PLAN.md
6. Config files:          *.yaml, *.toml, *.json configs with metric definitions
```
**DO NOT summarize, interpret, or explain any file content.** Only collect paths.
```
