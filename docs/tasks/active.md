# Active Task

## Goal

在 `D:\Code\Playgroud` 内把 Serena 与 Obsidian 从 candidate 能力提升为真实可用能力：完成 Serena 用户级 MCP 接通、Obsidian 官方 CLI 接通、仓库路由与能力登记同步，并留下可验证的接通记录。

## Read Sources

- `AGENTS.md`
- `docs/core/index.md`
- `docs/profile/user-model.md`
- `docs/profile/preference-map.md`
- `docs/tasks/active.md`
- `docs/knowledge/system-improvement/routing-v1.yaml`
- `docs/knowledge/system-improvement/harness-log.md`
- `docs/workflows/coding.md`
- `docs/workflows/research.md`
- `docs/workflows/knowledge.md`
- `docs/workflows/self-improvement.md`
- `docs/workflows/product.md`
- `docs/workflows/uiux.md`
- `.codex/hooks.json`
- `docs/references/assistant/mcp-capability-plan.md`
- `docs/references/assistant/external-capability-radar.md`
- `scripts/validate-system.ps1`
- `scripts/eval-agent-system.ps1`
- `scripts/check-finish-readiness.ps1`
- `C:\Users\mengde\.codex\config.toml`
- `C:\Users\mengde\.codex\automations\playgroud-readiness-audit\automation.toml`
- `C:\Users\mengde\.codex\automations\playgroud-improvement-triage\automation.toml`

## Commands

- `git status --short --branch`
- `git rev-parse HEAD`
- `uv tool install -p 3.13 serena-agent@latest --prerelease=allow`
- `serena --help`
- `serena start-mcp-server --help`
- `Obsidian.com version`
- `obsidian vaults total`
- `obsidian vault=790d1fd6473f4a93 search query="Zotero" total`
- `obsidian vault=530512f0c6c3c99b read path="Codex/obsidian-cli-smoke.md"`
- `scripts/audit-serena-obsidian-readiness.ps1`
- `powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\validate-failure-log.ps1`
- `powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\validate-lessons.ps1`
- `powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\validate-routing-v1.ps1`
- `powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\validate-skill-contracts.ps1`
- `powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\validate-active-load.ps1`
- `powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\validate-system.ps1`
- `powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\eval-agent-system.ps1`
- `powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\check-finish-readiness.ps1 -Strict`

## Artifacts

- `docs/knowledge/system-improvement/failures/`
- `docs/knowledge/system-improvement/lessons/`
- `docs/knowledge/system-improvement/routing-v1.yaml`
- `docs/knowledge/system-improvement/2026-05-01-serena-obsidian-integration.md`
- `.agents/skills/failure-promoter/SKILL.md`
- `.agents/skills/external-mechanism-researcher/SKILL.md`
- `.agents/skills/research-engineering-loop/SKILL.md`
- `.agents/skills/product-engineering-closer/SKILL.md`
- `.agents/skills/uiux-reviewer/SKILL.md`
- `.agents/skills/knowledge-curator/SKILL.md`
- `.agents/skills/tool-router/SKILL.md`
- `.agents/skills/finish-verifier/SKILL.md`
- `scripts/validate-failure-log.ps1`
- `scripts/validate-lessons.ps1`
- `scripts/validate-routing-v1.ps1`
- `scripts/validate-skill-contracts.ps1`
- `scripts/validate-active-load.ps1`
- `scripts/audit-serena-obsidian-readiness.ps1`
- `scripts/eval-repeat-failure-capture.ps1`
- `scripts/eval-lesson-promotion.ps1`
- `scripts/eval-routing-selection.ps1`
- `scripts/eval-external-mechanism-review-check.ps1`
- `scripts/eval-research-memo-quality.ps1`
- `scripts/eval-uiux-review-quality.ps1`
- `scripts/eval-session-recovery.ps1`
- `scripts/eval-unverified-closeout-block.ps1`
- `scripts/eval-product-engineering-closeout.ps1`
- `scripts/codex-hook-session-start.ps1`
- `scripts/codex-hook-post-tool-capture.ps1`
- `scripts/codex-hook-stop-check.ps1`
- `docs/workflows/self-improvement.md`
- `docs/workflows/product.md`
- `docs/workflows/uiux.md`
- 更新后的核心入口、能力索引、MCP 方案和知识流程

## Unverified

无。

## Blockers

当前线程的可用工具集不会自动热更新，因此 Serena 即使已写入用户级 Codex 配置，也需要新会话才能直接出现在工具面板中。当前可通过本地安装、配置和 smoke test 验证接通状态。

## Next

1. 在真实代码仓库中开始使用 Serena 做符号导航、引用查找和跨文件重构。
2. 在真实科研任务中直接使用 Obsidian CLI 写入阅读笔记、研究 memo 和知识条目。
3. 若未来需要 heading/frontmatter 级 patch，再评估 Obsidian REST API 或 MCP。

## Recovery

从 `D:\Code\Playgroud` 恢复：

```powershell
git status --short --branch
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\validate-system.ps1
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\check-agent-readiness.ps1 -Strict
```

运行态入口：

- `docs/core/index.md`
- `docs/knowledge/system-improvement/routing-v1.yaml`
- `docs/knowledge/system-improvement/failures/`
- `docs/knowledge/system-improvement/lessons/`
- `docs/knowledge/system-improvement/2026-05-01-serena-obsidian-integration.md`

## Anti-Sycophancy

- Literal-only: 不把“极小核心”误解成“能力贫弱”，而是用完整能力层支撑短核心。
- Real-goal: 真实目标是让 Codex 更少重复犯错、更会恢复、更会研究、更会收尾，而不是堆更多说明文档。
- User-premise: 用户要求一次性落地最终版，因此不能用继续设计或只修脚本代替最终实施。
- Unverified-claims: 不声称 Serena、Obsidian 或 remote runtime 已完整接入；没有真实环境证据时，只能明确写成 pilot、candidate 或 blocker。
