# Synthesized Imported Variant Insights

This file is synthesized from full reads of disabled overlapping skills. Treat these notes as active guidance for the keeper skill, not as an archive. Read the source folders only when this synthesis is insufficient.

Keeper: aris-skills-codex-run-experiment

## How To Apply

- Prefer the keeper skill workflow as the default path.
- Add the trigger phrases, verification checks, output contracts, and resource pointers below when they fit the task.
- If a disabled variant contains scripts, templates, references, examples, or assets, treat them as reusable resources from this keeper skill.
- Do not resurrect a disabled variant as a separate active skill unless the keeper cannot express its behavior cleanly.

## Source: aris-run-experiment

Trigger/description delta: Deploy and run ML experiments on local, remote, Vast.ai, or Modal serverless GPU. Use when user says "run experiment", "deploy to server", "跑实验", or needs to launch training jobs.
Unique headings to preserve:
- Option B: git (when `code_sync: git` is set in CLAUDE.md)
- Step 3.5: W&B Integration (when `wandb: true` in CLAUDE.md)
- CLAUDE.md Example
Actionable imported checks:
- **Vast.ai** (`gpu: vast`): Check for `vast-instances.json` at project root — if a running instance exists, use it. Also check `CLAUDE.md` for a `## Vast.ai` section.
- **Check if wandb is already in the script** — look for `import wandb` or `wandb.init`. If present, skip to Step 4.
- **Verify wandb login on the target machine:**
- ALWAYS check GPU availability first — never blindly assign GPUs (except Modal, which manages allocation automatically)
- **Modal cost awareness**: Always estimate and display cost before running. Modal auto-scales to zero — no idle billing, no manual cleanup
- wandb_project: my-project # W&B project name (required if wandb: true)
- auto_destroy: true         # auto-destroy after experiment completes (default: true)
Workflow excerpt to incorporate:
```text
## Workflow
### Step 1: Detect Environment
Read the project's `CLAUDE.md` to determine the experiment environment:
- **Local GPU** (`gpu: local`): Look for local CUDA/MPS setup info
- **Remote server** (`gpu: remote`): Look for SSH alias, conda env, code directory
- **Vast.ai** (`gpu: vast`): Check for `vast-instances.json` at project root — if a running instance exists, use it. Also check `CLAUDE.md` for a `## Vast.ai` section.
- **Modal** (`gpu: modal`): Serverless GPU via Modal. No SSH, no Docker, auto scale-to-zero. Delegate to `/serverless-modal`.
**Vast.ai detection priority:**
1. If `CLAUDE.md` has `gpu: vast` or a `## Vast.ai` section:
   - If `vast-instances.json` exists and has a running instance → use that instance
   - If no running instance → call `/vast-gpu provision` which analyzes the task, presents cost-optimized GPU options, and rents the user's choice
2. If no server info is found in `CLAUDE.md`, ask the user.
```
