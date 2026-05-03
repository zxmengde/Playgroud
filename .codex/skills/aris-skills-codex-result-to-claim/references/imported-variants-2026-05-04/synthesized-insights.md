# Synthesized Imported Variant Insights

This file is synthesized from full reads of disabled overlapping skills. Treat these notes as active guidance for the keeper skill, not as an archive. Read the source folders only when this synthesis is insufficient.

Keeper: aris-skills-codex-result-to-claim

## How To Apply

- Prefer the keeper skill workflow as the default path.
- Add the trigger phrases, verification checks, output contracts, and resource pointers below when they fit the task.
- If a disabled variant contains scripts, templates, references, examples, or assets, treat them as reusable resources from this keeper skill.
- Do not resurrect a disabled variant as a separate active skill unless the keeper cannot express its behavior cleanly.

## Source: aris-result-to-claim

Trigger/description delta: Use when experiments complete to judge what claims the results support, what they don't, and what evidence is still missing. Codex MCP evaluates results against intended claims and routes to next action (pivot, supplement, or confirm). Use after experiments finish — before writing the paper or running ablations.
Actionable imported checks:
- After a set of experiments completes (main results, not just sanity checks)
- Before committing to claims in a paper or review response
- **EXPERIMENT_TRACKER.md**: check which experiments are DONE vs still running
- missing_evidence: specific evidence gaps
- suggested_claim_revision: if the claim should be strengthened, weakened, or reframed
- missing_evidence: "..."
- Design and run supplementary experiments to fill evidence gaps
- Re-run result-to-claim after supplementary experiments complete
- If all evidence is in → ready for paper writing
- **Codex is the judge, not CC.** CC collects evidence and routes; Codex evaluates. This prevents post-hoc rationalization.
- Do not inflate claims beyond what the data supports. If Codex says "partial", do not round up to "yes".
- If Codex MCP is unavailable (call fails), CC makes its own judgment and marks it `[pending Codex review]` — do not block the pipeline.
Workflow excerpt to incorporate:
```text
## Workflow
### Step 1: Collect Results
Gather experiment data from whatever sources are available in the project:
1. **W&B** (preferred): `wandb.Api().run("<entity>/<project>/<run_id>").history()` — metrics, training curves, comparisons
2. **EXPERIMENT_LOG.md**: full results table with baselines and verdicts
3. **EXPERIMENT_TRACKER.md**: check which experiments are DONE vs still running
4. **Log files**: `ssh server "tail -100 /path/to/training.log"` if no other source
5. **docs/research_contract.md**: intended claims and experiment design
Assemble the key information:
- What experiments were run (method, dataset, config)
- Main metrics and baseline comparisons (deltas)
- The intended claim these experiments were designed to test
- Any known confounds or caveats
```
