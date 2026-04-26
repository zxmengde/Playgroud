# 当前任务

## 当前目标

按用户继续要求，对 Playgroud 控制仓库继续做减法和加法：删除可验证的无用生成物与空目录，补充 MCP 能力引入流程、审计脚本和候选方案，并完成校验、提交和推送。

## 已读来源

- `AGENTS.md`
- `docs/profile/user-model.md`
- `docs/core/self-configuration.md`
- `docs/capabilities/pruning-review.md`
- `docs/references/assistant/plugin-mcp-availability.md`
- `docs/validation/v2-acceptance/*.md`
- `scripts/new-citation-checklist.ps1`
- `scripts/new-web-source-note.ps1`
- `scripts/check-ppt-text-extract.ps1`
- MCP 官方安全最佳实践和官方服务器资料。

## 已执行命令

- `git status --short --branch`
- `.\scripts\git-safe.ps1 pull --ff-only`
- `rg` 检查旧路径、`output/` 引用和相关脚本引用。
- `Get-ChildItem` 检查重复大小文件、空目录和大文件。
- `Select-String` 只读检查用户级 Codex 配置中的 MCP 服务器名称和 URL。

## 产物

- 删除版本化 `output/` 生成物。
- 删除本地空目录 `output/`、`output/doc/` 和多个空的 `skills/*/references/`。
- 更新 `.gitignore`，忽略 `output/`。
- 更新生成脚本，使默认输出目录不存在时自动创建。
- 更新 PPT 文本检查脚本，要求显式传入抽取结果路径。
- 更新验收记录，保留历史检查结论，不再依赖版本化样例文件。
- 新增 `templates/assistant/mcp-adoption-review.md`。
- 新增 `scripts/new-mcp-adoption-review.ps1`。
- 新增 `scripts/audit-mcp-config.ps1`。
- 新增 `docs/references/assistant/mcp-capability-plan.md`。
- 更新系统校验、文档结构校验、工具登记、MCP 可用性记录和精简审查。

## 未验证判断

- 本轮没有直接安装新的 MCP；MCP 能力补充为评估、审计和接入流程。
- Zotero 或文献库只读 MCP 仍需用户确认数据目录、读取边界和是否允许 Web API。
- 生成脚本会在后续真实任务中继续产生被忽略的 `output/` 文件，默认不进入仓库。

## 阻塞

- 直接接入 Zotero、本地文档索引或外部账号类 MCP 需要进一步确认权限范围。
- 外部 MCP 市场状态会变化，安装前仍需按模板重新核验来源和权限。

## 下一步

运行系统校验、MCP 配置审计、生成脚本最小验证、Git 网络验证和停止前检查；通过后提交并推送。

## 恢复入口

从 `D:\Code\Playgroud` 恢复，先运行：

```powershell
git status --short --branch
.\scripts\audit-mcp-config.ps1
.\scripts\validate-system.ps1
.\scripts\check-finish-readiness.ps1
```

继续阅读 `docs/references/assistant/mcp-capability-plan.md`、`docs/references/assistant/plugin-mcp-availability.md` 和 `docs/capabilities/pruning-review.md`。

## 反迎合审查

- 是否只完成字面要求：没有。本轮同时删除生成物、修正脚本输出路径、增加 MCP 评估模板和配置审计。
- 是否检查真实目标：真实目标是减少仓库噪声并让 MCP 接入可控，不是盲目安装更多服务器。
- 是否把用户粗略判断当作事实：没有。对“无用文件”采用引用检查和验证记录替代；仍被记录依赖的结论保留在验收文档中。
- 是否用流畅语言掩盖未验证结论：没有。本轮没有声称 Zotero MCP 已可用，只提供评估和接入路径。
