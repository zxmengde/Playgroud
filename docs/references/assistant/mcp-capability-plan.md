# MCP 能力方案

本文件记录当前 MCP 与外部知识工具的最终处理状态：已启用、仍候选、拒绝。

## 已启用

- `sequentialThinking`：required
- `serena`：required
- GitHub：已可用于 issue、PR、repo metadata 和 review
- Browser Use：已可用于网页调研和 UI 验证

## 已启用 MCP

### sequentialThinking

- 状态：enabled
- 目标：复杂任务拆解、分支检查和中间判断记录
- 权限边界：不读取或写入文件，不替代事实核验
- 验证：`scripts/audit-mcp-config.ps1`
- 回退：删除用户级 Codex 配置中的 `[mcp_servers.sequentialThinking]` 后重启 Codex；回退后使用 `docs/tasks/active.md` 和普通任务计划

### Serena

- 状态：enabled
- 目标：语义代码导航、引用查找、跨文件重构
- 当前处理：已安装 `serena-agent`，并写入 `C:\Users\mengde\.codex\config.toml`
- 分阶段边界：
  - 阶段 1：优先使用符号导航、引用查找和上下文定位
  - 阶段 2：在真实代码任务中启用符号级编辑
- 验证：`scripts/audit-serena-obsidian-readiness.ps1`

## 已启用的非 MCP 外部能力

### Obsidian

- 状态：enabled
- 当前处理：使用官方 Obsidian CLI，经 `obsidian` 命令接入
- 当前能力：vault 列表、全文搜索、文件读取、文件创建、文件追加
- 验证：
  - 真实 vault 文件计数
  - 真实 vault 搜索
  - sandbox vault 中 `Codex/obsidian-cli-smoke.md` 的创建、读取与追加

## 当前 candidate

### remote / long-running

- 状态：interface-only candidate
- 当前处理：只保留来源记录、任务状态字段、停止条件和外部写入边界
- 前提：不保存凭据、不默认安装重 runtime

## 当前拒绝

- 通用 filesystem MCP
- 通用 git MCP
- 通用 memory MCP
- 邮件、日程、网盘、CRM、支付和金融类 MCP

理由：已有能力重复，且权限风险过高。
