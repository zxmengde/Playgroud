# 能力清单与成熟度

本文件记录 Playgroud v2 要求 Codex 必须具备的能力、当前成熟度、代表性任务、验证方式和主要缺口。成熟度用于指导后续改进，不作为能力宣传。

## 成熟度定义

- 草稿：有规则或入口，但缺少真实任务验证。
- 可用：能指导任务，并有产物和验证方式。
- 稳定：经过多个真实任务验证，能减少重复说明和返工。
- 自动化候选：流程稳定、输入输出清楚、失败可发现，可考虑周期性运行。

## 能力表

| 能力 | 当前成熟度 | 代表性任务 | 验证方式 | 主要缺口 |
| --- | --- | --- | --- | --- |
| 真实需求判断 | 可用 | 将用户粗略目标转化为产物、验证和风险边界 | 任务状态、最终产物、复盘记录 | 缺少失败样例库 |
| 反迎合与伪需求识别 | 可用 | 指出不可靠前提并给出更合适路径 | 停止前检查、复盘记录 | 缺少可复用反例 |
| 科研文献与引用核验 | 可用 | 文献检索、综述、正式文本引用检查 | DOI、出版社页、PubMed、IEEE、ACM、标准页面 | 真实任务样例不足 |
| Zotero 与本地 PDF | 可用 | Zotero 导出、PDF 阅读、BibTeX/RIS 整理 | `scripts/audit-zotero-library.ps1`、导出文件、引用核验、`docs/validation/v2-acceptance/zotero-pdf.md` | 真实文献任务样例不足；常用集合、标签规则和 Web API 边界待确认 |
| 视频资料 | 可用 | Bilibili、课程、会议视频字幕摘要 | URL、元数据、字幕、时间戳抽查、`scripts/audit-video-skill-readiness.ps1`、`docs/validation/v2-acceptance/video-source.md` | `yt-dlp` 与 `faster-whisper` 已可用；仍未验证真实视频样例 |
| Office 文档 | 可用 | Word、PPT、Excel、PDF 可编辑产物 | 结构检查、渲染、截图、打开性检查 | 模板和审美偏好待采集 |
| 编码工作 | 可用 | 项目地图、补丁、测试、审查 | `git status`、测试、构建、静态检查 | 提交风格和测试偏好待采集 |
| 网页资料 | 可用 | 当前资料核对、网页摘录、截图 | URL、访问时间、交叉核对、截图 | 归档命名和截图偏好待采集 |
| 知识沉淀 | 可用 | 研究资料、项目背景、系统复盘写入知识库 | 索引校验、来源、状态字段 | 分区索引需真实使用检验 |
| Git 与环境诊断 | 可用 | GitHub 代理、Clash、Codex CLI、MCP 状态检查 | 诊断脚本、命令输出、阻塞记录 | 当前 GitHub 代理仍需外部修复 |
| Codex 自我设置 | 可用 | Git、环境脚本、MCP、插件和任务退出标准统一配置 | `docs/core/self-configuration.md`、`docs/references/assistant/codex-app-settings.md`、系统校验 | 长期本机设置需用户确认后执行 |
| GitHub、Codex 插件与 MCP 治理 | 草稿 | 评估外部仓库、插件、skills 和 MCP server 是否值得引入 | 外部能力雷达、权限审查、只读试用记录 | GitHub API 当前受代理影响；缺少真实 MCP 接入样例 |
| Skill 同步 | 可用 | 确保仓库技能同步副本与用户级 Codex 实际加载的 skills 一致 | `scripts/audit-skill-sync.ps1`、`scripts/sync-user-skills.ps1` | 只覆盖本仓库自有 skills，不处理第三方技能更新 |
| 安全审查 | 可用 | 低信任网页、MCP、第三方技能、隐藏字符检查 | 文本风险扫描、权限边界检查 | 语义级提示注入仍需人工判断 |
| 长任务恢复 | 可用 | 多来源调研、多文件重构、跨会话继续 | 结构化 active 状态、恢复入口、停止前检查 | 仍需更多跨会话样例 |
| 成本控制 | 可用 | 减少冗余输出和重复读取 | 最终回复、任务状态、产物路径 | 缺少可量化统计 |
| 活动引用完整性 | 可用 | 避免当前执行路径继续引用已删除或误写路径 | `scripts/audit-active-references.ps1`、停止前检查 | 不能替代历史材料人工判断 |
| 受控自我改进 | 可用 | 从失败和重复操作生成分类提案，经验证后再进入规则、skill、hook、config 或 eval | `scripts/audit-system-improvement-proposals.ps1`、`scripts/audit-automations.ps1`、`docs/validation/v2-acceptance/self-improvement-loop.md` | 仍需真实失败样例继续检验分类是否足够 |

## 关联文件

- `docs/capabilities/companion-roadmap.md`：小型综合个人工作代理能力路线。
- `docs/capabilities/pruning-review.md`：精简候选项和执行门槛。
- `docs/references/assistant/external-capability-radar.md`：Codex 插件、MCP、skills 和外部仓库候选。

## 后续要求

每个复杂任务结束前，检查是否有能力成熟度变化。只有经过真实任务验证并有产物、验证和复盘记录时，才能提升成熟度。
