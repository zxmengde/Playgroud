# Active Task

## Status

`TASK-20260503-operational-acceptance` 已完成操作验收与最终声明校验的本地改造。三个重点机制已在真实仓库任务中通过公开入口使用一次；该证据只支持 `task_used`，不支持 `user_confirmed`。

## Last Updated

2026-05-03

## Goal

在 `D:\Code\Playgroud` 内完成一次可审计的操作验收：

- 保留上一轮 false adoption closure / state drift 的审计链。
- 用公开入口实际运行 task attempt、knowledge promotion、research queue review gate。
- 构造三个负例，证明 validator 和 strict finish gate 不只会通过。
- 建立 final claim manifest，让最终回复中的完成、提交、推送、验证、合并和 review 声明有证据字段支撑。
- 只有全部验收和验证通过后，才允许 fast-forward 合并 `main`。

## Done Criteria

- 旧错误报告恢复到 `docs/archive/reports/2026-05-03-Codex-交付能力去官僚化与外部机制内化整改报告.superseded.md`，并带 superseded notice。
- `docs/validation/operational-acceptance-trace.md` 记录 baseline、三个真实 probe、三个负例、final claim guard、merge decision 和 rollback。
- `ATT-20260503-004` 至少经历 `running -> review_needed -> done`，且 `task recover`、`task board` 与 latest attempt 一致。
- 本轮 false adoption closure 知识提升经 `knowledge promote` 形成 raw/curated/verified 记录，并使用非自指 evidence。
- 本轮 research queue item 经 `research enqueue -> research review-gate -> terminal state`，run log 与 queue 状态一致。
- 自指 evidence、open attempt 假完成、research queue 缺 review gate 三个负例均按预期失败，坏状态不提交。
- `check-finish-readiness.ps1 -Strict` 能读取或校验 `docs/validation/final-claim-manifest.md`。
- 三个重点机制仅在真实 probe 通过后升为 `task_used`，不得写成 `user_confirmed`。
- 用户指定验证链全部通过；若不通过，不合并 main。

## Hidden Obligations

- 不通过改状态标签制造进展。
- 不删除旧报告、旧 failure 或旧 attempt；只能归档、superseded、cancelled 或 deprecated。
- 不把 fixture proof 当成真实任务 proof。
- 不把分支推送写成 main 已推送。
- 不默认启用 Serena、Browser、GitHub、Obsidian 或其它 MCP。
- 负例测试后必须恢复干净状态。

## Read Sources

- `git status --short --branch`
- `git branch -vv`
- `git log --oneline --decorate -8`
- `docs/Codex-adoption-proof-state-drift-audit.md`
- `docs/core/adoption-proof-standard.md`
- `docs/validation/adoption-proof-fixtures.md`
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

## Commands

- `git fetch --all --prune`
- `git status --short --branch`
- `git branch -vv`
- `git log --oneline --decorate -8`
- `powershell -NoProfile -ExecutionPolicy Bypass -File scripts\codex.ps1 task attempt ...`
- `powershell -NoProfile -ExecutionPolicy Bypass -File scripts\codex.ps1 knowledge promote ...`
- `powershell -NoProfile -ExecutionPolicy Bypass -File scripts\codex.ps1 research enqueue ...`
- `powershell -NoProfile -ExecutionPolicy Bypass -File scripts\codex.ps1 research review-gate ...`
- `powershell -NoProfile -ExecutionPolicy Bypass -File scripts\lib\commands\validate-delivery-system.ps1`
- `powershell -NoProfile -ExecutionPolicy Bypass -File scripts\codex.ps1 validate`
- `powershell -NoProfile -ExecutionPolicy Bypass -File scripts\codex.ps1 eval`
- `git diff --check`
- `powershell -NoProfile -ExecutionPolicy Bypass -File scripts\lib\commands\check-finish-readiness.ps1 -Strict`

## Artifacts

- `docs/archive/reports/2026-05-03-Codex-交付能力去官僚化与外部机制内化整改报告.superseded.md`
- `docs/validation/operational-acceptance-trace.md`
- `docs/validation/final-claim-manifest.md`
- `docs/tasks/active.md`
- `docs/tasks/board.md`
- `docs/tasks/attempts.md`
- `docs/knowledge/promotion-ledger.md`
- `docs/knowledge/research/research-queue.md`
- `docs/knowledge/research/run-log.md`
- `docs/capabilities/external-adoptions.md`
- `docs/capabilities/capability-map.yaml`
- `scripts/lib/commands/check-finish-readiness.ps1`

## Unverified

pending_validation: false
本轮 operational acceptance、负例测试和 final claim guard 的本地文件状态已完成；提交、分支推送和 main 合并结果以最终 Git 命令输出为准。

## Blockers

无当前阻塞。若最终验证、提交、分支推送或 fast-forward 合并失败，保留 `fix/adoption-proof-state-drift` 分支并报告失败，不合并 main。

## Next

用户 review 本轮 operational acceptance 结果；最终回复必须逐项报告分支、提交、推送、main 合并、工作区状态、latest attempt、active task、验证、负例、能力评级和回滚方式。

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

回滚优先使用 Git revert。未提交前按 `docs/validation/operational-acceptance-trace.md` 的 rollback 字段逐项恢复。

## Anti-Sycophancy

- Literal-only: 不把“命令已经存在”写成真实任务可用。
- Real-goal: 真实目标是验收本地机制和最终声明守卫，不是继续新增文档。
- User-premise: 未通过 operational acceptance 时不得合并 main。
- Unverified-claims: 没有用户明确确认时，不得写成 `user_confirmed`。
