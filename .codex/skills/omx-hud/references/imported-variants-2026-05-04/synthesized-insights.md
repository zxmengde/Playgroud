# Synthesized Imported Variant Insights

This file is synthesized from full reads of disabled overlapping skills. Treat these notes as active guidance for the keeper skill, not as an archive. Read the source folders only when this synthesis is insufficient.

Keeper: omx-hud

## How To Apply

- Prefer the keeper skill workflow as the default path.
- Add the trigger phrases, verification checks, output contracts, and resource pointers below when they fit the task.
- If a disabled variant contains scripts, templates, references, examples, or assets, treat them as reusable resources from this keeper skill.
- Do not resurrect a disabled variant as a separate active skill unless the keeper cannot express its behavior cleanly.

## Source: omx-plugin-hud

Trigger/description delta: Show or configure the OMX HUD (two-layer statusline)
Actionable imported checks:
- **Layer 1 - Codex built-in statusLine**: Real-time TUI footer showing model, git branch, and context usage. Configured via `[tui] status_line` in `~/.codex/config.toml`. Zero code required.
- Default preset is `focused`; if HUD/statusline changes do not appear, restart Codex CLI once.
- Start a workflow (ralph, autopilot, etc.) and check again
