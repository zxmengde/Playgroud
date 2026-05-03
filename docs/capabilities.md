# Capabilities

## 本地能力清单

| 外部来源 | 本地能力 | 入口 | 状态 |
| --- | --- | --- | --- |
| obsidian-skills | knowledge promotion workflow | `scripts/codex.ps1 knowledge promote|promotions` | active |
| vibe-kanban | 原版 Web kanban 服务 | `scripts/codex.ps1 vibe start|status|stop` | active |
| Auto-claude-code-research-in-sleep | 原版 ARIS watchdog 后台进程 | `scripts/codex.ps1 aris install|watchdog ...` | active |

## 使用原则

- Obsidian：默认只写仓库内 `docs/knowledge/promotion-ledger.md`。外部 vault 写入必须另行确认。
- Vibe Kanban：需要 UI、工作区、agent session 管理时启动原版服务，不用 Markdown task board 伪装。
- ARIS：需要睡眠期间持续监控实验或下载任务时启动原版 watchdog；完整训练监控依赖 Linux/远程 `tmux` 或 `screen`。

## 回滚

仓库文件未提交时直接恢复；已提交时使用 `git revert <commit>`。运行态用 `scripts/codex.ps1 vibe stop`、`scripts/codex.ps1 aris watchdog stop` 停止，再删除 `.runtime/`。
