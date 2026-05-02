# Local Task Board

本文件是本仓库的轻量任务板。它不替代 Git 历史，也不引入 kanban 服务；它只让 Codex 在中断后能恢复当前任务、下一步、阻塞和已完成记录。

## Active

- task_id: TASK-20260503-adoption-continuity
- outcome: 补全 obsidian-skills、vibe-kanban、Auto-claude-code-research-in-sleep 的本地机制，并合并过细 eval 脚本。
- checkpoint: promotion ledger、task attempt、research queue/review gate、validator 与 help 映射已补齐；`validate`、`eval` 已通过，`git diff --check` 已清理尾随空格后通过。
- next_action: 查看最终 diff，提交，运行 strict finish，推送并确认状态。
- stale_detection: 若本任务已提交推送而 active/board 仍显示 running，必须归档到 `done.md` 并创建新 active task。
- resume_summary: 从 `git status --short --branch`、`docs/tasks/active.md`、`docs/tasks/attempts.md`、`docs/knowledge/promotion-ledger.md` 和 `research queue` 恢复。

## Next

- 提交当前改动。
- 提交后运行 strict finish。
- 推送到 `origin/main` 并确认工作区干净。

## Blocked

无当前阻塞。若 GitHub 推送失败，记录网络错误和可恢复命令。

## Done

- 2026-05-02: 二次整改已由提交 `c552c2f` 推送到 `origin/main`，不再作为 active task 保留。

## Recovery

```powershell
git status --short --branch
Get-Content -Raw .\docs\tasks\board.md
Get-Content -Raw .\docs\tasks\active.md
.\scripts\codex.ps1 task recover
```
