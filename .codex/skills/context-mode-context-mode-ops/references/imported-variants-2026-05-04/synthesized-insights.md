# Synthesized Imported Variant Insights

This file is synthesized from full reads of disabled overlapping skills. Treat these notes as active guidance for the keeper skill, not as an archive. Read the source folders only when this synthesis is insufficient.

Keeper: context-mode-context-mode-ops

## How To Apply

- Prefer the keeper skill workflow as the default path.
- Add the trigger phrases, verification checks, output contracts, and resource pointers below when they fit the task.
- If a disabled variant contains scripts, templates, references, examples, or assets, treat them as reusable resources from this keeper skill.
- Do not resurrect a disabled variant as a separate active skill unless the keeper cannot express its behavior cleanly.

## Source: context-mode-ctx-doctor

Trigger/description delta: |
Unique headings to preserve:
- Context Mode Doctor
- Instructions
Actionable imported checks:
- Call the `ctx_doctor` MCP tool directly. It runs all checks server-side and returns a plain-text status report.
- **Fallback** (only if MCP tool call fails): Derive the **plugin root** from this skill's base directory (go up 2 levels — remove `/skills/ctx-doctor`), then run with Bash:

## Source: context-mode-ctx-insight

Trigger/description delta: |
Unique headings to preserve:
- Context Mode Insight
- Instructions
Actionable imported checks:
- Display the tool's output to the user — it contains progress steps and the dashboard URL.

## Source: context-mode-ctx-purge

Trigger/description delta: |
Unique headings to preserve:
- Context Mode Purge
- Instructions
- When to Use
- Important
Actionable imported checks:
- Session events DB (analytics, metadata, resume snapshots)
- Call the `mcp__context-mode__ctx_purge` MCP tool with `confirm: true`.
- `/clear` and `/compact` do NOT affect any context-mode data.

## Source: context-mode-ctx-stats

Trigger/description delta: |
Unique headings to preserve:
- Context Mode Stats
- Instructions
- Purge
Actionable imported checks:
- Call the `mcp__context-mode__ctx_stats` MCP tool (no parameters needed).
- After the full output, add ONE sentence highlighting the key savings metric, e.g.:

## Source: context-mode-ctx-upgrade

Trigger/description delta: |
Unique headings to preserve:
- Context Mode Upgrade
- Instructions
Actionable imported checks:
- Call the `ctx_upgrade` MCP tool directly. It returns a shell command to execute.
- Display results as a markdown checklist:
- [x] Doctor: all checks PASS
- **Fallback** (only if MCP tool call fails): Derive the **plugin root** from this skill's base directory (go up 2 levels — remove `/skills/ctx-upgrade`), then run with Bash:
