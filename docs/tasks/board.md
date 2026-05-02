# Local Task Board

本文件是本仓库的轻量任务板。它不替代 Git 历史，也不引入 kanban 服务；它只让 Codex 在中断后能恢复当前任务、下一步、阻塞和已完成记录。

## Active

- task_id: TASK-20260503-adoption-proof-audit
- outcome: 审计 `3d0e91d` 的 adoption proof、状态漂移和 validator 假阳性，并提交修复分支。
- checkpoint: adoption proof standard、fixture proof、validator、finish gate、状态同步、failure 记录和报告已完成。
- next_action: 等待用户 review 修复分支和提交记录。
- stale_detection: 若 latest attempt 为 `running` 或 `review_needed` 且 active task 声称完成，finish gate 必须失败；若 active 与 board 指向不同任务，先修状态再收尾。
- resume_summary: 从 `git status --short --branch`、`docs/tasks/active.md`、`docs/tasks/attempts.md`、`docs/tasks/board.md`、promotion ledger 和 research queue 恢复。

## Next

- 无当前 next task；后续只按用户 review 意见继续。

## Blocked

无当前阻塞。若 GitHub 推送失败，记录网络错误和可恢复命令。

## Done

- 2026-05-02: 二次整改已由提交 `c552c2f` 推送到 `origin/main`，不再作为 active task 保留。
- 2026-05-03: 提交 `3d0e91d` 已存在于本地历史；其 adoption-continuity attempt 被本轮审计判定存在状态漂移，需以当前修复分支纠偏。
- 2026-05-03: `TASK-20260503-adoption-proof-audit` 完成状态纠偏和反假阳性检查器，未直接推送 `main`。

## Recovery

```powershell
git status --short --branch
Get-Content -Raw .\docs\tasks\board.md
Get-Content -Raw .\docs\tasks\active.md
.\scripts\codex.ps1 task recover
```
