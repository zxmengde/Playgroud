# 外部机制迁移记录

本文件只保留当前已经采用或明确延后的迁移结论。详细的逐项目适配矩阵、评分和验证方式见：

- `docs/knowledge/system-improvement/2026-04-27-codex-self-improvement-report.md`

## 已采用

- `everything-claude-code`：只迁移“先定义验证，再声明完成”的 eval / verification 心态，不迁移其全量技能包。
- `Trellis`：只迁移“会话启动时注入当前任务与恢复上下文”的最小 SessionStart 机制，不迁移 `.trellis/` 目录体系。
- `claude-scholar`：只迁移“入口压缩、知识库按需绑定、研究与知识工作分层”的思路，不迁移整套研究工作台。

## 已延后

- `Serena`：保留为高优先 MCP 候选。价值明确，但当前控制仓库主要工作负载仍是文档、脚本和治理，不急于新增运行层。
- `obsidian-skills`：保留为 Obsidian 显式联动候选，默认不开。
- `ui-ux-pro-max-skill`：只吸收其检查清单思路；若真实前端任务频繁，再评估是否需要外部技能。

## 已拒绝

- `vibe-kanban`、`claudecodeui`、`cc-connect`：远程 UI、移动端和工作台能力与当前仓库目标不匹配。
- `context-mode`：上下文数据库、MCP 和多类 hooks 过重；只保留“think in code”原则。
- `AI-Research-SKILLs`、`Auto-claude-code-research-in-sleep`、`oh-my-codex` 全量：自治 loop、海量技能和 runtime 维护面过大。
