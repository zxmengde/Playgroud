# Active Task

## Goal

在 `D:\Code\Playgroud` 内完成一次证据驱动、可回滚的 Codex 自我改进优化：先建立仓库事实基线，再研究外部项目机制，随后用最小改动修复真正失效的 hooks、自动化、校验和恢复链路，同时压缩冗余入口和过时文档，并留下可恢复的研究报告与任务记录。

## Read Sources

- `AGENTS.md`
- `docs/core/index.md`
- `docs/profile/user-model.md`
- `docs/profile/preference-map.md`
- `docs/tasks/active.md`
- `docs/capabilities/index.md`
- `docs/workflows/coding.md`
- `docs/workflows/research.md`
- `.codex/hooks.json`
- `scripts/validate-system.ps1`
- `scripts/eval-agent-system.ps1`
- `scripts/audit-file-usage.ps1`
- `scripts/check-agent-readiness.ps1`
- `docs/references/assistant/external-capability-radar.md`
- `docs/references/assistant/external-mechanism-transfer.md`
- `.cache/external-repos/*`
- `C:\Users\mengde\.codex\config.toml`
- `C:\Users\mengde\.codex\automations\playgroud-readiness-audit\automation.toml`
- `C:\Users\mengde\.codex\automations\playgroud-improvement-triage\automation.toml`

## Commands

- `git status --short --branch`
- `git pull --ff-only`
- `powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\audit-file-usage.ps1`
- `powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\audit-automation-config.ps1`
- `powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\check-agent-readiness.ps1 -Strict`
- `powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\run-agent-maintenance.ps1 -Full`
- `powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\validate-system.ps1`
- `powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\eval-agent-system.ps1`
- `git rev-parse HEAD`
- 外部仓库源码读取与必要的 `git clone --depth 1`

## Artifacts

- 更新 `.codex/hooks.json`
- 新增 `scripts/codex-hook-session-start.ps1`
- 新增 `scripts/audit-automation-config.ps1`
- 修复 `scripts/codex-hook-risk-check.ps1`、`scripts/codex-hook-stop-check.ps1`
- 修复 `scripts/validate-system.ps1`、`scripts/audit-file-usage.ps1`、`scripts/audit-minimality.ps1`、`scripts/check-agent-readiness.ps1`、`scripts/eval-agent-system.ps1`、`scripts/run-agent-maintenance.ps1`
- 更新 `AGENTS.md`
- 更新 `docs/capabilities/index.md`
- 更新 `docs/references/assistant/external-capability-radar.md`
- 更新 `docs/references/assistant/external-mechanism-transfer.md`
- 更新 `docs/knowledge/system-improvement/skill-audit.md`
- 更新 `docs/workflows/knowledge.md`
- 更新 `docs/knowledge/system-improvement/harness-log.md`
- 新增 `docs/knowledge/system-improvement/2026-04-27-codex-self-improvement-report.md`
- 更新 `C:\Users\mengde\.codex\config.toml`
- 更新 `C:\Users\mengde\.codex\automations\playgroud-improvement-triage\automation.toml`

## Unverified

- 仍需完成文档压缩、零引用文件清理、最终系统校验、完成度检查与 Git 提交。
- 尚未安装 Serena 或 Zotero 只读 MCP，只完成适配评估与优先级判断。

## Blockers

当前无硬阻塞。若后续 `validate-system.ps1`、`check-finish-readiness.ps1` 或 Git 推送失败，先按脚本输出定位，再决定是否收缩本轮改动范围。

## Next

1. 清理零引用且已被核心协议吸收的文档。
2. 完成外部机制矩阵与最终报告。
3. 运行 `validate-system.ps1`、`eval-agent-system.ps1`、`check-finish-readiness.ps1 -Strict`。
4. 审阅 diff，确认只包含本任务相关文件后提交。

## Recovery

从 `D:\Code\Playgroud` 恢复：

```powershell
git status --short --branch
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\check-agent-readiness.ps1 -Strict
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\validate-system.ps1
```

报告入口：

- `docs/knowledge/system-improvement/2026-04-27-codex-self-improvement-report.md`

## Anti-Sycophancy

- Literal-only: 不把“自我改进”理解为堆框架，而是优先修复已有失效机制。
- Real-goal: 真实目标是让 Codex 更少重复犯错、更会恢复、更会复用证据，而不是让仓库看起来更复杂。
- User-premise: 用户要求研究外部项目，但明确禁止照搬结构和大规模复制；因此采用机制筛选而非整包安装。
- Unverified-claims: 不声称 hooks、自动化、MCP 已可用，除非已有脚本输出或配置证据支持。
