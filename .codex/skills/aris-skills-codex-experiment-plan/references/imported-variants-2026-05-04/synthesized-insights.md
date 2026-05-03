# Synthesized Imported Variant Insights

This file is synthesized from full reads of disabled overlapping skills. Treat these notes as active guidance for the keeper skill, not as an archive. Read the source folders only when this synthesis is insufficient.

Keeper: aris-skills-codex-experiment-plan

## How To Apply

- Prefer the keeper skill workflow as the default path.
- Add the trigger phrases, verification checks, output contracts, and resource pointers below when they fit the task.
- If a disabled variant contains scripts, templates, references, examples, or assets, treat them as reusable resources from this keeper skill.
- Do not resurrect a disabled variant as a separate active skill unless the keeper cannot express its behavior cleanly.

## Source: aris-experiment-plan

Trigger/description delta: Turn a refined research proposal or method idea into a detailed, claim-driven experiment roadmap. Use after `research-refine`, or when the user asks for a detailed experiment plan, ablation matrix, evaluation protocol, run order, compute budget, or paper-ready validation that supports the core problem, novelty, simplicity, and any LLM / VLM / Diffusion / RL-based contribution.
Actionable imported checks:
- **OUTPUT_DIR = `refine-logs/`** — Default destination for experiment planning artifacts.
- **MAX_CORE_BLOCKS = 5** — Keep the must-run experimental story compact.
- `refine-logs/REVIEW_SUMMARY.md`
- **Critical reviewer concerns**
- **Minimum convincing evidence**: what would make each claim believable to a strong reviewer?
- **Simplicity / elegance check** — can a bigger or more fragmented version be avoided?
- **Frontier necessity check** — if an LLM / VLM / Diffusion / RL-era component is central, is it actually the right tool?
- **Success criterion**: what outcome would count as convincing evidence?
- **Table / figure target**: where this result should appear in the paper
- A **simplicity check** should usually compare the final method against either an overbuilt variant or a tempting extra component that the paper intentionally rejects.
- A **frontier necessity check** should usually compare the chosen modern primitive against the strongest plausible simpler or older alternative.
- Main paper must prove:
- Priority: MUST-RUN / NICE-TO-HAVE
- [ ] Nice-to-have runs are separated from must-run runs
- **Large file handling**: If the Write tool fails due to file size, immediately retry using Bash (`cat << 'EOF' > file`) to write in chunks. Do NOT ask the user for permission — just do it silently.
- **Every experiment must defend a claim.** If it does not change a reviewer belief, cut it.
- **Separate must-run from nice-to-have.** Do not let appendix ideas delay the core paper evidence.
- **Reuse proposal constraints.** Do not invent unrealistic budgets or data assumptions.
Workflow excerpt to incorporate:
```text
## Workflow
### Phase 0: Load the Proposal Context
Read the most relevant existing files first if they exist:
- `refine-logs/FINAL_PROPOSAL.md`
- `refine-logs/REVIEW_SUMMARY.md`
- `refine-logs/REFINEMENT_REPORT.md`
Extract:
- **Problem Anchor**
- **Dominant contribution**
- **Optional supporting contribution**
- **Critical reviewer concerns**
- **Data / compute / timeline constraints**
- **Which frontier primitive is central, if any**
If these files do not exist, derive the same information from the user's prompt.
```
