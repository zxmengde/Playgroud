# 外部能力雷达

本文件只保留对当前系统仍有行动价值的外部能力结论，不把“可安装”当作“应安装”。

## 已直接纳入路由

- GitHub：用于 issue、PR、repo metadata 和外部项目 review
- Browser Use / web 体系：用于外部调研、网页验证和 UI 证据
- Documents / Presentations / Spreadsheets：用于 Office 相关任务

## 已落地为本地机制

- 来自 `everything-claude-code` 的 verification-first 心态
- 来自 `Trellis` 的 SessionStart 恢复摘要
- 来自 `claude-scholar` 的知识与研究分层
- 来自 `claude-skills self-improving-agent` 的 failure -> lesson -> mechanism 思路
- 来自 `ui-ux-pro-max-skill` 的 checklist 思路
- 来自 `context-mode` 的上下文预算和按需检索思路，落到 active load 行数/字节预算
- 来自 `ARIS / Auto-claude-code-research-in-sleep` 与 `AI-Research-SKILLs` 的研究状态、实验计划和跨审查思路，落到 research memo 与外部机制 eval

## 当前已接通

- Serena：语义代码导航、引用查找、跨文件重构。已安装并写入用户级 Codex MCP 配置。
- Obsidian：已通过官方 CLI 接入，支持真实 vault 搜索、读取和写入。

## 当前仍未接通的重能力

- remote / long-running：当前只保留接口规范、来源记录和权限边界。

## 当前拒绝完整安装

- `context-mode`
- `vibe-kanban`
- `claudecodeui`
- `cc-connect`
- `AI-Research-SKILLs` 全量
- `Auto-claude-code-research-in-sleep` 全量
- `oh-my-codex` 全量
- `Trellis` 全量
- `claude-scholar` 全量
- `obsidian-skills` 全量

拒绝理由一致：runtime 维护面、外部暴露面和默认复杂度高于当前收益。

## 2026-05-02 复查结论

本轮按源码和目录结构复查了 10 个指定仓库。可迁移机制只进入轻量实现，不复制外部项目结构：

- 采用：active load 预算、摘要式 task archive、外部机制源码证据 eval、UI/UX 证据项、产品工程 success / rollback / stop condition。
- 延后：kanban runtime、remote workspace、长期无人研究循环、Obsidian canvas/base 自动生成、通用 context sandbox MCP。
- 拒绝：全量安装大型技能包、全量多 agent runtime、外部通知桥、默认远程执行队列。
