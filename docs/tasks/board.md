# Local Task Board

本文件是本仓库的轻量任务板。它不替代 Git 历史，也不引入 kanban 服务；它只让 Codex 在中断后能恢复当前任务、下一步、阻塞和已完成记录。

## Active

- task_id: TASK-20260503-operational-acceptance
- outcome: 对 `fix/adoption-proof-state-drift` 做真实操作验收，并建立 final claim guard。
- checkpoint: 旧报告已归档；task、knowledge、research 三个真实 probe 通过；三个负例按预期失败；`ATT-20260503-004` 已关闭为 `done`。
- next_action: 用户 review 本轮提交、main 合并和推送结果；不得把 `task_used` 写成 `user_confirmed`。
- stale_detection: 若 latest attempt 为 `running` 或 `review_needed`，`check-finish-readiness.ps1 -Strict` 必须失败；若 active、board、attempt 指向不同任务，先修状态再收尾。
- resume_summary: 从 `git status --short --branch`、`docs/tasks/active.md`、`docs/tasks/attempts.md`、`docs/tasks/board.md`、operational trace、promotion ledger 和 research queue 恢复。

## Next

- 用户 review operational acceptance trace、final claim manifest、capability 评级和最终验证结果。

## Blocked

无当前阻塞。若任一验收失败，保留修复分支并报告失败，不合并 main。

## Done

- 2026-05-02: 二次整改已由提交 `c552c2f` 推送到 `origin/main`，不再作为 active task 保留。
- 2026-05-03: 提交 `3d0e91d` 已存在于本地历史；其 adoption-continuity attempt 被后续审计判定存在状态漂移。
- 2026-05-03: `TASK-20260503-adoption-proof-audit` 完成状态纠偏和反假阳性检查器，提交到 `fix/adoption-proof-state-drift`，未直接推送 `main`。
- 2026-05-03: 旧整改报告已恢复到 archive 并标记 superseded，保留错误历史。
- 2026-05-03: `TASK-20260503-operational-acceptance` 完成 task attempt、knowledge promotion、research queue 的真实操作验收，并记录三个负例测试。

## Recovery

```powershell
git status --short --branch
Get-Content -Raw .\docs\tasks\board.md
Get-Content -Raw .\docs\tasks\active.md
.\scripts\codex.ps1 task recover
```
