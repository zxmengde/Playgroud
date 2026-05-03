# Core

## 目标

保持仓库小、清楚、可直接使用。这里不是 agent framework，也不是审计材料仓库。

## 保留内容

- `docs/tasks/`：当前任务、任务板、attempt 记录。
- `docs/knowledge/`：knowledge promotion、research queue、research run log。
- `docs/capabilities.md`：外部机制如何落到本地接口。
- `.codex/skills/`：项目级外部 skills，按任务触发加载。
- `docs/external-skills.md`：项目级外部 skills 的安装事实、CLI 入口和重复能力清单。
- `docs/skill-inventory-2026-05-04.json`：active/disabled skill fit map，记录角色、复判结论、keeper 和触发边界。
- `docs/services.md`：原版外部服务的启动、停止和运行态位置。
- `docs/workflows.md`：最短工作流。
- `scripts/codex.ps1`：唯一主要入口。

## 不保留内容

- 历史整改报告。
- fixture、eval、strict finish、复杂 validator。
- 第三方仓库缓存。
- 未经任务触发的一次性全量读取、常驻 MCP、hooks 和后台服务。

外部 skills 已放在项目级 `.codex/skills/`；使用时仍按任务需要加载，不把全部 skill 内容预读进上下文。

核心本地状态入口由 `workspace-state-workflow` 承载；原版服务入口由
`vibe-kanban-service` 和 `aris-watchdog-service` 承载。二者不得互相替代。

## 启动顺序

```powershell
git status --short --branch
Get-Content -Raw README.md
Get-Content -Raw docs/tasks/active.md
.\scripts\codex.ps1 task recover
```

只在当前任务需要时读取其它文件。
