# 受控自我改进验收

## 输入

- 用户要求一次严肃的自我进化式优化。
- 仓库事实基线、Hermes 与 OpenClaw 调研、现有脚本和自动化状态。

## 执行路径

读取入口、核心协议、用户画像、任务状态、scripts、skills、知识索引、能力文档和验证记录。运行现有校验后发现：已删除的 `docs/archive/assistant-v1-summary.md` 仍被结构校验、知识索引和验收记录引用；用户级自动化中存在一个每日运行的本地“自我优化”任务，直接复用一次性完整授权提示。

## 产物

- 新增 `docs/references/assistant/self-improvement-loop.md`。
- 新增 `scripts/audit-automations.ps1`。
- 增强 `scripts/new-system-improvement-proposal.ps1` 和 `scripts/audit-system-improvement-proposals.ps1`，要求系统改进候选带分类。
- 从校验、索引和验收记录中移除已删除历史摘要的强制引用。
- 删除用户级高风险自动化 `automation`，保留两个 worktree 边界的巡检自动化。

## 验证

- `scripts/audit-system-improvement-proposals.ps1` 检查 proposal 字段完整性和分类。
- `scripts/audit-automations.ps1` 检查长期自动化是否含一次性完整授权或在本地 checkout 中执行高风险任务。
- `scripts/audit-active-references.ps1` 检查当前执行路径中的本地引用。
- `scripts/validate-system.ps1` 集成结构、索引、技能、引用、提案和自动化审计。

## 复盘

本次改动说明，精简操作必须同时更新索引、脚本和验收记录；自动化不能继承一次性授权。后续同类改动应先运行引用审计和自动化审计，再声明能力提升。

## 边界

未安装 Hermes、OpenClaw 或新的常驻 agent。未启用通用 filesystem、memory、邮件、日程、网盘、支付或金融类 MCP。外部项目只迁移机制，不迁移运行主体。
