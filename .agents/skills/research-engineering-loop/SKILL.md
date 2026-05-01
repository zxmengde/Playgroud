---
name: research-engineering-loop
description: "Run a research engineering loop in D:\\Code\\Playgroud: define the question, separate facts from inferences, design experiments, explain results, and produce a source-backed research memo."
---

# Research Engineering Loop

## Trigger

- 需要形成 research memo
- 需要实验设计或结果解释
- 需要识别证据缺口
- 需要把研究方向沉淀为长期 knowledge

## When Not To Use

- 单纯代码改动
- 只做文案润色
- 只做外部机制评分

## Read

Required files:

- `docs/tasks/active.md`
- `docs/profile/user-model.md`
- `docs/profile/preference-map.md`
- `docs/workflows/research.md`
- `docs/workflows/knowledge.md`

按需读取相关 `docs/knowledge/items/*`、外部来源和实验产物。

## Inputs

- 研究问题
- 已有来源
- 当前结果或实验状态
- 输出要求

## Output

- research memo
- experiment plan
- evidence gap list
- knowledge 写入建议

## Allowed Writes

- 研究 memo、实验计划、知识条目草案
- 必要时补充 failure 证据

## Forbidden Writes

- 不得把未验证推断直接写成 verified conclusion
- 不得直接修改 `docs/profile/*`
- 不得直接开启长期自动运行服务

## Evidence Requirements

- 关键结论必须有来源
- 事实、推断、不确定性必须分离
- 若提出实验，必须写最小验证路径

## Workflow

1. 明确 question 与 output。
2. 分离 facts、inferences、uncertainty。
3. 找出 evidence gap。
4. 设计最小实验或验证路径。
5. 输出 memo，并标记哪些内容可进入长期 knowledge。

## Verify

- `scripts/eval-research-memo-quality.ps1`
- 来源可追溯性检查
- knowledge 写入层级检查

## Pass Criteria

- 产出可审查 memo
- 有明确验证路径
- 没有越权写长期偏好或核心规则

## Fail Criteria

- 没有来源却给出结论
- 没有实验计划只有抽象判断
- 临时探索内容直接写入长期 knowledge

## Example Invocation

- `Use $research-engineering-loop to evaluate a Serena pilot hypothesis and produce a research memo with an experiment plan.`

## Failure Modes

- 事实与推断混写
- 没有记录不确定性
- 研究 memo 不能支撑后续实验
