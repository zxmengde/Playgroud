# Active Task

## Status

原版 vibe-kanban 服务与 ARIS watchdog 后台能力已接入。

## Goal

保留精简仓库结构，同时提供真实外部服务入口：`vibe` 启动原版 Vibe Kanban，`aris watchdog` 启动 ARIS 原版后台监控进程。

## Next

需要 UI 任务板时访问 `http://127.0.0.1:3210`；需要停止后台服务时运行 `vibe stop` 和 `aris watchdog stop`。

## Recovery

```powershell
git status --short --branch
.\scripts\codex.ps1 task recover
.\scripts\codex.ps1 task board
.\scripts\codex.ps1 vibe status
.\scripts\codex.ps1 aris watchdog status
```

## Blockers

无。
