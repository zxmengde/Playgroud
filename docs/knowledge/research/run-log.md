# Research Run Log

## 2026-05-02 - Unified capability layer smoke

Question: whether the repository can absorb external research and task mechanisms without importing full runtimes.

Inputs: `docs/capabilities/capability-map.yaml`, `docs/knowledge/research/research-state.yaml`, `docs/validation/system-improvement/research-memo-sample.md`.

Planned verification:

- `scripts/codex.ps1 research smoke`
- `scripts/codex.ps1 uiux smoke`
- `scripts/codex.ps1 knowledge obsidian-dry-run`
- `scripts/codex.ps1 context budget`
- `scripts/codex.ps1 task recover`

Decision rule: promote only commands that pass smoke checks or record a concrete blocker.
