# 能力清单、路线与精简门槛

本文件记录 Playgroud 当前能力、成熟度、主要缺口和精简判断。它不是能力宣传，只作为后续改进、验证和删除决策的依据。

## 成熟度定义

- 草稿：有规则或入口，但缺少真实任务验证。
- 可用：能指导任务，并有产物和验证方式。
- 稳定：经过多个真实任务验证，能减少重复说明和返工。
- 自动化候选：流程稳定、输入输出清楚、失败可发现，可考虑周期性运行。

## 能力表

| 能力 | 当前成熟度 | 验证方式 | 主要缺口 |
| --- | --- | --- | --- |
| 真实需求判断 | 可用 | 任务状态、最终产物、复盘记录 | 缺少失败样例库 |
| 反迎合与伪需求识别 | 可用 | 停止前检查、复盘记录 | 缺少可复用反例 |
| 科研文献与引用核验 | 可用 | DOI、出版社页、PubMed、IEEE、ACM、标准页面 | 真实任务样例不足 |
| Zotero 与本地 PDF | 可用 | `scripts/audit-zotero-library.ps1`、导出文件、引用核验 | 常用集合、标签规则和 Web API 边界待确认 |
| 视频资料 | 可用 | URL、元数据、字幕、时间戳抽查、`scripts/audit-video-skill-readiness.ps1` | 仍未验证真实公开视频样例 |
| Office 文档 | 可用 | 结构检查、渲染、截图、打开性检查 | 模板和审美偏好待采集 |
| 编码工作 | 可用 | `git status`、测试、构建、静态检查 | 提交风格和测试偏好待采集 |
| 网页资料 | 可用 | URL、访问时间、交叉核对、截图 | 归档命名和截图偏好待采集 |
| 知识沉淀 | 可用 | 索引校验、来源、状态字段 | 分区索引需真实使用检验 |
| Git 与环境诊断 | 可用 | `scripts/git-safe.ps1`、`scripts/test-git-network.ps1` | 普通 Git 网络仍依赖进程环境修复 |
| Codex 自我设置 | 可用 | `docs/core/index.md`、`docs/references/assistant/codex-app-settings.md`、系统校验 | 用户级配置可能与文档漂移 |
| GitHub、插件与 MCP 治理 | 草稿 | 外部能力雷达、MCP allowlist、权限审查 | 缺少真实 MCP 接入样例 |
| 安全审查 | 可用 | 文本风险扫描、权限边界检查 | 语义级提示注入仍需人工判断 |
| 长任务恢复 | 可用 | `docs/tasks/active.md`、恢复入口、停止前检查 | 需要更多跨会话样例 |
| 成本控制 | 可用 | 最终回复、任务状态、产物路径 | 缺少可量化统计 |
| 活动引用完整性 | 可用 | `scripts/audit-active-references.ps1` | 不能替代历史材料人工判断 |
| Hook 与 eval | 草稿 | `.codex/hooks.json`、`scripts/eval-agent-system.ps1` | 需真实运行后复盘误报和漏报 |

## 近期路线

当前优先级按恢复成本和失败可见性排序：

1. 保持 `AGENTS.md`、`docs/core/index.md`、任务状态和知识索引一致。
2. 用 `scripts/eval-agent-system.ps1` 检查入口路径、MCP 配置漂移、hook、自动化和任务状态新鲜度。
3. 补齐真实样例：Zotero、视频、GitHub、浏览器、Office 和编码任务各保留至少一个可复核验收记录。
4. 只在重复任务证明必要时新增 MCP、外部技能或自动化。
5. 持续删除或合并无法证明各自必要的旧入口、备份副本和模板。

## 精简门槛

精简目标是降低上下文负担和维护点，同时保留验证能力。删除、合并或归档前应满足：

- 有替代路径。
- 相关校验脚本已更新。
- 当前引用不失效。
- 删除后能通过 `scripts/validate-system.ps1` 与 `scripts/check-finish-readiness.ps1`。

当前已确认的精简方向：

- `docs/core/` 只保留 `index.md`。
- `docs/capabilities/` 只保留本文件。
- 仓库级技能只保留 `.agents/skills/playgroud-maintenance/`。
- 用户级技能只通过 `scripts/audit-codex-capabilities.ps1` 和专项审计查看，不在本仓库同步同名副本。
- 0 引用且无生成脚本支撑的模板删除；由 `new-*` 脚本或工作流使用的模板保留。

## 外部机制取舍

Hermes、OpenClaw 和 everything-claude-code 的可迁移价值是机制，不是目录规模或全量配置：

- 迁移 doctor/eval 思路：用脚本检查真实配置漂移和失败信号。
- 迁移 skill 按需加载思路：仓库只保留一个维护技能，具体任务仍用用户级技能。
- 迁移 MCP 工具过滤思路：按 required、recommended、blocked 管理，不暴露通用高权限 MCP。
- 迁移 hook 思路：只做轻量风险拦截和停止前提示，不让 hook 代替判断。
- 迁移受控学习思路：失败经验先进入复盘或候选提案，再经验证进入规则。

不迁移：

- 常驻本机 agent 守护进程。
- 全量 hook、slash command、agent 模板包。
- 通用 filesystem、git、memory、邮件、日程、网盘、支付或金融类 MCP。
- 没有真实任务、权限边界和回退路径的外部技能。

## 后续要求

每个复杂任务结束前检查是否有能力成熟度变化。只有经过真实任务验证并有产物、验证和复盘记录时，才能提升成熟度。

低引用不是删除依据，只是审查入口。删除前以当前引用、用户级能力、脚本生成路径和验证结果共同判断。
