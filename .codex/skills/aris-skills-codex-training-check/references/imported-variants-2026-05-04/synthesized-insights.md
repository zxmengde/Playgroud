# Synthesized Imported Variant Insights

This file is synthesized from full reads of disabled overlapping skills. Treat these notes as active guidance for the keeper skill, not as an archive. Read the source folders only when this synthesis is insufficient.

Keeper: aris-skills-codex-training-check

## How To Apply

- Prefer the keeper skill workflow as the default path.
- Add the trigger phrases, verification checks, output contracts, and resource pointers below when they fit the task.
- If a disabled variant contains scripts, templates, references, examples, or assets, treat them as reusable resources from this keeper skill.
- Do not resurrect a disabled variant as a separate active skill unless the keeper cannot express its behavior cleanly.

## Source: aris-training-check

Trigger/description delta: Periodically check WandB metrics during training to catch problems early (NaN, loss divergence, idle GPUs). Avoids wasting GPU hours on broken runs. Use when training is running and you want automated health checks.
Unique headings to preserve:
- Context: $ARGUMENTS
- Constants
- When to Use
- Workflow
- Step 1: Read WandB Metrics
- Step 2: Judgment
- Step 3: Codex Judgment (only when unsure)
- Step 4: Act
- Integration with Watchdog
- Rules
- CronCreate Setup Example
Actionable imported checks:
- CHECK_INTERVAL: starts at 10 minutes, then gradually increases if consistently healthy: 10 min → 20 min → 30 min → 60 min (cap)
- REVIEWER_MODEL = `gpt-5.4` — used via Codex MCP for ambiguous cases only
- After training is confirmed running (session alive, loss decreasing for first few steps)
- **This skill checks training QUALITY, not process HEALTH.** Process health (session alive, GPU utilization) is [watchdog.py](../../tools/watchdog.py)'s job.
- STOP: clearly problematic, should kill training
- CONTINUE: looks fine, check again next interval
- WAIT: not enough data to judge, check again sooner
- Training-check catches subtle quality issues (loss plateau, metric degradation)
- Do not stop training on first sign of noise — some loss spikes are normal. Look at **trends over multiple checkpoints**.
- When stopping training, always save the WandB run URL and key metrics as evidence.
- If both WandB and log files are unreachable, report the connectivity issue and try again next interval. Do not assume training is broken.
- Gradually increase check interval when healthy (10 → 20 → 30 → 60 min). Reset to 10 min after any anomaly.
- This skill is meant to be automated via CronCreate — do not ask the user whether to set it up. Just set it.
Workflow excerpt to incorporate:
```text
## Workflow
### Step 1: Read WandB Metrics
```python
import wandb
api = wandb.Api()
run = api.run("<entity>/<project>/<run_id>")
history = run.history()
```
If WandB is unreachable (API error, network issue), fall back to reading the log file directly via SSH:
```bash
ssh server "tail -100 /path/to/training.log"
```
Check these signals:
- **Loss trend**: Is training loss decreasing over the last N steps?
- **Eval metrics**: Are evaluation metrics improving (or at least not degrading)?
- **NaN / Inf**: Any NaN or Inf values in loss or gradients?
- **Spikes**: Sudden large jumps in loss (>10x normal variance)?
- **Learning rate**: Is the schedule behaving as expected?
- **Gradient norm**: Exploding or vanishing?
```
