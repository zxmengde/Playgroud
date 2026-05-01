# Product Engineering Sample

## Goal

把系统改进任务从“修仓库卫生”提升为“落地 failure、lesson、routing、skill、validator 闭环”。

## Users

- 个人使用者
- Codex 自身

## Constraints

- 不保存凭据
- 需要可回滚
- 需要通过 validators 和 finish gate

## Success Criteria

- active task 可恢复当前目标。
- 实现改动至少有一个脚本或 eval 直接验证。
- 外部写入、依赖和回滚路径可审计。

## PRD Summary

- 需要结构化 failure 和 lesson
- 需要 skill 路由
- 需要 active load

## Implementation Plan

- 落地对象文件
- 落地 skills
- 落地 validators 和 hooks

## Verification

- `validate-system.ps1`
- `eval-agent-system.ps1`
- `check-finish-readiness.ps1 -Strict`

## Release Risk

- rule 过严可能导致误报
- Serena 已接通但编辑阶段仍需真实代码任务验证

## Rollback

- 使用 Git 回退仓库改动。
- 用户级配置改动使用备份文件恢复。

## Stop Condition

- `validate-system.ps1`、`eval-agent-system.ps1` 和 `check-finish-readiness.ps1 -Strict` 通过，或失败项已记录为 blocker。
