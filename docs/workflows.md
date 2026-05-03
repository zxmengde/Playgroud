# Workflows

## Task Board

```powershell
.\scripts\codex.ps1 task board
.\scripts\codex.ps1 task attempt -Id ATT-YYYYMMDD-001 -TaskId TASK-YYYYMMDD-name -Status running -Checkpoint "..." -NextAction "..."
.\scripts\codex.ps1 task recover
```

用于长任务、中断恢复、记录下一步和阻塞。

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
