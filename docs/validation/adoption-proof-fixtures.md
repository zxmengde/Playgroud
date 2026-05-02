# Adoption Proof Fixtures

本文件提供 fixture-based integration proof。它不是任务报告；validator 必须读取这些正反例，防止把字段存在、自指 evidence 或 open attempt 误判为能力内化。

## Positive Knowledge Promotion

- id: KP-FIXTURE-001
- source: docs/workflows/knowledge.md
- lifecycle: raw_note -> curated_note -> verified_knowledge
- target: repository
- evidence: docs/workflows/knowledge.md; docs/core/adoption-proof-standard.md
- verification: scripts/codex.ps1 knowledge promotions; scripts/lib/commands/validate-delivery-system.ps1
- rollback: remove fixture or revert commit
- expected_result: pass

## Positive Task Attempt Lifecycle

- id: ATT-FIXTURE-001
- task_id: TASK-FIXTURE-adoption-proof
- lifecycle: running -> review_needed -> done
- checkpoint: fixture proves checkpoint and resume fields are meaningful
- resume_summary: recover from board and latest attempt
- next_action: no pending commit or push after done
- stale_after: 2099-01-01
- verification: scripts/codex.ps1 task recover; scripts/lib/commands/check-finish-readiness.ps1 -Strict
- rollback: remove fixture or revert commit
- expected_result: pass

## Positive Research Queue Lifecycle

- id: RQ-FIXTURE-001
- source: docs/knowledge/research/research-queue.md
- lifecycle: queued -> review_gate -> blocked
- evidence_quality: insufficient_evidence
- review_gate: blocked because evidence is insufficient
- run_log: docs/knowledge/research/run-log.md
- interruption_recovery: resume from queue item and run log before further claims
- user_authorization_boundary: no background service or external write
- next_action: gather non-self evidence before requeue
- rollback: remove fixture or revert commit
- expected_result: pass

## Expected Failure Cases

### self-referential-adoption-evidence

- status_under_test: integration_tested
- evidence: docs/capabilities/external-adoptions.md; docs/capabilities/capability-map.yaml; docs/knowledge/promotion-ledger.md; scripts/lib/commands/validate-delivery-system.ps1
- expected_result: fail
- reason: evidence only cites metadata and validator files.

### open-attempt-final-claim

- task_id: TASK-FIXTURE-open-attempt
- attempt_status: review_needed
- active_claim: completed and pushed
- expected_result: fail
- reason: open attempt cannot coexist with final completion claim.

### queue-without-review-gate

- id: RQ-FIXTURE-BAD-001
- lifecycle: queued -> done
- review_gate:
- expected_result: fail
- reason: long research queue item has no review gate.
