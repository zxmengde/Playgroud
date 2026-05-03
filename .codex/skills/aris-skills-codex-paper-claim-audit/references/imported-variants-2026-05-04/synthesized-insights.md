# Synthesized Imported Variant Insights

This file is synthesized from full reads of disabled overlapping skills. Treat these notes as active guidance for the keeper skill, not as an archive. Read the source folders only when this synthesis is insufficient.

Keeper: aris-skills-codex-paper-claim-audit

## How To Apply

- Prefer the keeper skill workflow as the default path.
- Add the trigger phrases, verification checks, output contracts, and resource pointers below when they fit the task.
- If a disabled variant contains scripts, templates, references, examples, or assets, treat them as reusable resources from this keeper skill.
- Do not resurrect a disabled variant as a separate active skill unless the keeper cannot express its behavior cleanly.

## Source: aris-paper-claim-audit

Trigger/description delta: Zero-context verification that every number, comparison, and scope claim in the paper matches raw result files. Uses a fresh cross-model reviewer with NO prior context to prevent confirmation bias. Use when user says \"审查论文数据\", \"check paper claims\", \"verify numbers\", \"论文数字核对\", or before submission to ensure paper-to-evidence fidelity.
Actionable imported checks:
- Raw result files (the evidence)
- ❌ AUTO_REVIEW.md
- evidence_file: which raw file
- evidence_value: the actual number
- missing_evidence: [count]
- **Evidence shows**: ...
- **After `/paper-write`** — first check before improvement loop
- **After `/auto-paper-improvement-loop`** — recheck if improvement loop changed numbers
- **Before submission** — final verification
- `WARN` → print warning, continue, flag draft as "check numbers before submission"
- `FAIL` → print alert, continue, but do NOT mark as submission-ready
- **Only raw results.** No EXPERIMENT_LOG, no AUTO_REVIEW, no human summaries.
- **Cross-model.** Reviewer must be a different model family from executor.
Workflow excerpt to incorporate:
```text
## Workflow
### Step 1: Collect Files (Executor — Claude)
Locate paper and result files WITHOUT reading or interpreting them.
**Paper files** (claims) — paths shown relative to the shell's working
directory so you can find them with `ls`; when writing them into
`audited_input_hashes`, use paths relative to the paper dir (no `paper/`
prefix) per the "Submission Artifact Emission" section below:
```
paper/main.tex                # → hash key: main.tex
paper/sections/*.tex          # → hash key: sections/*.tex
paper/tables/*.tex (if separate)   # → hash key: tables/*.tex
```
**Result files** (evidence):
```
results/*.json, results/*.jsonl, results/*.csv, results/*.tsv
outputs/*.json, outputs/*.csv
wandb-summary.json (if exists)
**/metrics.json, **/eval_results.json
**/config.yaml, **/args.json (experiment configs)
```
**Exclude** (no summaries, no interpretations):
```
EXPERIMENT_LOG.md, EXPERIMENT_TRACKER.md, AUTO_REVIEW*.md
NARRATIVE_REPORT.md, PAPER_PLAN.md, findings.md
Any .md file that is an executor-written summary
```
```
