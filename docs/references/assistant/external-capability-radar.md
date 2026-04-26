# 外部能力雷达

本文件记录与 Playgroud 个人工作代理相关的外部能力候选。它用于判断哪些能力值得引入、试用或迁移为本地脚本和 skill，不用于证明任何外部项目适合直接安装。

## 资料边界

记录时间：2026-04-26。

本地 PowerShell 访问 GitHub API 时受到 `127.0.0.1:7897` 代理问题影响，未能可靠获取实时 star、release 或 issue 数据。因此，本文件不记录实时热度数字。仓库按相关性、公开可见度和可迁移价值列入候选；安装或启用前仍需重新核验维护状态、许可证、权限需求和安全风险。

## 官方资料结论

| 来源 | 结论 | 对本仓库的影响 |
| --- | --- | --- |
| https://developers.openai.com/codex/learn/best-practices | Codex 应以 `AGENTS.md`、MCP、skills、automations 和验证流程逐步配置；不要一开始接入所有工具 | 保持入口短，重复流程先 skill 化，稳定后再自动化 |
| https://developers.openai.com/codex/concepts/customization#skills | skill 使用渐进披露：先看元数据，需要时再读 `SKILL.md`、references 和 scripts | 本仓库 skills 应小而聚焦，把细节放到 references 和 scripts |
| https://developers.openai.com/codex/plugins/build#plugin-structure | Codex plugin 可包含 `.codex-plugin/plugin.json`、`skills/`、`.mcp.json`、`.app.json` 和 assets | 外部能力可先以 skill 试用，再在需要分发时封装为 plugin |
| https://modelcontextprotocol.io/specification/latest | MCP 以 consent、data privacy 和 tool safety 为核心原则 | MCP 接入必须显示权限、限制工具、记录用途，并保留人工确认边界 |

## 已启用 Codex 插件

| 插件 | 来源 | 本地作用 | 使用原则 |
| --- | --- | --- | --- |
| Browser Use | OpenAI bundled | 检查本地浏览器、localhost、file 页面和交互流程 | 前端或网页交互任务优先使用 |
| LaTeX Tectonic | OpenAI bundled | LaTeX 编译 | 论文、公式和 TeX 项目需要时使用 |
| GitHub | OpenAI curated | PR、issue、CI 和发布前工作 | 外部写入前确认；网络失败时先诊断 |
| Superpowers | OpenAI curated third-party bundle | 规划、调试、TDD、审查和分支收尾方法 | 用于复杂编码流程，不覆盖本仓库规则 |
| Build Web Apps | OpenAI curated | 前端应用、React、Supabase、Stripe 和组件实践 | 前端项目需要时使用；普通仓库维护不常用 |
| Test Android Apps | OpenAI curated | Android 模拟器 QA 和性能证据 | 当前不作为默认启用；Android 任务再打开 |
| Life Science Research | OpenAI curated | NCBI、UniProt、ChEMBL、ClinVar 等生命科学资料技能 | 科研检索任务优先试用，保留来源边界 |
| Plugin Eval | OpenAI curated | 评估插件、skills 和本地指标包 | 用于第三方能力引入前审查 |
| Documents | OpenAI primary runtime | DOCX 创建、编辑、渲染和导出 | 文档任务优先使用 |
| Presentations | OpenAI primary runtime | PPTX 创建、编辑、渲染和导出 | 演示文稿任务优先使用 |
| Spreadsheets | OpenAI primary runtime | XLSX、CSV、TSV 创建、分析、渲染和导出 | 表格任务优先使用 |

## MCP 候选

| MCP | 当前判断 | 建议 |
| --- | --- | --- |
| Context7 | 已开启并已验证可解析文档库 | 保留 |
| OpenAI Developer Docs | 界面显示已开启；当前会话未暴露同名工具命名空间 | 保留；OpenAI 文档任务可由 `openai-docs` skill 兜底 |
| Zotero 或文献库只读 MCP | 与用户科研和引用核验需求相关 | 下一阶段优先评估，启用前确认数据目录和只读边界 |
| Filesystem MCP | 与当前文件工具重复 | 暂不安装 |
| Git MCP | 与 Git、GitHub 插件和 `git-safe` 重复 | 暂不安装 |
| Memory MCP | 与本仓库知识记录重复，且可能产生多处记忆不一致 | 暂不安装 |

## GitHub 候选仓库

| 仓库 | 可迁移价值 | 处理方式 |
| --- | --- | --- |
| https://github.com/openai/codex | Codex CLI、配置、MCP、skills 和 AGENTS 相关实践 | 作为官方实现参考，优先读取文档，不直接改本机配置 |
| https://github.com/openai/openai-agents-python | Agents SDK 的 agent、handoff、guardrail、session、tracing 思路 | 迁移为本仓库的任务链、权限检查和复盘结构 |
| https://github.com/openai/openai-agents-js | JavaScript agent 编排和工具调用样例 | 用于 Node 生态任务时参考 |
| https://github.com/openai/openai-cookbook | 官方样例、评估和 agent 实践 | 只在具体任务需要时读取对应样例 |
| https://github.com/modelcontextprotocol/modelcontextprotocol | MCP 规范和 schema | 作为 MCP 安全和能力边界来源 |
| https://github.com/modelcontextprotocol/servers | MCP server 候选集合 | 只挑选能减少真实重复工作的 server，先只读试用 |
| https://github.com/anthropics/skills | skill 结构和打包思路 | 参考目录组织，不直接混入规则 |
| https://github.com/punkpeye/awesome-mcp-servers | MCP server 索引 | 作为候选目录，不能替代安全审查 |
| https://github.com/aider-ai/aider | Git 绑定的代码修改代理 | 参考变更分组、diff 和测试循环 |
| https://github.com/continuedev/continue | IDE 内代码助手和上下文组织 | 参考项目级上下文和编辑体验 |
| https://github.com/cline/cline | IDE agent、工具调用和任务执行 | 参考权限提示和长任务状态 |
| https://github.com/RooCodeInc/Roo-Code | 多模式编码 agent | 参考角色拆分和模式边界 |
| https://github.com/browser-use/browser-use | 浏览器自动化 agent | 参考网页任务抽象；本地优先使用已启用 Browser Use |
| https://github.com/microsoft/playwright-mcp | Playwright MCP 浏览器控制 | 候选：需要稳定浏览器 MCP 时评估 |
| https://github.com/microsoft/markitdown | 文档转 Markdown | 候选：大量 Office/PDF 转文本时评估 |

## 引入标准

外部能力进入试用前，应回答六个问题：它解决哪个重复任务；是否已有本地插件或脚本可完成；需要哪些文件、网络或账号权限；失败时能否发现；如何记录来源和输出；如何停用或移除。

试用顺序为：阅读官方文档或 README，运行只读命令，记录权限和失败模式，形成本地脚本或 skill，完成真实任务验收，再考虑长期启用。

本仓库不进行批量安装。批量接入会增加权限面、上下文噪声和维护负担，且与官方建议的渐进式接入不一致。
