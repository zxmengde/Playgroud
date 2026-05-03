# Synthesized Imported Variant Insights

This file is synthesized from full reads of disabled overlapping skills. Treat these notes as active guidance for the keeper skill, not as an archive. Read the source folders only when this synthesis is insufficient.

Keeper: aris-skills-codex-vast-gpu

## How To Apply

- Prefer the keeper skill workflow as the default path.
- Add the trigger phrases, verification checks, output contracts, and resource pointers below when they fit the task.
- If a disabled variant contains scripts, templates, references, examples, or assets, treat them as reusable resources from this keeper skill.
- Do not resurrect a disabled variant as a separate active skill unless the keeper cannot express its behavior cleanly.

## Source: aris-vast-gpu

Trigger/description delta: Rent, manage, and destroy GPU instances on vast.ai. Use when user says \"rent gpu\", \"vast.ai\", \"rent a server\", \"cloud gpu\", or needs on-demand GPU without owning hardware.
Unique headings to preserve:
- CLAUDE.md Example
Actionable imported checks:
- Multi-GPU — check for `DataParallel`, `DistributedDataParallel`, `accelerate`, `deepspeed`
- The user's SSH key was not uploaded to https://cloud.vast.ai/manage-keys/ **before** the instance was created
- **Download results before destroying** — data is lost permanently on destroy
- **Prefer on-demand pricing** for short experiments (<2 hours). Suggest interruptible/bid pricing for long runs (>4 hours) with checkpointing
- **Check reliability > 0.95** — unreliable hosts may crash mid-training
- **SSH keys must be uploaded BEFORE creating instances** — keys are baked in at creation time. If SSH fails with "Permission denied", destroy and recreate after adding the key
- **State file `vast-instances.json` must stay up to date** — other skills depend on it
- auto_destroy: true         # auto-destroy after experiment completes (default: true)
Workflow excerpt to incorporate:
```text
## Workflow
### Action: Provision (default)
Analyze the task, find the best GPU, and present cost-optimized options. This is the main entry point — called directly or automatically by `/run-experiment` when `gpu: vast` is set.
**Step 1: Analyze Task Requirements**
Read available context to determine what the task needs:
1. **From the experiment plan** (`refine-logs/EXPERIMENT_PLAN.md`):
   - Compute budget (total GPU-hours)
   - Hardware hints (e.g., "4x RTX 3090")
   - Model architecture and dataset size
   - Run order and per-milestone cost estimates
2. **From experiment scripts** (if already written):
   - Model size — scan for model class, `num_parameters`, config files
   - Batch size, sequence length — estimate VRAM from these
   - Dataset — estimate training time from dataset size + epochs
   - Multi-GPU — check for `DataParallel`, `DistributedDataParallel`, `accelerate`, `deepspeed`
3. **From user description** (if no plan/scripts exist):
   - Model name/size (e.g., "fine-tune LLaMA-7B", "train ResNet-50")
   - Dataset scale (e.g., "ImageNet", "10k samples")
   - Estimated duration (e.g., "about 2 hours")
**Step 2: Determine GPU Requirements**
Based on the task analysis, determine:
| Factor | How to estimate |
|--------|----------------|
| **Min VRAM** | Model params × 4 bytes (fp32) or × 2 (fp16/bf16) + optimizer states + activations. Rules of thumb: 7B model ≈ 16 GB (fp16), 13B ≈ 28 GB, 70B ≈ 140 GB (needs multi-GPU). ResNet/ViT ≈ 4-8 GB. Add 20% headroom. |
| **Num GPUs** | 1 unless: model doesn't fit in single GPU VRAM, or scripts use DDP/FSDP/DeepSpeed, or plan specifies multi-GPU |
```
