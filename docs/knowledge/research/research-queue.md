# Research Queue

本文件只定义可审计的长研究队列，不代表后台服务或无人值守运行时已经启用。Policy marker: no background service, no unattended service.

## Queue Policy

- 用户授权边界不清时，只允许排队、整理证据和写 review gate，不执行外部写入。
- 每个队列项必须有 review_gate、evidence_quality、run_log 和 interruption_recovery。
- 长任务不得伪装成后台异步服务；若需要 cron、heartbeat 或外部服务，必须单独授权。

## Queue Item Schema

- id:
- source:
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

当前队列项均为 `blocked`，用于验证本地 queue / review gate 能拒绝证据不足的长研究项；它不代表后台服务已启用。

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
- source: external adoption continuation
- question: How to keep external adoption mechanisms usable without background runtime
- state: blocked
- evidence_quality: insufficient_non_self_evidence
- review_gate: manual review before claiming background capability
- run_log: docs/knowledge/research/run-log.md
- interruption_recovery: resume from research queue, run log and active task
- user_authorization_boundary: no external write or long-running service
- next_action: do not claim long-running research adoption until fixture or real lifecycle proof exists
- rollback: git revert current commit
- updated_at: 2026-05-03T10:20:00

### RQ-20260503-002
- id: RQ-20260503-002
- source: docs/validation/adoption-proof-fixtures.md
- question: Can the local research queue reject insufficient evidence without pretending to run in background?
- state: blocked
- evidence_quality: insufficient_evidence
- review_gate: blocked because queue item has no non-self research evidence yet
- run_log: docs/knowledge/research/run-log.md
- interruption_recovery: resume from queue item and run log before any future claim
- user_authorization_boundary: no external write, cron, daemon, watchdog or unattended service
- next_action: gather non-self evidence before moving to done
- rollback: git revert current commit
- updated_at: 2026-05-03T10:20:00
