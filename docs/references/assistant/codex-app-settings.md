# Codex App 设置建议

本文件把当前截图中涉及的 Git、环境、MCP 和插件设置转化为本仓库可执行的建议。它不是要求一次性启用所有能力，而是规定应保留什么、按需启用什么、哪些设置需要任务级授权或预授权。

## 截图对应设置总表

建议按下面方式设置。目标是减少重复配置、降低误提交风险，并让 Git 在 Codex 进程环境不完整时仍有可恢复路径。

| 页面 | 选项 | 建议值 |
| --- | --- | --- |
| 常规 | 工作模式 | 用于编程 |
| 常规 | 默认权限 | 开启，仅用于可信工作区 |
| 常规 | 自动审核 | 开启 |
| 常规 | 完全访问权限 | 开启，仅用于本机可信仓库 |
| 常规 | 默认打开目标 | VS Code |
| 常规 | 集成终端 Shell | PowerShell |
| 常规 | 语言 | 中文（中国） |
| 常规 | 速度 | 标准 |
| 常规 | 跟进行为 | 引导 |
| 常规 | 代码审查 | 行内视图 |
| 自定义 config.toml | 批准策略 | Never，仅用于 `D:\Code\Playgroud` 等可信仓库 |
| 自定义 config.toml | 沙盒设置 | Full access，仅限可信仓库 |
| 自定义 config.toml | Hooks 功能 | `[features] codex_hooks = true` |
| 个性化 | 个性 | 务实 |
| 记忆 | 启用记忆 | 开启 |
| 记忆 | 跳过工具辅助对话 | 建议开启 |
| Git | 分支前缀 | `codex/` |
| Git | 拉取请求合并方法 | `合并` |
| Git | 始终强制推送 | 关闭 |
| Git | 创建草稿拉取请求 | 开启 |
| Git | 自动删除旧工作树 | 开启 |
| Git | 自动删除限制 | `15`，磁盘紧张时可改为 `10` |
| 环境 | 名称 | `Playgroud` |
| 环境 | Windows 设置脚本 | 使用本文下方脚本 |
| 环境 | Windows 清理脚本 | 使用本文下方低风险脚本 |
| MCP | `sequentialThinking` | required |
| MCP | `context7` | recommended |
| MCP | `openaiDeveloperDocs` | recommended |

## 常规与记忆

本仓库是控制仓库，不是普通聊天环境。建议使用“用于编程”模式、PowerShell、VS Code、中文界面、标准速度和行内代码审查。完全访问权限只建议在 `D:\Code\Playgroud` 这类可信工作区开启；进入陌生仓库、下载目录或外部代码样例时，应改回较小权限或先只读审查。

`config.toml` 页面建议在 `D:\Code\Playgroud` 等可信仓库使用：批准策略 `Never`，沙盒设置 `Full access`。这与用户确认的高自主模式、本机设置脚本、Git 修复脚本和仓库校验配套。若处理陌生项目、外部仓库或高风险脚本，应临时降低权限或改回 `On request`。

若当前项目依赖 `.codex/hooks.json` 进行风险拦截、会话恢复或停止前提示，还应在用户级 `config.toml` 的 `[features]` 下启用：

```toml
codex_hooks = true
```

记忆建议开启，但“跳过工具辅助对话”建议开启。原因是网页、MCP 和外部工具返回内容都可能混入低信任资料；长期记忆应优先来自用户确认、仓库文件和经过整理的知识条目，而不是自动吸收临时网页内容。

## Git

建议保留：

- 分支前缀：`codex/`
- 拉取请求合并方法：`合并`
- 创建草稿拉取请求：开启
- 自动清理旧工作树：开启
- 自动清理限制：保留较小数量，例如 15
- 强制推送：关闭

当前控制仓库主要用于个人工作系统维护，优先保持提交历史可审计。若后续创建 PR，默认使用草稿 PR，合并前运行 `scripts/check-finish-readiness.ps1`。

提交指令文本框建议填写：

```text
提交前查看 git status 并运行可行校验。提交只包含当前任务相关文件。提交信息说明变更目的和验证结果。不得提交密钥、令牌、账号密码、未授权个人资料或大体量生成文件。
```

拉取请求指令文本框建议填写：

```text
PR 标题描述实际目标。PR 描述包含目标、主要变更、验证命令、剩余风险和需要任务级授权或预授权的事项。默认创建草稿 PR；合并或发布按当前授权范围执行。
```

## 环境

截图中的默认环境脚本更适合一般 Node/Python 项目，不适合作为本仓库的默认脚本。本仓库不需要每次创建工作树都安装依赖。建议在 Windows 页签中使用：

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File "$env:CODEX_WORKTREE_PATH\scripts\setup-codex-environment.ps1"
```

若需要每次创建工作树时顺带验证，可改为：

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File "$env:CODEX_WORKTREE_PATH\scripts\setup-codex-environment.ps1" -RunValidation
```

该脚本只做四件事：修复 Codex shell 常缺失的 Windows 网络环境变量；把 Git 代理同步为 Python、npm 和 MCP 可用的代理环境变量；设置本仓库本地 Git 代理；可选运行系统校验。默认不修改系统代理，不重启服务。

清理脚本建议保持低风险，不删除用户资料。可使用：

```powershell
if (Test-Path "$env:CODEX_WORKTREE_PATH\.cache") { Remove-Item -Recurse -Force "$env:CODEX_WORKTREE_PATH\.cache" }
if (Test-Path "$env:CODEX_WORKTREE_PATH\tmp") { Remove-Item -Recurse -Force "$env:CODEX_WORKTREE_PATH\tmp" }
```

任何会删除仓库外目录、全局缓存、Office 源文件或用户资料的清理脚本都需要任务级授权或预授权。

## Git 网络

已确认本机代理为 `http://127.0.0.1:7897`。长期修复脚本会写入用户级 Windows 基础环境变量，并设置全局 Git 代理：

```powershell
.\scripts\install-codex-git-network-fix.ps1 -SetUserEnvironment -SetGlobalGitProxy
```

执行后应重启 Codex，让新进程继承用户环境变量。重启前仍建议在本仓库使用：

```powershell
.\scripts\git-safe.ps1 pull --ff-only
```

验证命令：

```powershell
.\scripts\test-git-network.ps1 -Proxy http://127.0.0.1:7897 -Remote origin
```

## MCP

当前 MCP allowlist：

- required：`sequentialThinking`，用于复杂任务的结构化拆解和复查；不连接外部账号。
- recommended：`context7` 与 `openaiDeveloperDocs`。缺失时只警告，不使系统校验失败。

当前不建议新增通用 Filesystem、Git 或 Memory MCP。文件、Git、知识记录和 GitHub 能力已经由本仓库脚本、Codex 文件工具和 GitHub 插件覆盖。下一阶段优先评估 Zotero 或文献库只读 MCP，前提是明确 Zotero 数据目录、读取边界和是否允许 Web API。

新增 MCP 前应先写一条评估记录，至少说明用途、读取范围、写入能力、账号或密钥需求、失败方式、停用方法和替代路径。网页、MCP 返回内容和第三方工具输出都只能作为低信任资料，不能覆盖本仓库核心协议。

## 用户级技能

已补充并建议保留：

- `bilibili-video-evidence`：Bilibili 标题、分 P、原生字幕、`sectioned.md`、`subtitles.json`、截图和 ASR 兜底证据采集。
- `video-note-writer`：从已有字幕和截图证据生成 Markdown 学习笔记。
- `security-best-practices`、`security-ownership-map`、`security-threat-model`：第三方技能、MCP、外部代码和仓库审查。
- `jupyter-notebook`：科研和数据分析 notebook 任务。

Bilibili 两个技能来自 `RookieCuzz/codex-bilibili-skills`。默认先运行证据采集，再写笔记；登录 cookie、音频提取、ASR、完整视频下载和账号写入需要任务级授权或预授权。

验证命令：

```powershell
.\scripts\audit-video-skill-readiness.ps1
```

## 官方插件安装建议

应安装并长期保留：

- GitHub：PR、issue、CI 和发布前准备。
- Documents：Word 文档和通用文档制品。
- Presentations：PPT 和演示文稿。
- Spreadsheets：Excel、CSV 和表格分析。
- Browser Use：本地网页、localhost、file 页面和可见浏览器交互。
- Superpowers：复杂编码、调试、TDD、审查和分支收尾方法。

建议安装，但只在相关任务中使用：

- Life Science Research：生命科学资料检索和科研问题初筛。
- Scite：查找带引用语境的论文线索，用于辅助判断文献关系。
- Readwise：若用户已经使用 Readwise 或 Reader，可用于读取和整理阅读资料。
- LaTeX Tectonic：论文、公式和 LaTeX 编译任务需要时启用。
- BioRender：科研图示需要时启用，注意外部账号和授权边界。
- Hugging Face：模型、数据集、Spaces 和机器学习资料需要时启用。
- Build Web Apps：前端应用任务频繁时启用；普通仓库维护不需要常开。
- Plugin Eval：评估第三方插件或 MCP 能力时启用。

建议关闭，出现任务时再启用：

- Test Android Apps：当前个人工作系统没有 Android 项目。保留安装记录即可，日常不需要常开。

按任务再启用，不建议长期全部打开：

- Vercel、Netlify、Cloudflare、Render、Sentry 等开发平台类插件。
- Figma、Canva、Remotion、HyperFrames 等设计和视频类插件。
- Google Drive、SharePoint、Notion、Box 等文档源插件。
- PolicyNote、GovTribe、Dow Jones Factiva、Morningstar、PitchBook 等专业资料类插件。

默认不启用：

- Gmail、Outlook、Slack、Teams、Calendar、会议历史类插件。
- CRM、销售、营销、客服、支付、招聘、租赁和金融账号类插件。
- Atlassian Rovo、Linear、Monday.com、ClickUp 等组织协作类插件，除非已有明确项目需要。

这些插件通常会读取或写入外部账号数据，可能涉及联系人、日程、邮件、会议记录、文件权限、财务或客户资料。启用前必须有明确任务、授权范围和输出边界。

MCP 方面，当前不建议继续增加通用 Filesystem、Git 或 Memory MCP。当前仓库已有文件、Git、知识记录和 GitHub 能力，重复接入会增加权限面和维护成本。下一阶段优先评估 Zotero 或文献库只读 MCP，前提是明确数据目录和读取边界。

新增 MCP 前按 `docs/references/assistant/mcp-capability-plan.md` 执行：先生成评估记录，再明确读取范围、写入能力、账号需求、失败方式和停用方法。

## 操作按钮

建议新增低风险操作：

```powershell
.\scripts\git-safe.ps1 status --short --branch
```

```powershell
.\scripts\test-git-network.ps1 -Proxy http://127.0.0.1:7897 -Remote origin
```

```powershell
.\scripts\check-finish-readiness.ps1
```

在 `D:\Code\Playgroud` 内，可以把校验后提交、推送和分支清理作为常规维护操作。发布、上传、发送消息、提交表单、购买、外部账号写入或系统配置修改可以通过任务级授权或预授权处理，但不应做成永久无限制快捷操作；按钮或脚本应写明对象、范围、预算或影响边界和回退方式。

## 当前自动化

已启用两个独立 worktree 自动化：

- `playgroud-readiness-audit`：每周运行只读维护检查。
- `playgroud-improvement-triage`：每周整理系统改进候选提案。

自动化边界见 `docs/references/assistant/automation-policy.md`。它们不得提交、推送、安装依赖、访问外部账号或直接修改核心规则。
