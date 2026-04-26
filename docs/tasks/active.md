# 当前任务

## 当前目标

按用户继续要求，对 Playgroud 控制仓库做进一步精简，检查已安装插件和 MCP 的本地可见状态，并给出下一阶段 MCP 安装建议。用户已在 Codex App 中完成 Git、环境、插件和 MCP 设置。

## 已读来源

- `AGENTS.md`
- `docs/core/companion-target.md`
- `docs/core/self-configuration.md`
- `docs/core/permission-boundary.md`
- `docs/profile/user-model.md`
- `docs/tasks/active.md`
- `docs/capabilities/pruning-review.md`
- `docs/references/assistant/codex-app-settings.md`
- `docs/references/assistant/external-capability-radar.md`
- 当前截图显示已启用 11 个插件、2 个 MCP、106 个技能。

## 已执行命令

- `git status --short --branch`
- `.\scripts\git-safe.ps1 pull --ff-only`
- `rg --files .codex`
- `Get-ChildItem` 检查本地插件缓存和用户级 skills。
- `mcp__context7__.resolve_library_id` 验证 Context7 可用。
- `tool_search` 检查当前会话是否暴露 OpenAI Developer Docs 同名工具。

## 产物

- 更新 `.gitignore`，忽略 `.codex/` 自动生成目录。
- 新增 `scripts/audit-codex-capabilities.ps1`
- 新增 `docs/references/assistant/plugin-mcp-availability.md`
- 更新 `docs/references/assistant/codex-app-settings.md`
- 更新 `docs/references/assistant/external-capability-radar.md`
- 更新 `docs/capabilities/pruning-review.md`
- 更新 `scripts/validate-system.ps1`
- 删除本地空目录 `docs/archive/assistant-v1/`

## 未验证判断

- 已安装插件的本地缓存可见，但新增插件是否在已经打开的会话中完整暴露，需要新会话或重启后再验证。
- `openaiDeveloperDocs` 在界面中显示开启，但当前会话未发现可直接调用的同名工具命名空间。
- 插件清单基于本地缓存、当前截图和当前会话工具暴露，未逐个验证外部账号权限。

## 阻塞

- 删除仍被验收记录引用的 `output/` 样例会降低证据可追溯性，本轮保留。
- 外部账号类插件和 MCP 的权限无法仅凭本地缓存确认，需要具体任务和授权边界。

## 下一步

运行系统校验、能力审计、Git 包装脚本验证和停止前检查；若通过，提交并推送本轮精简与插件/MCP 文档更新。

## 恢复入口

从 `D:\Code\Playgroud` 恢复，先运行：

```powershell
git status --short --branch
.\scripts\audit-codex-capabilities.ps1
.\scripts\validate-system.ps1
.\scripts\check-finish-readiness.ps1
```

继续阅读 `docs/references/assistant/plugin-mcp-availability.md`、`docs/references/assistant/codex-app-settings.md` 和 `docs/capabilities/pruning-review.md`。

## 反迎合审查

- 是否只完成字面要求：没有。本轮不只回答插件建议，还新增能力审计脚本、忽略自动生成目录，并更新恢复入口。
- 是否检查真实目标：真实目标是让仓库更清楚、更少重复、更容易判断插件和 MCP 能否使用，而不是把所有可见插件和 MCP 都打开。
- 是否把用户粗略判断当作事实：没有。已区分界面开启、本地缓存存在、当前会话工具暴露和外部账号权限四种状态。
- 是否用流畅语言掩盖未验证结论：没有。`openaiDeveloperDocs` 当前会话未暴露同名工具，新增插件是否完整进入已打开会话仍需重启或新会话验证。
