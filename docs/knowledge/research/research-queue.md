# Research Queue

本文件只定义可审计的长研究队列，不代表后台服务或无人值守运行时已经启用。

## Queue Policy

- 用户授权边界不清时，只允许排队、整理证据和写 review gate，不执行外部写入。
- 每个队列项必须有 review_gate、evidence_quality、run_log 和 interruption_recovery。
- 长任务不得伪装成后台异步服务；若需要 cron、heartbeat 或外部服务，必须单独授权。

## Queue Item Schema

- id:
- question:
- state: queued | running | review_needed | blocked | done | cancelled
- evidence_quality:
- review_gate:
- run_log:
- interruption_recovery:
- user_authorization_boundary:
- next_action:
- rollback:

## Current Queue

当前有一项 review_needed 记录，用于验证本地 queue / review gate 机制；它不代表后台服务已启用。

## Commands

```powershell
.\scripts\codex.ps1 research queue
.\scripts\codex.ps1 research enqueue -Id RQ-YYYYMMDD-001 -Question "..." -State queued -EvidenceQuality unchecked -ReviewGate "manual review before claim" -NextAction "..."
.\scripts\codex.ps1 research review-gate -Id RQ-YYYYMMDD-001 -Decision review_needed -EvidenceQuality unchecked -NextAction "..."
.\scripts\codex.ps1 research run-log
```

`enqueue` 只写入本文件的队列记录。`review-gate` 只写入 `docs/knowledge/research/run-log.md`，不得被解释为后台执行或自动通过。

### RQ-20260503-001
- id: RQ-20260503-001
- question: How to keep external adoption mechanisms usable without background runtime
- state: review_needed
- evidence_quality: local artifacts and validators
- review_gate: manual review before claiming background capability
- run_log: docs/knowledge/research/run-log.md
- interruption_recovery: resume from research queue, run log and active task
- user_authorization_boundary: no external write or long-running service
- next_action: run validate-delivery-system
- rollback: git revert current commit
- updated_at: 2026-05-03T03:33:17
