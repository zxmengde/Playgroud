# Codex adoption proof state drift audit

## Scope

本报告审计提交 `3d0e91d Complete adoption mechanisms and merge eval scripts` 之后的状态漂移、adoption 证据不足和 validator 假阳性。本轮在分支 `fix/adoption-proof-state-drift` 执行，不直接推送 `main`。

## Audit Conclusion For 3d0e91d

- 上一轮最终声明与仓库状态冲突：`docs/tasks/active.md` 仍写有最终 validate/eval/strict finish/diff 尚未运行、推送尚未执行。
- `docs/tasks/attempts.md` 最新 attempt 原为 `ATT-20260503-002 status: review_needed`，next action 仍指向 commit/push。
- `docs/knowledge/promotion-ledger.md` 原记录只有 `curated_note`，且 evidence 指向 adoption card 和 ledger 自身，不能证明 obsidian-skills 已进入可用能力层。
- `docs/knowledge/research/research-queue.md` 原记录为 `review_needed`，没有 enqueue -> review gate -> reviewed/done/blocked 的闭环。
- 旧 `validate-delivery-system.ps1` 和 `check-finish-readiness.ps1 -Strict` 会在这些矛盾存在时通过，属于假阳性。

## Re-rating

证据等级已从粗糙 `adopted` 改为 `docs/core/adoption-proof-standard.md` 定义的等级：

- `obsidian-skills`: `integration_tested`，证据来自 promotion ledger 非自指记录和 adoption proof fixture。
- `vibe-kanban`: `integration_tested`，证据来自 task attempt lifecycle fixture、board/attempt/recover 和 strict finish gate。
- `Auto-claude-code-research-in-sleep`: `integration_tested`，证据来自 research queue fixture、run-log review gate 和 blocked lifecycle。
- `context-mode`: `partial`，因为目前是 mode policy 和 validator 检查，不是 runtime truncation engine。
- UI、research writing、scholarly source discipline 等仍是 `smoke_passed`，不得写成真实任务或用户确认。

## Anti-false-positive Checks

新增或强化的检查：

- adoption evidence 不得只引用 `external-adoptions.md`、`capability-map.yaml`、promotion ledger、attempts 或 validator 自身。
- `integration_tested` 及以上状态必须有存在的 local artifact、可发现入口、trigger、behavior delta、非自指 evidence、integration proof、rollback 和 prevents_past_error。
- promotion ledger 必须有 raw_note -> curated_note 或 verified_knowledge 证据，且 Obsidian 写入边界不能伪装成已写 vault。
- latest attempt 若为 `running` 或 `review_needed`，不得和完成声明共存。
- research queue terminal state 必须有 review gate，并与 run log 对齐。
- strict finish gate 会检查 pending validation、open attempt 和 finish next action。

## State Repair

- `ATT-20260503-002` 已保留并改为 `cancelled`，原因是被本轮审计纠偏取代。
- 新任务为 `TASK-20260503-adoption-proof-audit`，对应 `ATT-20260503-003`。
- `docs/tasks/board.md` 已从上一轮推送/提交 next action 改为当前审计修复 next action。
- `scripts/codex.ps1 task recover` 已改为同时输出 active task 和 latest attempt。
- 低引用旧报告 `docs/Codex-交付能力去官僚化与外部机制内化整改报告.md` 已删除；其结论被本报告取代。

## Knowledge And Research Repair

- `KP-20260503-001` 改为 `superseded`，不再作为 adopted 证据。
- 新增 `KP-20260503-002` 和 `KP-20260503-003`，形成 raw_note -> verified_knowledge / obsidian_ready 的非自指证据。
- `RQ-20260503-001` 改为 `blocked`，不再伪装闭环。
- 新增 `RQ-20260503-002`，通过 run log review gate 进入 `blocked`，明确不代表后台服务或无人值守运行时。

## Failure Record

已新增 `docs/knowledge/system-improvement/failures/FAIL-20260503-102000-4a33c5.yaml`，并更新 `docs/knowledge/system-improvement/harness-log.md`。失败类型为 false adoption closure / state drift after claimed push。

## Validation Results

已运行并通过：

- `powershell -NoProfile -ExecutionPolicy Bypass -File scripts\codex.ps1 help`
- `powershell -NoProfile -ExecutionPolicy Bypass -File scripts\codex.ps1 task recover`
- `powershell -NoProfile -ExecutionPolicy Bypass -File scripts\codex.ps1 task board`
- `powershell -NoProfile -ExecutionPolicy Bypass -File scripts\codex.ps1 knowledge promotions`
- `powershell -NoProfile -ExecutionPolicy Bypass -File scripts\codex.ps1 research queue`
- `powershell -NoProfile -ExecutionPolicy Bypass -File scripts\lib\commands\validate-delivery-system.ps1`
- `powershell -NoProfile -ExecutionPolicy Bypass -File scripts\codex.ps1 validate`
- `powershell -NoProfile -ExecutionPolicy Bypass -File scripts\codex.ps1 eval`
- `git diff --check`
- `powershell -NoProfile -ExecutionPolicy Bypass -File scripts\lib\commands\check-finish-readiness.ps1 -Strict`

预提交 strict finish 的一次运行因工作区仍有本轮改动而失败，这是 strict gate 对 dirty tree 的预期阻断。提交后在干净工作区复跑 `scripts\lib\commands\check-finish-readiness.ps1 -Strict` 已通过，latest attempt 为 `done`，open high-impact failures 为 0。

## Remaining Items

- 等待用户 review。
- 如需远程同步，只推送 `fix/adoption-proof-state-drift` 修复分支。

## Rollback

使用 `git revert <本轮提交>` 可整体回滚。本轮新增的主要文件为：

- `docs/core/adoption-proof-standard.md`
- `docs/validation/adoption-proof-fixtures.md`
- `docs/Codex-adoption-proof-state-drift-audit.md`
- `docs/knowledge/system-improvement/failures/FAIL-20260503-102000-4a33c5.yaml`

本轮删除的文件：

- `docs/Codex-交付能力去官僚化与外部机制内化整改报告.md`

若未提交，可按 `git diff --name-status` 中的文件清单逐项恢复。

## Why This Does Not Repeat The Same Error

本轮不再把文档存在、命令入口存在或字段存在视为能力内化。`integration_tested` 必须同时有非自指 evidence、fixture 或真实 integration proof、validator 语义检查和回滚路径；final readiness 还必须检查 latest attempt 与 active task 是否闭合。
