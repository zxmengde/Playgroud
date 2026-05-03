# Research Queue

## Policy

本队列只记录研究问题、状态和 review gate。它不是后台服务，不会自动运行长期任务。

需要真实后台监控时，使用 ARIS 原版 watchdog：`scripts/codex.ps1 aris watchdog ...`。

## Schema

- id:
- source:
- question:
- state: queued | running | review_needed | blocked | done | cancelled
- evidence:
- review_gate:
- next_action:
- updated_at:

## Records

### RQ-20260503-simplify-001
- id: RQ-20260503-simplify-001
- source: repository cleanup request
- question: how to keep external mechanisms usable without keeping validation clutter
- state: done
- evidence: scripts/codex.ps1 review-gate updates queue state; docs/workflows.md documents use
- review_gate: decision: done
- next_action: none
- updated_at: 2026-05-03T18:57:10

### RQ-20260503-services-001
- id: RQ-20260503-services-001
- source: real external service request
- question: how to use original vibe-kanban service together with ARIS background watchdog
- state: done
- evidence: scripts/codex.ps1; docs/services.md; .runtime/aris/watchdog-state.json; .runtime/vibe-kanban/state.json
- review_gate: original runtime services must be started and checked, not replaced by Markdown records
- next_action: use `vibe status` and `aris watchdog status`
- updated_at: 2026-05-03T23:40:00
