# Synthesized Imported Variant Insights

This file is synthesized from full reads of disabled overlapping skills. Treat these notes as active guidance for the keeper skill, not as an archive. Read the source folders only when this synthesis is insufficient.

Keeper: aris-skills-codex-experiment-queue

## How To Apply

- Prefer the keeper skill workflow as the default path.
- Add the trigger phrases, verification checks, output contracts, and resource pointers below when they fit the task.
- If a disabled variant contains scripts, templates, references, examples, or assets, treat them as reusable resources from this keeper skill.
- Do not resurrect a disabled variant as a separate active skill unless the keeper cannot express its behavior cleanly.

## Source: aris-experiment-queue

Trigger/description delta: SSH job queue for multi-seed/multi-config ML experiments with OOM-aware retry, stale-screen cleanup, and wave-transition race prevention. Use when user says "batch experiments", "队列实验", "run grid", "multi-seed sweep", "auto-chain experiments", or when /run-experiment is insufficient for 10+ jobs that need orchestration.
Unique headings to preserve:
- Then re-run Step 3d verbatim. Do NOT re-run Step 3c (would overwrite manifest.json + state.json).
Actionable imported checks:
- **Teacher+student chains** (train teacher then distill; auto-trigger student after teacher done)
- **Wave race** — new wave launches before previous wave fully settles
- **Missing checkpoints** — student launches before teacher saved
- type: checkpoint_exists
- Precondition checks pass for next-wave jobs
- Check SSH connection works
- Check conda env exists on remote
- Check `cwd` exists on remote
- Check all preconditions (checkpoints, input files)
- Check GPU availability (at least `max_parallel` free GPUs)
- Persist `RUN_TS` / `REMOTE_RUN_REL` / `REMOTE_RUN_DIR` to disk so monitoring and resume can reload them without regenerating:
- Detects OOM (CUDA OOM in log → mark failed_oom → retry after delay)
- Detects completion (expected output JSON/file exists) → mark completed
- Check if current GPU is free; if not, try another free GPU
- Max `oom_retry.max_attempts` before marking `stuck`
- Check screen exists (`screen -ls`)
- Check python PID still running (`ps -p`)
- If expected output file exists → mark `completed`, kill stale screen
Workflow excerpt to incorporate:
```text
## Workflow
### Step 1: Parse Manifest / Build from Grid
Input can be:
- **YAML manifest** (explicit job list, recommended for complex cases)
- **Grid spec** (Cartesian product of param values, e.g., `N=[64,128,256] × n=[50K,150K,500K,652K]`)
- **Natural language description** (Claude parses into manifest)
Bind the run identifiers once so every later step (manifest save, scp, launch, monitor, resume) refers to the same paths. Set these as local shell variables before generating the manifest:
```bash
```
