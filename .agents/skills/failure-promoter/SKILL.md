---
name: failure-promoter
description: "Upgrade a structured failure in D:\\Code\\Playgroud into a lesson candidate, review, and promotion target. Use for repeated mistakes, high-impact failures, validator failures, tool misselection, or self-improvement regressions."
---

# Failure Promoter

## Trigger

- 新增或更新 `FAIL-*.yaml`
- 同类失败重复出现
- validator 或 eval 失败后需要判断是否 promotion
- 用户指出系统性失误

## When Not To Use

- 一次性网络抖动
- 用户主动取消任务
- 不涉及系统行为的普通业务分歧

## Read

Required files:

- `docs/knowledge/system-improvement/failures/`
- `docs/knowledge/system-improvement/lessons/`
- `docs/tasks/active.md`
- `docs/knowledge/system-improvement/routing-v1.yaml`
- `docs/knowledge/system-improvement/harness-log.md`

## Inputs

- 一个或多个 failure 对象
- 当前任务状态
- 最近相关 lesson
- 验证输出或用户反馈

## Output

- lesson candidate 或 promotion review
- reject 或 suppress 理由
- target 选择依据
- verifier 清单

## Allowed Writes

- `docs/knowledge/system-improvement/failures/*.yaml`
- `docs/knowledge/system-improvement/lessons/*.yaml`
- `docs/knowledge/system-improvement/harness-log.md`

## Forbidden Writes

- 不得直接修改 `AGENTS.md`
- 不得直接改 `docs/core/index.md`
- 不得直接写入 `docs/profile/*`
- 不得直接安装 MCP 或外部 skill

## Evidence Requirements

- 至少一个结构化 failure
- `why_not_one_off` 必须可复述
- target 必须附最小验证方法和回滚路径

## Workflow

1. 检查 failure 是否满足去重和聚合条件。
2. 判断是一次性错误还是系统性错误。
3. 若是系统性错误，生成或更新 lesson。
4. 在 `memory / skill / hook / eval / workflow / MCP` 中选 target。
5. 写出 review、verification plan 和 rollback plan。

## Verify

- `scripts/validate-failure-log.ps1`
- `scripts/validate-lessons.ps1`
- `scripts/eval-lesson-promotion.ps1`

## Pass Criteria

- 产生合法 lesson 或合法 reject/suppress 结论
- 解释了为什么不是其他 target
- 没有越权修改长期偏好或核心规则

## Fail Criteria

- 证据不足却 promotion
- 无 verifier 却接受 lesson
- 一次性错误被写成永久规则

## Example Invocation

- `Use $failure-promoter to triage FAIL-20260427-213000-b77d42 and decide whether it should become a lesson.`

## Failure Modes

- 把任务内容错误误判成系统错误
- target 过宽导致过约束
- 忽略已有 lesson，产生重复规则
