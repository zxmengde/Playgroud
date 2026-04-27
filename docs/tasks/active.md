# Active Task

## Goal

实施 Playgroud 自我进化精简计划：合并入口，删除无效同步副本和无引用模板，修复 MCP、hook、eval、任务状态和跨 PowerShell 运行时验证，使仓库更简洁、可靠、可恢复、可审计。

## Read Sources

- `AGENTS.md`
- `README.md`
- `docs/core/index.md`
- `docs/profile/user-model.md`
- `docs/profile/preference-map.md`
- `docs/capabilities/index.md`
- `docs/references/assistant/codex-app-settings.md`
- `docs/references/assistant/mcp-capability-plan.md`
- `docs/references/assistant/plugin-mcp-availability.md`
- `docs/references/assistant/external-capability-radar.md`
- `docs/references/assistant/third-party-skill-evaluation.md`
- `docs/workflows/coding.md`
- 用户提供的实施计划

## Commands

- `git status --short --branch`
- `.\scripts\git-safe.ps1 pull --ff-only`
- `git switch -c codex/playgroud-self-evolution-prune`
- `rg --files`
- `rg -n ...`

## Artifacts

- 新增 `docs/core/index.md`
- 合并更新 `docs/capabilities/index.md`
- 新增 `.agents/skills/playgroud-maintenance/SKILL.md`
- 新增 `.codex/hooks.json`
- 新增 hook 脚本与 `scripts/eval-agent-system.ps1`
- 更新 MCP allowlist schema
- 正在删除旧 `skills/` 同步副本和无引用模板

## Unverified

- 仍需完成全部路径引用修正。
- 仍需运行 Windows PowerShell 与 PowerShell 7 双运行时验证。
- 仍需确认最终跟踪文件数量、低引用候选数量和 MCP unknown 数量。

## Blockers

当前无阻塞。若 GitHub 推送失败，将先使用 `scripts/git-safe.ps1` 和 Git 网络诊断脚本定位。

## Next

继续修复脚本、文档引用和任务归档后运行：

```powershell
pwsh.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\validate-system.ps1
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\validate-system.ps1
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\check-finish-readiness.ps1 -Strict
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\eval-agent-system.ps1
git status --short --branch
```

## Recovery

从 `D:\Code\Playgroud` 恢复：

```powershell
git status --short --branch
rg -n "docs/core/(companion-target|self-configuration|identity-and-goal|permission-boundary|execution-loop|memory-state|finish-readiness)|docs/capabilities/(gap-review|companion-roadmap|pruning-review)|(^|[\\/])skills[\\/]" AGENTS.md README.md docs scripts templates .agents
pwsh.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\validate-system.ps1
```

## Anti-Sycophancy

- Literal-only: 未停留在用户计划复述，已实际合并入口、删除旧副本并新增机制。
- Real-goal: 真实目标是降低维护复杂度，并让失败更容易被发现和恢复。
- User-premise: 用户关于复杂度过高的判断已由文件数量、低引用候选、MCP 配置漂移和脚本运行失败支撑。
- Unverified-claims: 不声称能力已经稳定；hook、eval 和自动化仍需真实任务继续验证。
