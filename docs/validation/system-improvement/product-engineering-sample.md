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
- candidate MCP 仍需真实任务验证
