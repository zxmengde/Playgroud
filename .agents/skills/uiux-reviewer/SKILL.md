---
name: uiux-reviewer
description: "Review UI and UX changes with checklist, visual evidence, desktop/mobile coverage, and interaction risks. Use when a task affects interface, layout, information hierarchy, or user flow."
---

# UIUX Reviewer

## Trigger

- 改动影响界面或交互
- 需要桌面与移动端检查
- 需要截图或浏览器证据支撑设计判断

## When Not To Use

- 纯后端改动
- 纯 PowerShell 脚本修复
- 没有界面产物的任务

## Read

Required files:

- `docs/workflows/uiux.md`
- `docs/tasks/active.md`
- `docs/knowledge/system-improvement/routing-v1.yaml`

按需读取页面、组件、截图和浏览器证据。

## Inputs

- 页面或组件
- 用户场景
- 设备范围
- 验收预期

## Output

- UI/UX checklist
- 发现的问题
- 截图或交互证据
- 风险说明

## Allowed Writes

- review note、validation sample、任务状态
- 与当前界面任务相关的改进建议

## Forbidden Writes

- 不得只看代码不看界面就下结论
- 不得把 lint 当作 UI 验证替代物
- 不得在没有证据时宣称移动端通过

## Evidence Requirements

- 至少一份可视或交互证据
- 桌面与移动端覆盖情况明确
- 主要 action、层次、状态必须检查
- 截图证据、responsive、accessibility、interaction states、empty/loading/error states、copywriting、visual hierarchy 和 user task path 都必须显式覆盖或说明不适用

## Workflow

1. 明确目标用户和关键场景。
2. 检查层次、主 action、状态、可访问性和响应式。
3. 记录截图或交互证据。
4. 输出问题、风险和建议。

## Verify

- `scripts/codex.ps1 uiux smoke`
- 浏览器截图或交互证据

## Pass Criteria

- checklist 完整
- 证据可追溯
- 风险和建议能服务实际修改

## Fail Criteria

- 没有证据就给 UI 结论
- 忽略移动端或关键状态
- 把审美偏好当成事实

## Example Invocation

- `Use $uiux-reviewer to review a settings page change with desktop and mobile evidence.`

## Failure Modes

- 只关注外观，忽略任务路径
- 忽略错误态和空态
- 缺少具体可执行修改建议
