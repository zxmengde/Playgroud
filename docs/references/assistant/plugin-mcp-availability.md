# 插件与 MCP 可用性检查

记录时间：2026-04-26。

本文件记录当前 Codex App 插件和 MCP 的本地可见状态。它只说明本机缓存、当前会话工具暴露和推荐使用方式；外部账号权限、远端服务状态和市场最新权限说明仍需在具体任务前核验。

## 当前插件状态

| 插件 | 本地缓存状态 | 当前判断 | 建议 |
| --- | --- | --- | --- |
| Documents | 已缓存，存在 `documents` 技能 | 可用 | 保留 |
| Spreadsheets | 已缓存，存在 `spreadsheets` 技能 | 可用 | 保留 |
| Presentations | 已缓存，存在 `presentations` 技能 | 可用 | 保留 |
| Browser Use | 已缓存，存在 `browser` 技能 | 可用 | 保留 |
| LaTeX Tectonic | 已缓存，存在 `latex-tectonic` 技能 | 可用性待真实 LaTeX 任务验证 | 保留 |
| Superpowers | 已缓存，存在多项流程技能 | 可用 | 保留 |
| GitHub | 已缓存，存在 PR、CI、发布相关技能 | 可用 | 保留 |
| Build Web Apps | 已缓存，存在 React、前端、Supabase、Stripe、shadcn 相关技能 | 可用性待前端任务验证 | 保留但按任务使用 |
| Test Android Apps | 已缓存，存在 Android QA 和性能技能 | 当前仓库无 Android 任务 | 已在用户级配置关闭，出现 Android 任务再启用 |
| Life Science Research | 已缓存，存在 NCBI、UniProt、ChEMBL、ClinVar、AlphaFold 等生命科学技能 | 可用性待真实检索任务验证 | 保留 |
| Plugin Eval | 已缓存，存在插件和 skill 评估技能 | 可用于评估第三方插件 | 保留 |

历史会话中曾验证 `context7` MCP 能解析 React 文档库。当前本机配置审计显示实际可见 MCP 只有 `sequentialThinking`。因此 `context7` 与 `openaiDeveloperDocs` 改为 recommended，缺失时只警告；OpenAI 文档任务仍应优先使用本地 `openai-docs` skill，必要时只检索 OpenAI 官方站点。

## MCP 安装建议

当前 allowlist：

- required：`sequentialThinking`，用于结构化拆解和复查复杂任务，不连接外部账号。
- recommended：`context7`、`openaiDeveloperDocs`，缺失不阻断系统校验。

下一阶段建议评估，但不建议直接批量启用：

- Zotero 或文献库 MCP：适合文献管理、引用核验和本地 PDF 元数据检索。Zotero 数据目录已确认为 `C:\Users\mengde\Zotero`；启用 MCP 前仍需明确是否使用 Web API、是否允许写入 Zotero 配置和如何回退。
- 本地检索 MCP：仅当需要跨目录检索大量个人文档且现有 shell、Office 插件和脚本不足时评估。
- 浏览器或 Playwright MCP：当前已有 Browser Use 和 Playwright 技能，除非需要跨会话稳定浏览器控制，否则不增加。

具体接入流程见 `docs/references/assistant/mcp-capability-plan.md`。新增 MCP 前先生成评估记录，不直接修改用户级 Codex 配置。

## 已补充的技能

2026-04-26 已从 OpenAI skills curated 列表安装：

- `security-best-practices`
- `security-ownership-map`
- `security-threat-model`
- `jupyter-notebook`

前三个技能补充第三方 MCP、agent、插件和脚本接入前的安全审查能力；`jupyter-notebook` 补充科研和数据分析中的 notebook 处理能力。未安装部署、Figma、Notion、语音、外部账号和平台发布类技能，因为当前任务没有对应账号和权限边界。

2026-04-26 已从本地审查过的 `RookieCuzz/codex-bilibili-skills` 副本安装：

- `bilibili-video-evidence`
- `video-note-writer`

这两个技能用于 Bilibili 视频证据采集和后续 Markdown 笔记生成。安装前已检查 `SKILL.md`、README、凭据处理说明和脚本，核心 Python 脚本已通过编译检查，安装后通过 Codex 技能结构校验。GitHub 下载脚本因本机 DNS 或网络栈错误未完成，因此使用已克隆并审查的本地副本安装。

验证命令：

```powershell
.\scripts\lib\commands\audit-video-skill-readiness.ps1
```

暂不建议安装：

- Filesystem MCP：当前已有仓库读写工具，额外接入会扩大文件访问面。
- Git MCP：当前已有 Git、GitHub 插件和 `scripts\git-safe.ps1`。
- Memory MCP：本仓库已经承担长期记忆和恢复记录，额外记忆库容易产生不一致。
- 通用搜索、邮件、日程、网盘、CRM、支付或金融类 MCP：只有在明确任务、授权范围和输出边界都清楚时再启用。

## 检查命令

```powershell
.\scripts\lib\commands\audit-codex-capabilities.ps1
```

```powershell
.\scripts\lib\commands\validate-system.ps1
```

```powershell
.\scripts\lib\commands\check-agent-readiness.ps1
```
