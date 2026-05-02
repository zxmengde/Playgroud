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

无活动长研究队列。本轮只建立 queue spec 和 validator 检查。
