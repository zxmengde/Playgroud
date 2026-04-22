# 工具登记表

| 工具 | 可执行任务 | 输入输出 | 风险边界 | 验证方式 | 替代路径 |
| --- | --- | --- | --- | --- | --- |
| PowerShell | 文件检查、命令执行、系统信息、脚本运行 | 命令输入，文本输出 | 删除、覆盖、大规模移动需确认 | 退出码、输出、文件存在性 | Python 脚本 |
| Git | 版本管理、差异检查、提交 | 工作区文件，提交记录 | 不回退用户改动；破坏性操作需确认 | `git status`、`git diff`、提交日志 | 文件备份 |
| Python | 数据处理、文档解析、测试脚本 | 脚本、CSV、JSON、Office、PDF | 不保存密钥，不向外部写入 | 退出码、输出文件、单元检查 | PowerShell 或 Node |
| Node | 前端、Playwright、脚本工具 | JS/TS 项目、网页测试 | 不执行未知安装脚本 | 退出码、测试输出 | Python 或内置运行时 |
| Pandoc | Markdown、DOCX、HTML 等格式转换 | 文档文件 | 覆盖输出需确认 | 输出文件、格式检查 | Python 文档库 |
| Playwright | 网页访问、截图、资料提取、UI 检查 | URL、脚本 | 登录、提交和外部写入需确认 | 截图、DOM 文本、控制台日志 | 浏览器手动检查 |
| Office 文件工具 | Word、PPT、Excel 创建与编辑 | DOCX、PPTX、XLSX | 覆盖源文件需确认 | 渲染、结构检查、打开性检查 | Pandoc 或 LibreOffice |
| PDF 工具 | 提取文本、生成 PDF、渲染页面 | PDF 文件 | 不修改原件，除非确认 | 渲染图、页数、文本抽取 | OCR 或浏览器预览 |
| Codex 技能 | 专项流程和工具使用规则 | 用户请求、文件路径 | 技能内容不得含敏感信息 | `quick_validate.py` | 项目级规则 |
| Automations | 周期性任务和线程跟进 | 提示和计划时间 | 长期运行需确认 | 自动化卡片、运行记录 | 手动任务记录 |
| MCP | 外部文档、服务和工具接入 | MCP 服务配置 | 账号授权和写入需确认 | MCP 资源/工具列表 | 网页检索或本地文档 |

## 已知问题

PowerShell 中 `codex` CLI 曾因 npm 包装脚本启动 Node 而触发 CSPRNG 断言失败。已将用户级 `codex.ps1` 和 `codex.cmd` 改为直接调用 npm 包内原生 Codex 二进制。验收结果：`codex --version` 与 `codex mcp --help` 均可运行。

已配置 MCP：

- `openaiDeveloperDocs`: `https://developers.openai.com/mcp`
- `context7`: `https://mcp.context7.com/mcp`

当前会话可能需要重启后才能直接枚举新 MCP 资源。
