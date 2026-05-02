# Skill Use Policy

仓库级 skill 默认不自动加载。它们只在 workflow/checklist 不足、任务要求对应产物、用户明确要求该领域，或 delivery contract 指出能力缺口时使用。

## 统一政策

default: do_not_load

load_only_when:

- 任务需要该 skill 的 output contract；
- workflow 或 checklist 不足以完成任务；
- 用户明确要求该领域；
- delivery contract 指出该能力缺口。

forbidden_when:

- 小型局部修改；
- skill 只增加解释，不增加产物；
- workflow 已覆盖；
- skill 会诱导运行无关脚本、MCP 或长示例。

max_read:

- 默认只读触发条件、输出契约和最短 checklist；
- 不读长示例、参考材料或外部仓库，除非任务需要。

modification_rule:

- skill 无法改变 Codex 行为时，应删除、合并、重写或降级；
- 外部机制能显著改善行为时，可修改现有 skill 或替换旧机制，但必须同步删除、合并或降级等量旧复杂度。

## 9 个仓库级 skill

| skill | 允许加载条件 | 禁止加载条件 | 输出契约 |
| --- | --- | --- | --- |
| playgroud-maintenance | 维护本仓库控制系统、validators、hooks、任务状态 | 普通业务代码小改 | 可验证补丁、任务状态、验证结果 |
| failure-promoter | 有重复失败、validator 失败或用户指出系统性失误 | 一次性网络或人为取消 | failure/lesson 处理结论 |
| external-mechanism-researcher | 需要把外部项目机制转成本地能力 | 只查一个命令或只做本地实现 | 机制证据、最小落点、验证和回滚 |
| research-engineering-loop | 研究问题、实验设计、证据缺口 | 单纯改代码或文案 | research memo、实验计划或证据缺口 |
| product-engineering-closer | 需求、实现、验证断裂 | 纯知识整理或单文件格式修复 | 目标、验收、验证、风险 |
| uiux-reviewer | UI 或交互改动需要视觉证据 | 纯后端或脚本任务 | 截图/交互证据、问题和风险 |
| knowledge-curator | 已验证信息要进入长期 knowledge 或 Obsidian | 临时调试或未验证网页摘录 | 知识条目或写入说明 |
| tool-router | 工具、skill、MCP 选择不清 | 路径明确的简单修改 | 最小工具组合和禁用项 |
| finish-verifier | 准备完成、提交或推送 | 尚无产物的早期探索 | 收尾判断、验证摘要、剩余风险 |
