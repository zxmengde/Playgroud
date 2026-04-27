# 外部能力雷达

本文件只保留当前仍有行动价值的外部能力短名单。详细证据、14 个项目的适配矩阵和最终取舍见：

- `docs/knowledge/system-improvement/2026-04-27-codex-self-improvement-report.md`

## 当前保留

| 类别 | 当前状态 | 说明 |
| --- | --- | --- |
| Browser Use / GitHub / Documents / Presentations / Spreadsheets | 已启用 | 已能覆盖网页检查、GitHub、Office 文档和表格任务，不需要额外同类 MCP。 |
| `sequentialThinking` | 已启用 | 当前唯一实际配置的 MCP，继续保留为复杂任务拆解工具。 |
| `coding-workflow` / `research-workflow` / `web-workflow` / `office-workflow` 等用户级技能 | 已启用 | 继续按需调用，不在仓库内维护同步副本。 |

## 下一阶段可评估

| 候选 | 解决的问题 | 当前判断 |
| --- | --- | --- |
| Serena | 符号级代码导航、跨文件重构、语义删除 | 高价值候选，但当前控制仓库以文档和脚本为主，先保留为“高优先评估”，不立即安装。 |
| Zotero 或文献库只读 MCP | 本地文献集合检索、引用核验 | 与用户需求强相关，但需先完成只读边界、目录和回退方式评估。 |
| Obsidian CLI / obsidian-skills | 受控写入 Obsidian 项目知识库 | 只在用户明确需要 vault 联动时启用，不作为控制仓库默认能力。 |

## 当前拒绝

| 候选 | 拒绝原因 |
| --- | --- |
| context-mode | 需要额外 MCP、hooks 和 SQLite/FTS 运行层，不符合当前“默认极小”原则。 |
| vibe-kanban / claudecodeui / cc-connect | 以远程 UI、移动端和工作台为中心，维护面和外部暴露面过大。 |
| AI-Research-SKILLs / Auto-claude-code-research-in-sleep / oh-my-codex 全量安装 | 技能包、长任务 loop 和 runtime 层过重，默认收益低于引入成本。 |
| 通用 filesystem / git / memory MCP | 与当前文件工具、Git 流程和本地知识结构重复，会扩大权限面。 |
