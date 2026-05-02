---
name: finish-verifier
description: "Verify whether a task in D:\\Code\\Playgroud is actually ready to close. Use before claiming completion, committing, or pushing, especially when validators, open failures, or task state may still block finish."
---

# Finish Verifier

## Trigger

- 准备宣称完成
- 准备提交或推送
- 需要检查未验证收尾、open failure、active lesson 和 task state

## When Not To Use

- 纯 brainstorming
- 尚未形成可交付产物
- 任务仍在早期探索阶段

## Read

Required files:

- `docs/tasks/active.md`
- `docs/knowledge/system-improvement/failures/`
- `docs/knowledge/system-improvement/lessons/`
- `docs/knowledge/system-improvement/routing-v1.yaml`
- `scripts/lib/commands/check-finish-readiness.ps1`

## Inputs

- 当前 diff
- 当前任务状态
- validators 和 eval 输出
- open failure 与 active lesson

## Output

- 收尾判断
- 需要补的验证
- 剩余风险
- 是否允许提交或推送

## Allowed Writes

- `docs/tasks/active.md`
- `docs/knowledge/system-improvement/harness-log.md`
- 必要时更新 failure 对象

## Forbidden Writes

- 不得跳过 validators 和 evals 就给“已完成”结论
- 不得忽略 open high-impact failure
- 不得在失败状态下伪装成完成

## Evidence Requirements

- 需要给出已运行验证命令
- 需要指出未验证部分
- 若允许收尾，需说明为什么当前风险可接受

## Workflow

1. 检查 git diff 和 task state。
2. 检查 open failure、active lesson 和 validators。
3. 检查是否存在未验证收尾。
4. 给出允许或阻止收尾的判断。

## Verify

- `scripts/lib/commands/check-finish-readiness.ps1 -Strict`
- `scripts/codex.ps1 validate`
- `scripts/codex.ps1 eval`

## Pass Criteria

- 收尾判断与实际验证状态一致
- 阻止条件明确
- 风险说明具体可审计

## Fail Criteria

- 只列举检查项，不做判断
- 忽略 open failure 或未验证部分
- 验证失败却仍建议提交

## Example Invocation

- `Use $finish-verifier before committing a final self-improvement system change.`

## Failure Modes

- 过度依赖单一脚本结果
- 没有把 task state 与 diff 对齐
- 把 warning 和 blocking fail 混在一起
