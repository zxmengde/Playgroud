# Synthesized Imported Variant Insights

This file is synthesized from full reads of disabled overlapping skills. Treat these notes as active guidance for the keeper skill, not as an archive. Read the source folders only when this synthesis is insufficient.

Keeper: aris-skills-codex-monitor-experiment

## How To Apply

- Prefer the keeper skill workflow as the default path.
- Add the trigger phrases, verification checks, output contracts, and resource pointers below when they fit the task.
- If a disabled variant contains scripts, templates, references, examples, or assets, treat them as reusable resources from this keeper skill.
- Do not resurrect a disabled variant as a separate active skill unless the keeper cannot express its behavior cleanly.

## Source: aris-monitor-experiment

Trigger/description delta: Monitor running experiments, check progress, collect results. Use when user says "check results", "is it done", "monitor", or wants experiment output.
Unique headings to preserve:
- Step 3.5: Pull W&B Metrics (when `wandb: true` in CLAUDE.md)
- List recent runs in the project
- Pull specific metrics from a run (last 50 steps)
- Pull run summary (final metrics)
Actionable imported checks:
- **Eval metrics** — loss, PPL, accuracy at latest checkpoint
- Always show raw numbers before interpretation
- Note if experiments are still running (check progress bars, iteration counts)
- If results look wrong, check training logs for errors before concluding
Workflow excerpt to incorporate:
```text
## Workflow
### Step 1: Check What's Running
**SSH server:**
```bash
ssh <server> "screen -ls"
```
**Vast.ai instance** (read `ssh_host`, `ssh_port` from `vast-instances.json`):
```bash
ssh -p <PORT> root@<HOST> "screen -ls"
```
Also check vast.ai instance status:
```bash
vastai show instances
```
**Modal** (when `gpu: modal` in CLAUDE.md):
```bash
modal app list         # List running/recent apps
modal app logs <app>   # Stream logs from a running app
```
Modal apps auto-terminate when done — if it's not in the list, it already finished. Check results via `modal volume ls <volume>` or local output.
```
