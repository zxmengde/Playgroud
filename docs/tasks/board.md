# Local Task Board

本文件是本仓库的轻量任务板。它不替代 Git 历史，也不引入 kanban 服务；它只让 Codex 在中断后能恢复当前任务、下一步、阻塞和已完成记录。

## Active

- task_id: TASK-20260503-delivery-debureaucracy
- outcome: 完成 Codex 交付能力去官僚化、外部机制内化和目录去水整改。
- checkpoint: 基线已确认；外部项目证据来自 `.cache/external-repos`；正在落地 adoption、capability、核心合同、validator、目录清理和报告。
- next_action: 完成文件改动，清理缓存，运行新增 validator、validate、eval 和 diff 检查。
- stale_detection: 若 `docs/tasks/active.md` 的 Last Updated 早于最近提交或仍指向已推送任务，必须更新或归档。
- resume_summary: 从 `git status --short --branch`、本文件、`docs/tasks/active.md`、最终报告草稿恢复。

## Next

- 将 adoption cards 与 capability map 绑定。
- 清理 `.cache/external-repos` 和一次性报告噪声。
- 接入 `validate-delivery-system.ps1`。
- 更新 README、AGENTS、核心入口、help 和 hook stdin 示例。

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
