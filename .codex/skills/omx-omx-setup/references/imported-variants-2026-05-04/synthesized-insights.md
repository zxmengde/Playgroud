# Synthesized Imported Variant Insights

This file is synthesized from full reads of disabled overlapping skills. Treat these notes as active guidance for the keeper skill, not as an archive. Read the source folders only when this synthesis is insufficient.

Keeper: omx-omx-setup

## How To Apply

- Prefer the keeper skill workflow as the default path.
- Add the trigger phrases, verification checks, output contracts, and resource pointers below when they fit the task.
- If a disabled variant contains scripts, templates, references, examples, or assets, treat them as reusable resources from this keeper skill.
- Do not resurrect a disabled variant as a separate active skill unless the keeper cannot express its behavior cleanly.

## Source: omx-plugin-omx-setup

Trigger/description delta: Setup and configure oh-my-codex using current CLI behavior
Actionable imported checks:
- `--plugin`: use Codex plugin delivery for bundled skills while archiving/removing legacy OMX-managed prompts/native agents and keeping setup-owned runtime hooks
- `--legacy`: use legacy setup delivery, overriding any persisted plugin install mode
- `--install-mode`: explicitly choose setup delivery mode (`legacy` or `plugin`); canonical form for scripted setup
- if a TTY user has persisted setup preferences, `omx setup` first summarizes the recorded choices and asks whether to **keep**, **review/change**, or **reset** them
- If scope is `user`, resolve user skill delivery mode:
- persisted install mode in `./.omx/setup-scope.json`, if present and the TTY review decision is `keep`
- Verify Team CLI API interop markers exist in built `dist/cli/team.js`
- Non-interactive setup never blocks for this review prompt: it keeps deterministic CLI/persisted/default behavior for CI and scripted installs.
- In `user` scope, `omx setup` also prompts for skill delivery mode when no prior install mode is kept; installed plugin cache discovery makes plugin mode the default prompt/non-interactive choice.
- User-scope skill delivery targets:
- Run `omx doctor` and check the reported setup scope, Codex home, skill root, and hook/config status.
- If duplicate/stale skills appear, check for legacy `~/.agents/skills` overlap and follow the cleanup hint printed by setup/doctor.
- Verify installation:
- OMX MCP servers configured in scope target `config.toml` (`~/.codex/config.toml` or `./.codex/config.toml`)
