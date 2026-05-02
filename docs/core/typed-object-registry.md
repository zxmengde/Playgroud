# Typed Object Registry

本注册表统一 task、failure、lesson、capability、external adoption、research queue 等对象的字段、状态和生命周期，避免 active、smoke、proven 等词混用。

## 通用字段

所有对象至少应能追溯：

- id 或 source_project
- type
- status
- owner_path
- evidence
- verification
- rollback
- updated_at 或 last_updated

## 对象类型

| type | owner_path | 必需字段 | 状态枚举 | 生命周期 |
| --- | --- | --- | --- | --- |
| task | `docs/tasks/active.md`、`docs/tasks/board.md`、`docs/tasks/done.md` | outcome、status、next_action、checkpoint、verification | active、next、blocked、done、archived | create -> active/blocked -> done/archived |
| task_attempt | `docs/tasks/attempts.md` | id、task_id、status、checkpoint、resume_summary、next_action、stale_after、verification、rollback | running、review_needed、blocked、done、cancelled | start -> checkpoint -> review_needed/done/blocked |
| failure | `docs/knowledge/system-improvement/failures/` | id、summary、impact、status、evidence、next_review | captured、triaged、candidate、closed、suppressed、rejected | capture -> triage -> candidate/closed |
| lesson | `docs/knowledge/system-improvement/lessons/` | id、title、status、target、verification、rollback | accepted、promoted、verified、under_review、deprecated、rolled_back、expired、rejected | draft -> accepted -> promoted -> verified/deprecated |
| capability | `docs/capabilities/capability-map.yaml` | id、source_projects、maturity_status、user_visible_entry、codex_trigger、verification、rollback | documented、command_stub、smoke_passed、partial、integration_tested、task_used、user_confirmed、deprecated | documented -> smoke_passed/partial -> integration_tested -> task_used -> user_confirmed/deprecated |
| external_adoption | `docs/capabilities/external-adoptions.md` | source_project、inspected_evidence、learned_mechanism、local_artifact、trigger_condition、codex_behavior_delta、user_visible_entry、evidence、integration_proof、verification、rollback、prevents_past_error、status | documented、command_stub、smoke_passed、partial、integration_tested、task_used、user_confirmed、deprecated | inspect -> documented/command_stub/partial -> integration_tested -> task_used/user_confirmed |
| knowledge_promotion | `docs/knowledge/promotion-ledger.md` | id、source、status、target、evidence、verification、rollback、next_action | raw_note、curated_note、verified_knowledge、archived、superseded | raw_note -> curated_note -> verified_knowledge -> archived/superseded |
| research_queue | `docs/knowledge/research/research-queue.md` 或 `run-log.md` | id、source、question、state、evidence_quality、review_gate、run_log、interruption_recovery、user_authorization_boundary、next_action | queued、running、review_needed、blocked、done、cancelled | queue -> review_gate -> done/blocked |

## 成熟度边界

- documented：只有文档声明。
- command_stub：有命令入口或对象字段，但语义检查不足。
- smoke_passed：只有样例或 smoke 路径通过。
- partial：已吸收部分机制，但存在明确未覆盖范围。
- integration_tested：有真实或 fixture-based integration proof，且 validator 检查关键语义。
- task_used：在真实任务中有非自指证据。
- user_confirmed：用户在真实使用中确认有效。
- deprecated：保留历史，不再默认使用。

不得把 sample smoke 直接写成 task_used 或 user_confirmed。`adopted` 不是允许状态。
