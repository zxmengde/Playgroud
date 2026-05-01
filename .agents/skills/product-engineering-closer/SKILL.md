---
name: product-engineering-closer
description: "Close the loop from goal to PRD, implementation, tests, review, and release risk inside D:\\Code\\Playgroud or a trusted code repo. Use when delivery needs product-engineering discipline instead of isolated coding."
---

# Product Engineering Closer

## Trigger

- 需求不清
- PRD、实现和验证断裂
- 需要交付风险、验收标准和收尾说明

## When Not To Use

- 纯知识整理
- 单文件格式修复
- 不需要交付闭环的临时查询

## Read

Required files:

- `docs/tasks/active.md`
- `docs/workflows/product.md`
- `docs/workflows/coding.md`
- `docs/knowledge/system-improvement/routing-v1.yaml`

按需读取相关代码、测试入口和需求材料。

## Inputs

- 目标
- 受众
- 约束
- 当前实现状态
- 验收标准

## Output

- PRD 摘要
- 实现计划
- 验证清单
- 交付风险说明

## Allowed Writes

- 任务状态、产品工作流记录、验证样例
- 与当前交付直接相关的代码或文档

## Forbidden Writes

- 不得跳过测试与 review 就宣称完成
- 不得把用户字面步骤当成真实目标上限
- 不得在没有权限的情况下发布或外部写入

## Evidence Requirements

- 成功标准必须明确
- 需求、实现、验证之间必须有路径
- 剩余风险要可审计

## Workflow

1. 明确真实目标和受众。
2. 写出最小 PRD 或交付摘要。
3. 对齐实现范围与验证方式。
4. 交付后写出风险、回滚和剩余事项。

## Verify

- `scripts/eval-product-engineering-closeout.ps1`
- 相关测试或静态检查
- `scripts/check-finish-readiness.ps1 -Strict`

## Pass Criteria

- 需求、实现、验证闭环
- 交付风险被记录
- 最终收尾与任务状态一致

## Fail Criteria

- 只有实现没有目标或验收
- 只有 PRD 没有执行和验证
- 未经授权直接发布或外部写入

## Example Invocation

- `Use $product-engineering-closer to turn a feature request into an implementation plan, verification checklist, and release risk note.`

## Failure Modes

- 把技术实现当成产品目标
- 忽略失败路径和回滚
- 验证只停留在口头层
