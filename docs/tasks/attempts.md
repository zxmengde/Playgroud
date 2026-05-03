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
- status: cancelled
- checkpoint: validate eval diff-check passed after mechanism adoption
- resume_summary: cancelled by TASK-20260503-adoption-proof-audit because final claim conflicted with active task, attempt state and evidence quality
- next_action: use TASK-20260503-adoption-proof-audit for correction; do not treat this attempt as completed adoption proof
- stale_after: 2026-05-04
- verification: fact audit found validator and strict finish false positives
- rollback: git revert current commit
- updated_at: 2026-05-03T10:20:00

### ATT-20260503-003
- id: ATT-20260503-003
- task_id: TASK-20260503-adoption-proof-audit
- status: done
- checkpoint: adoption proof standard, fixture proof, validator, finish gate, state repair and report completed
- resume_summary: recover from active task, board, report and commit on fix/adoption-proof-state-drift
- next_action: user review
- stale_after: 2026-05-04
- verification: validate-delivery-system; validate; eval; git diff --check; strict finish
- rollback: git revert current commit
- updated_at: 2026-05-03T11:10:00

### ATT-20260503-004
- id: ATT-20260503-004
- task_id: TASK-20260503-operational-acceptance
- status: running
- checkpoint: Phase 1 archive restored and trace initialized
- resume_summary: Operational acceptance started from fix/adoption-proof-state-drift baseline
- next_action: run public-entry task, knowledge, research probes and negative guards
- stale_after: 2026-05-04
- verification: strict finish must fail while attempt is open
- rollback: remove ATT-20260503-004 entries before commit or git revert final commit
- updated_at: 2026-05-03T09:19:36

### ATT-20260503-004
- id: ATT-20260503-004
- task_id: TASK-20260503-operational-acceptance
- status: review_needed
- checkpoint: Task probe reached review gate after open-attempt strict failure
- resume_summary: Recover shows ATT-20260503-004 and next action from active task
- next_action: complete knowledge promotion and research queue probes, then close ATT-20260503-004
- stale_after: 2026-05-04
- verification: strict finish must still fail while review_needed
- rollback: remove ATT-20260503-004 entries before commit or git revert final commit
- updated_at: 2026-05-03T09:20:54

### ATT-20260503-004
- id: ATT-20260503-004
- task_id: TASK-20260503-operational-acceptance
- status: done
- checkpoint: Operational acceptance probes, negative guards, trace, and capability rerating completed
- resume_summary: Recover from operational trace, final claim manifest, task board, promotion ledger, and research queue
- next_action: user review final branch/main result; do not claim user_confirmed
- stale_after: 2026-05-04
- verification: validate-delivery-system; validate; eval; git diff --check; strict finish
- rollback: git revert final operational acceptance commit
- updated_at: 2026-05-03T09:29:38
