# Synthesized Imported Variant Insights

This file is synthesized from full reads of disabled overlapping skills. Treat these notes as active guidance for the keeper skill, not as an archive. Read the source folders only when this synthesis is insufficient.

Keeper: omx-cancel

## How To Apply

- Prefer the keeper skill workflow as the default path.
- Add the trigger phrases, verification checks, output contracts, and resource pointers below when they fit the task.
- If a disabled variant contains scripts, templates, references, examples, or assets, treat them as reusable resources from this keeper skill.
- Do not resurrect a disabled variant as a separate active skill unless the keeper cannot express its behavior cleanly.

## Source: omx-plugin-cancel

Trigger/description delta: Cancel any active OMX mode (autopilot, ralph, ultrawork, ecomode, ultraqa, swarm, ultrapilot, pipeline, team)
Actionable imported checks:
- **Autopilot**: Stops workflow, preserves progress for resume
- **Ecomode**: Stops token-efficient parallel execution (standalone or linked to ralph)
- When a session id is provided or already known, that session-scoped path is authoritative. Legacy files in `.omx/state/*.json` are consulted only as a compatibility fallback if the session id is missing or empty.
- Cancellation MUST remain scope-safe: no mutation of unrelated sessions.
- Team artifacts (`.omx/state/team/*/`, tmux sessions matching `omx-team-*`) are best-effort cleared as part of the legacy fallback.
- `.omx/state/checkpoints/` (directory)
- `.omx/state/sessions/` (empty directory cleanup after clearing sessions)
- Check `.omx/state/team/*/config.json` for active teams
- Parse the `--force` / `--all` flags, tracking whether cleanup should span every session or stay scoped to the current session id.
- **Resume-friendly**: Autopilot state is preserved for seamless resume
- **Team-aware**: Detects tmux-based teams and performs graceful shutdown with force-kill fallback
Workflow excerpt to incorporate:
```text
## Usage
```
/cancel
```
Or say: "cancelomc", "stopomc"
```
