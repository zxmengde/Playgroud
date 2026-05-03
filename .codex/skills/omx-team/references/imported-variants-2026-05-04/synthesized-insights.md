# Synthesized Imported Variant Insights

This file is synthesized from full reads of disabled overlapping skills. Treat these notes as active guidance for the keeper skill, not as an archive. Read the source folders only when this synthesis is insufficient.

Keeper: omx-team

## How To Apply

- Prefer the keeper skill workflow as the default path.
- Add the trigger phrases, verification checks, output contracts, and resource pointers below when they fit the task.
- If a disabled variant contains scripts, templates, references, examples, or assets, treat them as reusable resources from this keeper skill.
- Do not resurrect a disabled variant as a separate active skill unless the keeper cannot express its behavior cleanly.

## Source: omx-plugin-team

Trigger/description delta: N coordinated agents on shared task list using tmux-based orchestration
Actionable imported checks:
- Avoid replacing the flow with in-process `spawn_agent` fanout
- Verify startup and surface concrete state/pane evidence
- If active team mode state is missing, initialize/sync it from canonical team runtime state before proceeding
- **Verification ownership:** keep one lane focused on tests, regression coverage, and evidence before shutdown.
- If running repo-local `node bin/omx.js ...`, run `npm run build` after `src` changes
- Check HUD pane count in the leader window and avoid duplicate `hud --watch` panes before split
- known facts/evidence
- If ambiguity remains high, run `explore` first for brownfield facts, then run `$deep-interview --quick <task>` before team launch.
- explain why each lane exists (delivery, verification, specialist support)
- Return control to leader; follow-up uses `status` / `resume` / `shutdown`
- Team runtime must **not** infer `model_reasoning_effort` from model-name substrings (e.g., `spark`, `high-capability`, `mini`).
- Start team and verify startup evidence (team line, tmux target, panes, ACK mailbox)
- Monitor task and worker progress with runtime/state tools first (`omx team status <team>`, `omx team resume <team>`, mailbox/state files)
- Wait for terminal task state before shutdown:
- Verify shutdown evidence and state cleanup
- Verify delivery via mailbox/state evidence (`mailbox/*.json`, task status, `omx team status`).
- **MUST NOT** use direct `tmux send-keys` as the primary mechanism to deliver instructions/messages.
- **MUST NOT** spam Enter/trigger keys without first checking runtime/state evidence.
