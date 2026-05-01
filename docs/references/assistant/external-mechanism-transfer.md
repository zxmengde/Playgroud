# 外部机制迁移记录

本文件只保留已经吸收进本仓库的机制，以及没有完整安装但保留的 candidate 机制。

## 已吸收

- `everything-claude-code`：完成前先验证，再声明完成
- `Trellis`：SessionStart 恢复摘要、workspace 恢复习惯
- `claude-scholar`：研究与知识分层、claim 与 citation 纪律
- `claude-skills / self-improving-agent`：failure -> lesson -> mechanism 升级链路
- `ui-ux-pro-max-skill`：UI/UX checklist 思路
- `ARIS / Auto-claude-code-research-in-sleep`：review gate 和 artifact-first 研究流程

## 仅保留机制，不完整安装

- Serena：只保留 semantic code pilot 与只读/编辑分阶段边界
- `context-mode`：只保留 context routing 与 think-in-code 原则
- `vibe-kanban`、`claudecodeui`、`cc-connect`：只保留 remote、workspace、PR review、来源记录和权限边界思路
- `obsidian-skills`：只保留 vault-first、adapter 和 CLI 接口思路

## 完整安装拒绝

- 不安装多 agent runtime
- 不安装移动端工作台
- 不安装通用 memory/filesystem/git MCP

理由是：这些 runtime 会增加权限面、维护面和默认上下文噪声，但当前真实任务还没有证明它们的净收益。
