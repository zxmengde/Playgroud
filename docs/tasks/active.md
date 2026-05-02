# Active Task

## Status

`TASK-20260503-adoption-proof-audit` 的修复内容已落到修复分支，状态文件、adoption proof、validator、finish gate、capability 评级、failure 记录和审计报告已对齐。

## Last Updated

2026-05-03

## Goal

在 `D:\Code\Playgroud` 内完成一次可审计修复：

- 定义 adoption proof 的硬标准，禁止继续使用粗糙 `adopted` 状态。
- 为 knowledge promotion、task attempt、research queue 补 fixture-based integration proof。
- 降低自指 evidence、open attempt、active task 冲突造成的 validator 假阳性。
- 修复上一轮 active task、attempt 和 board 与最终声明冲突的问题。
- 记录 false adoption closure / state drift failure。
- 在修复分支提交，不直接推送 `main`。

## Done Criteria

- `docs/core/adoption-proof-standard.md` 定义新证据等级和 adopted 替换规则。
- `docs/validation/adoption-proof-fixtures.md` 包含 knowledge、task attempt、research queue 的正反例。
- `validate-delivery-system.ps1` 能阻断自指 evidence、缺失 integration proof、open attempt final claim 和 queue 无 review gate。
- `check-finish-readiness.ps1 -Strict` 能阻断 active task 未验证、latest attempt 未关闭和 final claim 冲突。
- `scripts/codex.ps1 task recover` 输出与 active task、board、latest attempt 一致的 next action。
- `external-adoptions.md` 和 `capability-map.yaml` 使用更严格状态，不再保留 `adopted`。
- 最终运行用户指定验证链，并把结果写入报告。

## Hidden Obligations

- 不通过简单改文字掩盖问题。
- 不删除 attempts 来隐藏上一轮 `review_needed`。
- 不把 adoption card、capability map、ledger 或 validator 自身作为唯一证据。
- 不把 fixture proof 写成用户已验证。
- 不 push `main`。
- 不默认启用 Serena 或其它 MCP。

## Read Sources

- `git show 3d0e91d:*` 中用户指定文件。
- `docs/tasks/active.md`
- `docs/tasks/board.md`
- `docs/tasks/attempts.md`
- `docs/knowledge/promotion-ledger.md`
- `docs/knowledge/research/research-queue.md`
- `docs/capabilities/external-adoptions.md`
- `docs/capabilities/capability-map.yaml`
- `scripts/codex.ps1`
- `scripts/lib/commands/validate-delivery-system.ps1`
- `scripts/lib/commands/check-finish-readiness.ps1`

## Commands

- `git status --short --branch`
- `git log --oneline -5`
- `git show --stat --oneline 3d0e91d`
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

## Artifacts

- `docs/core/adoption-proof-standard.md`
- `docs/validation/adoption-proof-fixtures.md`
- `docs/Codex-adoption-proof-state-drift-audit.md`
- `docs/tasks/active.md`
- `docs/tasks/board.md`
- `docs/tasks/attempts.md`
- `docs/knowledge/promotion-ledger.md`
- `docs/knowledge/research/research-queue.md`
- `docs/knowledge/research/run-log.md`
- `docs/capabilities/external-adoptions.md`
- `docs/capabilities/capability-map.yaml`
- `scripts/codex.ps1`
- `scripts/lib/commands/validate-delivery-system.ps1`
- `scripts/lib/commands/check-finish-readiness.ps1`
- `docs/knowledge/system-improvement/failures/`
- `docs/knowledge/system-improvement/harness-log.md`

## Unverified

pending_validation: false
无当前未验证项；本轮没有直接推送 `main`。

## Blockers

无当前阻塞。若远程推送失败，只能记录修复分支推送错误，不得改推 `main`。

## Next

等待用户 review 修复分支和提交记录。

## Recovery

```powershell
git status --short --branch
Get-Content -Raw .\docs\tasks\active.md
Get-Content -Raw .\docs\tasks\board.md
Get-Content -Raw .\docs\tasks\attempts.md
.\scripts\codex.ps1 task recover
.\scripts\codex.ps1 task board
.\scripts\codex.ps1 knowledge promotions
.\scripts\codex.ps1 research queue
```

回滚优先使用 Git revert；未提交前按最终报告中的文件清单逐项恢复。

## Anti-Sycophancy

- Literal-only: 不把“命令存在”写成能力已内化。
- Real-goal: 真实目标是修复 false completion 和 validator 假阳性，不是让状态看起来更好。
- User-premise: 本轮审计 `3d0e91d` 的证据，不直接推送 `main`。
- Unverified-claims: fixture proof 只能支持 `integration_tested`，不能写成 `task_used` 或 `user_confirmed`。
