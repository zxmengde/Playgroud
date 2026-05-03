# Playgroud

这是一个极简的 Codex 工作区控制仓库。保留的东西只有三类：

- 当前任务状态：`docs/tasks/`
- 长期知识和研究队列：`docs/knowledge/`
- 可直接调用的统一入口：`scripts/codex.ps1`

不再保留历史审计报告、fixture、复杂 validator、eval、hooks、skills 堆叠和外部仓库缓存。

## 快速入口

```powershell
.\scripts\codex.ps1 help
.\scripts\codex.ps1 task board
.\scripts\codex.ps1 task recover
.\scripts\codex.ps1 knowledge promotions
.\scripts\codex.ps1 research queue
.\scripts\codex.ps1 capability map
```

## 外部机制已吸收的本地能力

### obsidian-skills -> knowledge promotion

默认先写仓库内 promotion ledger，不直接写外部 Obsidian vault。

```powershell
.\scripts\codex.ps1 knowledge promote -Id KP-20260503-001 -Source "note or file" -Status curated_note -Target repository -Evidence "source path" -NextAction "verify or archive"
.\scripts\codex.ps1 knowledge promotions
```

### vibe-kanban -> task board / attempt / recover

长期任务用 board 和 attempts 记录 checkpoint、next action 和恢复信息。

```powershell
.\scripts\codex.ps1 task board
.\scripts\codex.ps1 task attempt -Id ATT-20260503-001 -TaskId TASK-20260503-cleanup -Status running -Checkpoint "started" -NextAction "continue cleanup"
.\scripts\codex.ps1 task recover
```

### Auto-claude-code-research-in-sleep -> research queue / review gate

只保留本地队列和 review gate，不伪装后台服务。

```powershell
.\scripts\codex.ps1 research enqueue -Id RQ-20260503-001 -Question "research question" -State queued -ReviewGate "manual review before claim"
.\scripts\codex.ps1 research review-gate -Id RQ-20260503-001 -Decision review_needed -Evidence "what was checked" -NextAction "continue or stop"
.\scripts\codex.ps1 research queue
```

`review-gate` 会写入 `research-run-log.md`，并同步更新对应 queue item 的状态。

## 目录

```text
AGENTS.md
README.md
docs/
  capabilities.md
  core.md
  profile.md
  workflows.md
  tasks/
    active.md
    attempts.md
    board.md
  knowledge/
    promotion-ledger.md
    research-queue.md
    research-run-log.md
scripts/
  codex.ps1
  git-safe.ps1
  pre-commit-check.ps1
```
