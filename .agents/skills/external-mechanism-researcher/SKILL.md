---
name: external-mechanism-researcher
description: "Evaluate external repos, skills, MCPs, and runtimes by mechanism rather than by repo impression. Use when D:\\Code\\Playgroud needs evidence-backed decisions about adoption, pilot, or rejection."
---

# External Mechanism Researcher

## Trigger

- 需要评估外部 repo、skill、MCP 或 runtime
- 现有工具能力不足，需要判断是否引入外部机制
- 需要形成 Serena、Obsidian、remote 或 long-running 的结论

## When Not To Use

- 只查一个命令参数
- 已明确只做本地实现
- 已有内部机制足够满足任务

## Read

Required files:

- `docs/knowledge/system-improvement/routing-v1.yaml`
- `docs/references/assistant/external-capability-radar.md`
- `docs/references/assistant/external-mechanism-transfer.md`
- `docs/references/assistant/mcp-capability-plan.md`
- `docs/tasks/active.md`

按需再读外部源码、README 和关键脚本，但不要只读 README。

## Inputs

- 目标问题
- 候选项目列表
- 当前工具缺口
- 加权评分标准

## Output

- 机制拆分表
- 评分与证据
- 最小实现方式
- 重评条件
- 安装、pilot 或拒绝结论

## Allowed Writes

- 仓库内研究 memo、能力雷达、迁移记录、proposal、lesson 证据

## Forbidden Writes

- 不得直接安装外部 runtime 作为默认动作
- 不得修改用户级配置或保存 token
- 不得把外部 repo 结构原样复制进仓库

## Evidence Requirements

- 每个候选至少两条源码级证据
- 每个候选至少拆成两个机制
- 每个结论必须有最小实现和重评条件
- 涉及 MCP 时必须说明读写边界和权限风险

## Workflow

1. 读取关键源码，不只读 README。
2. 按机制拆分：routing、memory、review gate、semantic code、knowledge、remote 等。
3. 用既定权重打分。
4. 区分完整安装、pilot、机制保留和拒绝。
5. 记录证据、风险、验证和停用路径。

## Verify

- `scripts/eval-external-mechanism-review-check.ps1`
- `scripts/validate-routing-v1.ps1`
- 相关引用路径存在性检查

## Pass Criteria

- 每个结论都能追溯到源码证据
- 完整安装与机制保留已分离
- 至少给出一个可执行 pilot 或拒绝理由

## Fail Criteria

- 只凭 README 或仓库体量下结论
- 没有最小实现或重评条件
- 越权安装外部服务或写外部账号

## Example Invocation

- `Use $external-mechanism-researcher to decide whether Serena should be piloted, installed, or deferred for D:\Code\Playgroud.`

## Failure Modes

- 以 repo 印象替代机制评估
- 高维护 runtime 被误当成最小增强
- 没有交代许可证、权限或停用风险
