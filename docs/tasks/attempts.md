# Task Attempts

本文件记录长期任务的 session/task attempt。它服务于 vibe-kanban 的本地化机制：不引入 server，但保留 attempt、checkpoint、resume 和 next action。

## Schema

- id:
- task_id:
- status: running | review_needed | blocked | done | cancelled
- checkpoint:
- resume_summary:
- next_action:
- stale_after:
- verification:
- rollback:
- updated_at:

## Attempts

已有记录如下。新增记录使用：

```powershell
.\scripts\codex.ps1 task attempt -Id ATT-YYYYMMDD-001 -TaskId TASK-YYYYMMDD-name -Status running -Checkpoint "..." -NextAction "..." -Verification "..."
```

### ATT-20260503-001
- id: ATT-20260503-001
- task_id: TASK-20260503-adoption-continuity
- status: running
- checkpoint: partial adoptions converted to command-backed mechanisms
- resume_summary: continue from active task, task board, promotion ledger and research queue
- next_action: run validator chain
- stale_after: 2026-05-04
- verification: scripts/codex.ps1 validate; scripts/codex.ps1 eval
- rollback: git revert current commit
- updated_at: 2026-05-03T03:33:06

### ATT-20260503-002
- id: ATT-20260503-002
- task_id: TASK-20260503-adoption-continuity
- status: review_needed
- checkpoint: validate eval diff-check passed after mechanism adoption
- resume_summary: ready for final diff review, commit, strict finish and push
- next_action: commit and push after final status
- stale_after: 2026-05-04
- verification: validate; eval; validate-delivery-system; git diff --check
- rollback: git revert current commit
- updated_at: 2026-05-03T03:36:50
