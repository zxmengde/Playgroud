# MCP 能力补充方案

记录时间：2026-04-26。

本方案用于决定哪些 MCP 值得接入，以及如何接入。MCP 服务器可能读取本地文件、访问网络或连接外部账号，因此不能把“可安装”直接等同于“应启用”。

## 资料来源

- Model Context Protocol 安全最佳实践：`https://modelcontextprotocol.io/specification/2025-06-18/basic/security_best_practices`
- Model Context Protocol 官方 servers 仓库：`https://github.com/modelcontextprotocol/servers`
- 当前本机 Codex 配置：`C:\Users\mengde\.codex\config.toml`

## 当前保留

| MCP | 用途 | 当前处理 |
| --- | --- | --- |
| `context7` | 第三方库和框架文档查询 | 保留，已验证可解析 React 文档库 |
| `openaiDeveloperDocs` | OpenAI 官方文档 | 保留；若当前会话未暴露工具，使用 `openai-docs` skill 和官方站点兜底 |
| `sequentialThinking` | 结构化拆解、复查和多步推理过程约束 | 已新增到用户级 Codex 配置；评估记录见 `docs/references/assistant/mcp-reviews/2026-04-26-sequentialThinking.md` |

## 优先补充

| 候选 | 价值 | 接入条件 |
| --- | --- | --- |
| Zotero 或文献库只读 MCP | 支撑论文、引用核验、本地 PDF 元数据和文献集合检索 | 明确 Zotero 数据目录；默认只读；不保存密钥；先用导出文件或只读目录验证 |
| 本地文档索引 MCP | 面向大量论文、笔记和 Office 文件的跨目录检索 | 只有在 `rg`、Office 插件、PDF 脚本不足时评估；必须限制目录 |
| 专项数据库 MCP | 连接稳定科研数据库或机构资料库 | 只在具体科研任务需要时启用；需记录来源、账号、速率限制和停用方法 |

## 暂不补充

| MCP | 原因 |
| --- | --- |
| Filesystem | 与当前仓库文件读写工具重复，会扩大文件访问范围 |
| Git | 与 Git、GitHub 插件和 `scripts\git-safe.ps1` 重复 |
| Memory | 与本仓库知识记录重复，容易产生多处记忆不一致 |
| 通用搜索 | 当前已有网页检索、Browser Use 和来源记录流程 |
| Sequential Thinking 以外的通用推理 MCP | 与现有模型推理和任务状态记录重复，除非能提供可验证状态机或日志 |
| 邮件、日程、网盘、CRM、支付或金融类 MCP | 外部账号和个人资料权限较高，必须等到具体任务再审查 |

## 接入流程

新增 MCP 前必须生成评估记录：

```powershell
.\scripts\new-mcp-adoption-review.ps1 -Name "zotero-readonly"
```

随后检查现有 MCP 配置：

```powershell
.\scripts\audit-mcp-config.ps1
```

运行时和 MCP 启动依赖检查：

```powershell
.\scripts\test-codex-runtime.ps1
.\scripts\check-agent-readiness.ps1
```

评估记录至少写清楚来源 URL、读取范围、写入能力、账号或密钥需求、失败方式、停用方法、只读验证命令和回退路径。需要修改用户级 Codex 配置、安装本地服务器或接入外部账号时，应先取得用户确认。

## 下一步候选

下一阶段优先做 Zotero 或文献库方案。用户已确认 Zotero 数据目录为 `C:\Users\mengde\Zotero`，并允许必要访问和操作。当前最小实现是先用 `scripts/audit-zotero-library.ps1` 做本地只读审计，再完成一个用户授权文献样例；若重复任务证明需要实时检索，再接入 Zotero MCP 或只读导出脚本。
