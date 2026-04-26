# 受控自我改进流程

本文件定义 Codex 在 Playgroud 中从失败、重复操作和复盘中提取经验的最小流程。目标是让改进可审计、可验证、可回退，而不是让一次性判断直接改写核心协议。

## 流程

任务执行后，若出现失败点、重复手工步骤、工具问题、误触发、验证不足或用户明确反馈，应按以下顺序处理：

1. 先修正当前任务，避免用记录替代实际完成。
2. 在 `docs/knowledge/system-improvement/harness-log.md` 记录可复核事实、原因、修正动作、验证方式和状态。
3. 将候选改动分类为 `memory`、`skill`、`config`、`hook`、`doc`、`eval` 或 `automation`。
4. 需要长期改变默认行为时，用 `scripts/new-system-improvement-proposal.ps1 -Name "<name>" -Category "<category>"` 生成候选提案。
5. 提案必须写清触发事实、证据、最小实现、验证方式和回退方式。
6. 运行 `scripts/audit-system-improvement-proposals.ps1`、相关专项脚本和停止前检查。
7. 由人工 review 后再合并到核心协议、技能、配置、hook、自动化或校验脚本。

## 可直接修复与必须提案

低风险、局部、可验证的问题可以直接修复，例如断链、过期索引、脚本语法错误和明显失效的校验项。修复后仍应运行相关验证。

以下事项必须先形成 proposal 或明确用户授权：核心协议改写、技能批量安装、MCP 新增、外部账号写入、长期自动化、删除大量文件、修改用户级配置、保存敏感信息。

## 自动化边界

自动化只能做只读巡检、生成候选提案或提醒人工确认。不得把一次性完整授权写入长期自动化，不得在本地 checkout 中无人值守执行删除、提交、推送、安装依赖、修改核心规则或外部账号写入。

`scripts/audit-automations.ps1` 用于发现这类风险。当前允许的长期自动化应优先使用独立 worktree，并在提示中明确禁止修改、提交、推送、安装和外部账号操作。

## 验证

本流程的最小验证集合：

```powershell
.\scripts\audit-system-improvement-proposals.ps1
.\scripts\audit-automations.ps1
.\scripts\audit-active-references.ps1
.\scripts\check-finish-readiness.ps1
```

若某项能力提升不能通过脚本、示例任务、diff、验收记录或运行结果提供支撑，不应标记为已完成。
