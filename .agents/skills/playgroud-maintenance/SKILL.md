---
name: playgroud-maintenance
description: "Use inside D:\\Code\\Playgroud for maintaining the controlled personal work system: route tasks through routing-v1, update failure and lesson objects, validate hooks and active load, prune obsolete files, and keep changes evidence-backed."
---

# Playgroud Maintenance

## Trigger

用于 `D:\Code\Playgroud` 内的系统维护、自我改进、hooks、validators、evals、skills、MCP 治理、active load 和知识整理任务。

## When Not To Use

不用于普通业务代码实现、不涉及本仓库控制系统的外部项目交付，以及与本仓库无关的随手查询。

## Read

Required files:

- `AGENTS.md`
- `docs/core/index.md`
- `docs/profile/user-model.md`
- `docs/profile/preference-map.md`
- `docs/tasks/active.md`
- `docs/knowledge/system-improvement/routing-v1.yaml`
- `docs/knowledge/system-improvement/harness-log.md`

按任务需要再读：

- `docs/workflows/self-improvement.md`
- `docs/workflows/product.md`
- `docs/workflows/uiux.md`
- `docs/workflows/knowledge.md`

## Inputs

- 当前任务目标
- 当前 diff、验证输出和 task state
- failure、lesson、routing、hook、validator 现状
- 用户级 Codex 配置状态

## Output

- 系统补丁
- 对象文件更新
- validators 或 hook 结果
- 人类可读复盘记录
- 明确 blocker

## Allowed Writes

- `D:\Code\Playgroud` 内的规则、skills、脚本、知识条目和任务状态
- `docs/knowledge/system-improvement/failures/` 与 `lessons/`
- `docs/knowledge/system-improvement/harness-log.md`

## Forbidden Writes

- 不得直接保存密钥、令牌或敏感配置
- 不得在没有明确范围时覆盖用户级 `config.toml`
- 不得在没有任务级授权时执行外部账号写入
- 不得把第三方输出直接覆盖核心规则

## Evidence Requirements

- 每项判断至少附文件、命令、validator、引用关系或运行结果之一
- 清理旧复杂度前要说明替代路径和回滚方式
- 涉及 MCP 或外部机制时要说明来源、风险和停用路径

## Workflow

1. 先读核心入口、routing、当前任务和系统复盘。
2. 判断目标属于对象系统、skill、hook、validator、workflow、MCP 还是知识层。
3. 先改最小可验证机制，再改说明文档。
4. 更新任务状态和 harness 摘要。
5. 运行 validators、evals 和 finish readiness。

## Verify

- `scripts/codex.ps1 validate`
- `scripts/codex.ps1 eval`
- `scripts/lib/commands/check-finish-readiness.ps1 -Strict`

## Pass Criteria

- 形成可回滚补丁
- validators 和 evals 达到可接受状态
- active load、failure、lesson、routing 至少有一项真实更新

## Fail Criteria

- 只有计划没有落地产物
- 跳过关键校验
- 用冗长规则文本替代可执行机制
- 越过权限边界写入外部账号或敏感配置

## Example Invocation

- `Use $playgroud-maintenance to land and validate a self-improvement change in D:\Code\Playgroud.`

## Failure Modes

- 只做文档整理，不做机制落地
- 修复单点问题却不更新 routing、failure 或 lesson
- validators 没接入主校验链
- 历史设计稿继续污染 active load
