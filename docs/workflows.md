# Workflows

## Task Board

```powershell
.\scripts\codex.ps1 task board
.\scripts\codex.ps1 task attempt -Id ATT-YYYYMMDD-001 -TaskId TASK-YYYYMMDD-name -Status running -Checkpoint "..." -NextAction "..."
.\scripts\codex.ps1 task recover
```

用于长任务、中断恢复、记录下一步和阻塞。

需要真实 kanban UI、agent workspace、diff review 和工作区终端时，使用原版 Vibe Kanban：

```powershell
.\scripts\codex.ps1 vibe start -Port 3210
.\scripts\codex.ps1 vibe status
.\scripts\codex.ps1 vibe stop
```

## Knowledge Promotion

```powershell
.\scripts\codex.ps1 knowledge promote -Id KP-YYYYMMDD-001 -Source "..." -Status raw_note -Target repository
.\scripts\codex.ps1 knowledge promote -Id KP-YYYYMMDD-001 -Source "..." -Status curated_note -Target repository
.\scripts\codex.ps1 knowledge promote -Id KP-YYYYMMDD-001 -Source "..." -Status verified_knowledge -Target repository
.\scripts\codex.ps1 knowledge promotions
```

用于把临时信息提升为仓库长期知识。默认不写外部 Obsidian。

## Research Queue

```powershell
.\scripts\codex.ps1 research enqueue -Id RQ-YYYYMMDD-001 -Question "..." -State queued -ReviewGate "manual review before claim"
.\scripts\codex.ps1 research review-gate -Id RQ-YYYYMMDD-001 -Decision review_needed -Evidence "..." -NextAction "..."
.\scripts\codex.ps1 research run-log
```

用于多会话研究和结论前检查。`review-gate` 会同步更新 queue item 状态；它不是后台服务。

需要原版 ARIS 后台监控时，使用 watchdog：

```powershell
.\scripts\codex.ps1 aris install
.\scripts\codex.ps1 aris watchdog start -Interval 60
.\scripts\codex.ps1 aris watchdog register -Name exp01 -Type training -Session exp01 -SessionType tmux -Gpus "0,1"
.\scripts\codex.ps1 aris watchdog status
```
