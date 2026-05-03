# Core

## 目标

保持仓库小、清楚、可直接使用。这里不是 agent framework，也不是审计材料仓库。

## 保留内容

- `docs/tasks/`：当前任务、任务板、attempt 记录。
- `docs/knowledge/`：knowledge promotion、research queue、research run log。
- `docs/capabilities.md`：外部机制如何落到本地接口。
- `docs/services.md`：原版外部服务的启动、停止和运行态位置。
- `docs/workflows.md`：最短工作流。
- `scripts/codex.ps1`：唯一主要入口。

## 不保留内容

- 历史整改报告。
- fixture、eval、strict finish、复杂 validator。
- 第三方仓库缓存。
- 未经明确任务触发的 skills、hooks、MCP 和后台服务。

## 启动顺序

```powershell
git status --short --branch
Get-Content -Raw README.md
Get-Content -Raw docs/tasks/active.md
.\scripts\codex.ps1 task recover
```

只在当前任务需要时读取其它文件。
