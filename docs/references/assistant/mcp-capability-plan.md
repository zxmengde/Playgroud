# MCP 能力方案

本文件记录当前 MCP 的最终处理状态：已启用、pilot、candidate 和拒绝。

## 已启用

- `sequentialThinking`：required
- GitHub：已可用于 issue、PR、repo metadata 和 review
- Browser Use：已可用于网页调研和 UI 验证

## 当前 pilot

### Serena

- 状态：pilot candidate
- 目标：语义代码导航、引用查找、跨文件重构
- 当前处理：写入 `routing-v1.yaml` 与 `eval-routing-selection.ps1`
- 分阶段边界：
  - 阶段 1：只读导航
  - 阶段 2：pilot 通过后再评估编辑能力
- 验证：在真实代码仓库里对比 `rg + read` 与 Serena 的步数、错误率和回滚次数

## 当前 candidate

### Obsidian

- 状态：knowledge-first candidate
- 当前处理：先写仓库内 knowledge，再保留 Obsidian adapter 规范
- 前提：vault 路径明确、写入范围明确、回退方式明确、human-confirmed

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
