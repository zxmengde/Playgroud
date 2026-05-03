# Capabilities

## 本地能力清单

| 外部来源 | 本地能力 | 入口 | 状态 |
| --- | --- | --- | --- |
| obsidian-skills | knowledge promotion workflow | `scripts/codex.ps1 knowledge promote|promotions` | active |
| vibe-kanban local mechanism | local task board / attempt / recover | `scripts/codex.ps1 task ...`；skill: `workspace-state-workflow` | active |
| Auto-claude-code-research-in-sleep local mechanism | research queue / review gate / run log | `scripts/codex.ps1 research ...`；skill: `workspace-state-workflow` | active |
| vibe-kanban | 原版 Web kanban 服务 | `scripts/codex.ps1 vibe start|status|stop`；skill: `vibe-kanban-service` | active |
| Auto-claude-code-research-in-sleep | 原版 ARIS watchdog 后台进程 | `scripts/codex.ps1 aris install|watchdog ...`；skill: `aris-watchdog-service` | active |
| context-mode | 大输出上下文处理与子命令适配 | skills: `context-mode-context-mode`, `context-mode-command-adapters` | active |
| UI/UX visual loop | verdict 输出与参考驱动迭代 | skills: `omx-visual-verdict`, `omx-visual-ralph` | active |
| 外部 skills 集合 | 项目级 Codex skills，按任务触发并完成 fit map 复判 | `.codex/skills/`，见 `docs/external-skills.md` | fit_mapped |

## 使用原则

- Obsidian：默认只写仓库内 `docs/knowledge/promotion-ledger.md`。外部 vault 写入必须另行确认。
- Vibe Kanban：需要 UI、工作区、agent session 管理时启动原版服务，不用 Markdown task board 伪装。
- ARIS：需要睡眠期间持续监控实验或下载任务时启动原版 watchdog；完整训练监控依赖 Linux/远程 `tmux` 或 `screen`。
- Skills：外部 skills 已迁移为项目级安装，但不应一次性读取。Codex 应根据任务描述、skill 描述和当前产物需要按需加载。

## 回滚

仓库文件未提交时直接恢复；已提交时使用 `git revert <commit>`。运行态用 `scripts/codex.ps1 vibe stop`、`scripts/codex.ps1 aris watchdog stop` 停止，再删除 `.runtime/`。项目级 skills 回滚见 `docs/external-skills.md`，全局备份在 `C:\Users\mengde\.codex\skills.disabled\2026-05-04-project-level-migration`。
