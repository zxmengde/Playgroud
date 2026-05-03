# Capabilities

## 本地能力清单

| 外部来源 | 本地能力 | 入口 | 状态 |
| --- | --- | --- | --- |
| obsidian-skills | knowledge promotion workflow | `scripts/codex.ps1 knowledge promote|promotions` | active |
| vibe-kanban | task board / attempt / recover workflow | `scripts/codex.ps1 task board|attempt|recover` | active |
| Auto-claude-code-research-in-sleep | research queue / review gate | `scripts/codex.ps1 research queue|enqueue|review-gate|run-log` | active |

## 使用原则

- Obsidian：默认只写仓库内 `docs/knowledge/promotion-ledger.md`。外部 vault 写入必须另行确认。
- Task board：长期任务必须能从 `board.md` 和 `attempts.md` 恢复下一步。
- Research queue：只记录队列和 review gate，不声明后台无人值守能力。

## 回滚

所有记录都是 Markdown。未提交时直接恢复文件；已提交时使用 `git revert <commit>`。
