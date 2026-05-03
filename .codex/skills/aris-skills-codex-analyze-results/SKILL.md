---
name: aris-skills-codex-analyze-results
description: "Analyze ML experiment results, compute statistics, generate comparison tables and insights. Use when user says \"analyze results\", \"compare\", or needs to interpret experimental data."
metadata:
  role: stage_specialist
---

# Analyze Experiment Results

Analyze: $ARGUMENTS

## Workflow

### Step 1: Locate Results
Find all relevant JSON/CSV result files:
- Check `figures/`, `results/`, or project-specific output directories
- Parse JSON results into structured data

### Step 2: Build Comparison Table
Organize results by:
- **Independent variables**: model type, hyperparameters, data config
- **Dependent variables**: primary metric (e.g., perplexity, accuracy, loss), secondary metrics
- **Delta vs baseline**: always compute relative improvement

### Step 3: Statistical Analysis
- If multiple seeds: report mean +/- std, check reproducibility
- If sweeping a parameter: identify trends (monotonic, U-shaped, plateau)
- Flag outliers or suspicious results

### Step 4: Generate Insights
For each finding, structure as:
1. **Observation**: what the data shows (with numbers)
2. **Interpretation**: why this might be happening
3. **Implication**: what this means for the research question
4. **Next step**: what experiment would test the interpretation

### Step 5: Update Documentation
If findings are significant:
- Propose updates to project notes or experiment reports
- Draft a concise finding statement (1-2 sentences)

## Output Format
Always include:
1. Raw data table
2. Key findings (numbered, concise)
3. Suggested next experiments (if any)

## Consolidated ARIS Source Merge

This keeper is the active Codex-facing ARIS skill for this capability. Imported base and reviewer-overlay variants were read and folded into this keeper; source copies remain only for rollback/deep reference.

### Merged Sources
- `aris-analyze-results`: 46 lines, sha `9df5dd7b79bc1a3a`, source-overlap `1.00`. Trigger: Analyze ML experiment results, compute statistics, generate comparison tables and insights. Use when user says "analyze results", "compare", or needs to interpret experimental data.

### Retained Operating Rules
- Record hypothesis, baseline, metric, dataset/config, run command, artifact path, and result interpretation.
- Separate planned experiments, running jobs, completed results, and blocked runs.
- The imported source is already substantially represented in the keeper; retain its trigger wording and artifact/resource compatibility here rather than re-enabling it.

### Merge Discipline
- Do not reactivate the imported ARIS/base/reviewer variant as a separate skill for ordinary use.
- If a source-specific retained point is stronger than the keeper text, apply that point directly in the task output.
- If a reviewer-overlay source names Claude or Gemini backends, treat that as an explicit alternate reviewer route only when the user asks for that backend or the local environment exposes it; default Codex work should not auto-open external reviewers.
- If the task touches external services, notifications, paid compute, or credentials, state the boundary and obtain authorization when required.
