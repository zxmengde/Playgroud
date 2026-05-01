---
name: tool-router
description: "Route a task in D:\\Code\\Playgroud to the minimum necessary skill and MCP set using routing-v1.yaml. Use when the phase, domain, validation path, or MCP choice is unclear or contested."
---

# Tool Router

## Trigger

- 需要根据任务阶段和领域选择 skill 或 MCP
- 需要解释为什么不用其他工具
- 需要在 self-improvement、research、product、coding、uiux、knowledge、remote 之间路由

## When Not To Use

- 已经有明确且低风险的单一路径
- 简单单文件修改，不存在工具选择歧义

## Read

Required files:

- `docs/knowledge/system-improvement/routing-v1.yaml`
- `docs/tasks/active.md`
- `docs/core/index.md`

按需再读相关 workflow、skill 和 MCP 参考。

## Inputs

- 当前任务目标
- 任务阶段
- 任务领域
- 已知约束
- 是否需要外部来源、UI 证据、语义代码工具或长期 knowledge

## Output

- 推荐 skill 组合
- 推荐 MCP 组合
- 禁用工具说明
- 最小上下文和验证方式

## Allowed Writes

- `docs/tasks/active.md` 中的执行路径说明
- 必要时更新 lesson 或 failure 证据

## Forbidden Writes

- 不得绕过 routing-v1.yaml 直接凭印象选工具
- 不得在没有结论前直接安装 candidate MCP
- 不得把 router 结果当成实施本身

## Evidence Requirements

- 路由必须对应具体 route id
- 必须说明为什么不用其他工具
- 必须指出 required_outputs 和 verification

## Workflow

1. 先判 phase。
2. 再判 domain。
3. 再判能力缺口：外部信息、语义代码、UI 证据、长期 memory、远程接口。
4. 选择最小必要 skill 和 MCP。
5. 记录 route id、禁用工具和验证方式。

## Verify

- `scripts/validate-routing-v1.ps1`
- `scripts/eval-routing-selection.ps1`

## Pass Criteria

- 能给出唯一或最小组合
- 能解释为什么不是别的 route
- 输出与 routing-v1 一致

## Fail Criteria

- route 选择与 phase/domain 不匹配
- 只给工具名不给理由
- 把 candidate MCP 当默认能力

## Example Invocation

- `Use $tool-router to choose the minimal skill and MCP set for a cross-file refactor that may need Serena.`

## Failure Modes

- 只按工具熟悉度选路由
- 忽略 forbidden_tools
- 忘记返回 required_outputs 和 verification
