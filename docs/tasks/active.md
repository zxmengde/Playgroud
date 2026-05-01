# Active Task

## Status

验证通过，待提交与提交后严格收尾检查。当前任务是一次仓库级 Codex 自我改进优化，重点是事实基线、外部机制研究、最小机制改造、验证和最终审计报告。

## Last Updated

2026-05-02

## Goal

在 `D:\Code\Playgroud` 中完成一次可验证、可回滚的 Codex 自我改进式优化。目标不是扩展为庞大 agent framework，而是通过删除低价值复杂度、修复运行事实失配、强化 eval 和 task state，使 Codex 更少重复犯错、更会外部调研、UI/UX、产品工程、实验验证、工具路由和中断恢复。

## Read Sources

- `AGENTS.md`
- `docs/core/index.md`
- `docs/profile/user-model.md`
- `docs/profile/preference-map.md`
- `docs/tasks/active.md`
- `docs/knowledge/system-improvement/routing-v1.yaml`
- `docs/knowledge/system-improvement/harness-log.md`
- `docs/workflows/self-improvement.md`
- `docs/workflows/research.md`
- `docs/workflows/product.md`
- `docs/workflows/uiux.md`
- `docs/workflows/knowledge.md`
- `docs/references/assistant/external-capability-radar.md`
- `docs/references/assistant/external-mechanism-transfer.md`
- `docs/references/assistant/mcp-capability-plan.md`
- `C:\Users\mengde\.codex\config.toml`

## Commands

- `git status --short --branch`
- `git pull --ff-only`
- `powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\audit-file-usage.ps1`
- `powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\audit-minimality.ps1`
- `powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\audit-redundancy.ps1`
- `powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\validate-system.ps1`
- `powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\eval-agent-system.ps1`
- `powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\audit-serena-obsidian-readiness.ps1`
- `powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\test-git-network.ps1 -Remote origin`
- `powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\git-safe.ps1 clone --depth 1 --filter=blob:none <repo> <temp>`

## Artifacts

- docs 目录下的最终自我改进报告
- `docs/tasks/active.md`
- `docs/tasks/done.md`
- `docs/workflows/coding.md`
- `docs/workflows/knowledge.md`
- `docs/references/assistant/external-capability-radar.md`
- `docs/references/assistant/external-mechanism-transfer.md`
- `docs/references/assistant/mcp-capability-plan.md`
- `docs/references/assistant/tool-registry.md`
- `docs/knowledge/system-improvement/failures/`
- `docs/knowledge/system-improvement/lessons/`
- `scripts/archive-task-state.ps1`
- `scripts/check-task-state.ps1`
- `scripts/validate-active-load.ps1`
- `scripts/eval-external-mechanism-review-check.ps1`
- `scripts/eval-product-engineering-closeout.ps1`
- `scripts/eval-uiux-review-quality.ps1`
- `docs/validation/system-improvement/*`
- 用户级配置备份：`C:\Users\mengde\.codex\config.toml.bak-20260502-003513`

## Unverified

无。

## Blockers

- 普通 `git pull --ff-only` 在当前 shell 出现 GitHub Schannel TLS 握手失败；`scripts/test-git-network.ps1 -Remote origin` 的 `git ls-remote` 通过，后续 GitHub 操作优先使用 `scripts/git-safe.ps1`。

## Next

1. 提交当前改动。
2. 提交后运行 `check-finish-readiness.ps1 -Strict`。
3. 使用 `scripts/git-safe.ps1 push origin main` 同步远端。

## Recovery

从 `D:\Code\Playgroud` 恢复：

```powershell
git status --short --branch
Get-Content -Raw .\docs\tasks\active.md
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\validate-system.ps1
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\eval-agent-system.ps1
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\check-finish-readiness.ps1 -Strict
```

若需要恢复用户级 Codex 配置，使用 `C:\Users\mengde\.codex\config.toml.bak-20260502-003513` 与当前 `C:\Users\mengde\.codex\config.toml` 对比后恢复。

## Anti-Sycophancy

- Literal-only: 不把“保持轻量”理解成“不改”；删除和合并低价值复杂度是本轮目标的一部分。
- Real-goal: 真实目标是让 Codex 更可验证、更可恢复、更少重复犯错，而不是堆报告。
- User-premise: 外部项目必须按机制筛选，不把项目清单当安装清单。
- Unverified-claims: 不把文档声称写成运行事实；所有接通、优化、删除和回滚都以命令、文件或 diff 为证据。
