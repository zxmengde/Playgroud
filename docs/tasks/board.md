# Task Board

## Active

- task_id: TASK-20260503-real-external-services
- checkpoint: 原版 Vibe Kanban 与 ARIS watchdog 已通过统一入口接入
- next_action: 需要时使用 `vibe status`、`aris watchdog status` 查看后台运行状态
- stale_detection: 若 active、board、attempts 的下一步不一致，先更新这三个文件
- resume_summary: 从 `docs/tasks/active.md`、`docs/tasks/board.md`、`docs/tasks/attempts.md` 恢复

## Next

- none

## Blocked

- none

## Done

- 2026-05-03: 仓库删去历史报告、验证 fixture、私有命令脚本、skills、hooks、references、templates 和外部缓存噪声，只保留核心工作入口。
- 2026-05-03: `scripts/codex.ps1` 已确认支持 task、knowledge、research 的命名参数调用。
- 2026-05-03: `scripts/codex.ps1` 已接入原版 `npx vibe-kanban` 服务和 ARIS `tools/watchdog.py` 后台进程。
