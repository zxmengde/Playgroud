# Research Queue

## Policy

本队列只记录研究问题、状态和 review gate。它不是后台服务，不会自动运行长期任务。

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
