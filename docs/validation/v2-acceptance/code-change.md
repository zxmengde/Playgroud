# 代码与脚本修改验收

## 输入

- 用户批准的 Playgroud v2 大改计划。
- 当前分支 `codex/playgroud-v2-rebuild`。
- 仓库内 `AGENTS.md`、`docs/`、`skills/`、`scripts/` 和 `templates/`。

## 执行路径

在已有脏工作区上新建重构分支，保留兼容入口，新增核心协议、能力清单、知识分区、验收记录和校验脚本。旧 `docs/assistant` 正文迁移到引用、归档、能力或系统改进区域，并在旧路径留下兼容入口。

## 产物

- `docs/core/`
- `docs/references/assistant/`
- `docs/capabilities/`
- `docs/validation/v2-acceptance/`
- `scripts/validate-doc-structure.ps1`
- `scripts/validate-acceptance-records.ps1`

## 验证

- `scripts/validate-doc-structure.ps1` 检查核心结构和兼容入口。
- `scripts/validate-acceptance-records.ps1` 检查六类验收记录。
- `scripts/validate-system.ps1` 集成上述检查。
- `scripts/check-finish-readiness.ps1` 在停止前统一运行。

## 复盘

本轮真正的代码能力验收不是单个脚本是否能运行，而是规则、状态、脚本和记录能否互相约束。上一轮过早停止说明停止前检查需要纳入“仍可安全继续的迁移和验收记录”判断。

## 边界

没有执行 `git pull`，因为工作区存在未提交改动。没有提交、推送或创建远程 PR。远程同步仍需按 Git 网络诊断结果处理。

