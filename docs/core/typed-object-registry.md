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
| failure | `docs/knowledge/system-improvement/failures/` | id、summary、impact、status、evidence、next_review | captured、triaged、candidate、closed、suppressed、rejected | capture -> triage -> candidate/closed |
| lesson | `docs/knowledge/system-improvement/lessons/` | id、title、status、target、verification、rollback | accepted、promoted、verified、under_review、deprecated、rolled_back、expired、rejected | draft -> accepted -> promoted -> verified/deprecated |
| capability | `docs/capabilities/capability-map.yaml` | id、source_projects、maturity_status、user_visible_entry、codex_trigger、verification、rollback | declared、smoke_passed、task_proven、user_proven、experimental、deprecated | declare -> smoke_passed/experimental -> task_proven -> user_proven/deprecated |
| external_adoption | `docs/capabilities/external-adoptions.md` | source_project、inspected_evidence、learned_mechanism、local_artifact、trigger_condition、codex_behavior_delta、verification、rollback、status | adopted、partial、rejected_with_substitute | inspect -> partial/adopted/rejected_with_substitute |
| research_queue | `docs/knowledge/research/research-queue.md` 或 `run-log.md` | question、state、evidence_quality、review_gate、run_log、interruption_recovery | queued、running、review_needed、blocked、done、cancelled | queue -> running -> review_needed -> done/blocked |

## 成熟度边界

- declared：只有文档声明。
- smoke_passed：只有样例或 smoke 路径通过。
- experimental：可试用，但未证明稳定。
- task_proven：在真实任务 eval 或真实交付中有证据。
- user_proven：用户在真实使用中确认有效。
- deprecated：保留历史，不再默认使用。

不得把 sample smoke 直接写成 task_proven 或 user_proven。
