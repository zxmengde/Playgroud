# Synthesized Imported Variant Insights

This file is synthesized from full reads of disabled overlapping skills. Treat these notes as active guidance for the keeper skill, not as an archive. Read the source folders only when this synthesis is insufficient.

Keeper: aris-skills-codex-serverless-modal

## How To Apply

- Prefer the keeper skill workflow as the default path.
- Add the trigger phrases, verification checks, output contracts, and resource pointers below when they fit the task.
- If a disabled variant contains scripts, templates, references, examples, or assets, treat them as reusable resources from this keeper skill.
- Do not resurrect a disabled variant as a separate active skill unless the keeper cannot express its behavior cleanly.

## Source: aris-serverless-modal

Trigger/description delta: Run GPU workloads on Modal — training, fine-tuning, inference, batch processing. Zero-config serverless: no SSH, no Docker, auto scale-to-zero. Use when user says \"modal run\", \"modal training\", \"modal inference\", \"deploy to modal\", \"need a GPU\", \"run on modal\", \"serverless GPU\", or needs remote GPU compute.
Unique headings to preserve:
- CLAUDE.md Example
Actionable imported checks:
- Secrets: `modal secret create huggingface-secret HF_TOKEN=hf_xxxxx`
- GPU fallback: `gpu=["H100", "A100-80GB", "L40S"]` — Modal tries each in order
Workflow excerpt to incorporate:
```text
## Workflow
### Step 1: Analyze Task → Estimate Cost → Choose GPU
Same analysis as any GPU skill — determine VRAM needs from model size, pick GPU, estimate hours, calculate cost. See pricing table above.
**VRAM Rules of Thumb:**
| Model Size | FP16 VRAM | Recommended GPU |
|---|---|---|
| ≤3B | ~8GB | T4, L4 |
| 7-8B | ~22GB | L4, A10, A100-40GB |
| 13B | ~30GB | L40S, A100-40GB |
| 30B | ~65GB | A100-80GB, H100 |
| 70B | ~140GB | H100:2, H200 |
```
Verification/output excerpt to incorporate:
```text
# Verify:
modal run -q 'print("ok")'
```
- Sign up: https://modal.com (GitHub/Google login)
- Free (no card): **$5/month** — enough for quick tests
- Free (with card): **$30/month** — bind a payment method at https://modal.com/settings for the full free tier. Set a **workspace spending limit** to prevent accidental overcharge (Settings → Usage → Spending Limit)
- Academic: apply for $10k credits | Startups: apply for $25k credits
- Secrets: `modal secret create huggingface-secret HF_TOKEN=hf_xxxxx`
> **Recommended setup**: Bind a card to unlock $30/month, then immediately set a spending limit (e.g., $30) so you never exceed the free tier. Modal will pause your workloads when the limit is hit.
>
```
