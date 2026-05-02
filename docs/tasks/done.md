# Archived Tasks

本文件只保留任务归档摘要，避免旧路径、旧目录和旧判断继续影响当前执行。详细历史以 Git 提交记录、`docs/knowledge/system-improvement/harness-log.md`、`docs/archive/assistant-v1-summary.md` 和代表性验收记录为准。

## Summary

- 2026-04-22 至 2026-04-23：建立控制仓库、用户画像、偏好采集、知识库、任务记录、早期技能组和校验脚本。
- 2026-04-25：补充反迎合、成本控制、Zotero、视频资料、Git 网络诊断和技能审计。
- 2026-04-26：完成 v2 重构，迁移旧 `docs/assistant` 正文，新增核心协议、能力记录、验收记录、MCP 治理和精简审计。
- 2026-04-27：创建受控自动化、Git pre-commit hook、Zotero 审计、视频技能就绪审计、文件使用审计和 MCP allowlist。
- 2026-04-28：落地 failure / lesson / routing 对象系统、仓库级 skills、validators、evals、hooks 和 finish gate。
- 2026-05-01：接通 Serena 用户级 MCP 与 Obsidian 官方 CLI，并留下 readiness 审计记录；2026-05-02 复查时修正用户级配置漂移。
- 2026-05-02：二次整改已由提交 `c552c2f` 推送到 `origin/main`，完成顶层脚本收敛、统一 `scripts/codex.ps1`、capability map、research state、run log 和 smoke workflow；旧 active task 已在 2026-05-03 归档。

新增归档应使用：

```powershell
.\scripts\lib\commands\archive-task-state.ps1 -Title "short task title"
```
