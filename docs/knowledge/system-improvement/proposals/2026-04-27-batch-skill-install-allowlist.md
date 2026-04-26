# 系统改进候选：batch-skill-install-allowlist

- 日期：2026-04-27
- 状态：candidate
- 分类：skill

## 触发事实

用户明确表示常驻 agent、自动学习后写入长期规则和批量安装技能具有价值，要求把相关能力加入仓库。当前仓库已有技能审计和第三方技能评估流程，但缺少“批量安装也必须有 allowlist、来源审查和回退方式”的结构化入口。

## 候选改动

新增批量技能安装 allowlist 与批量审计脚本。脚本只安装 allowlist 中的技能，安装前检查来源、权限、脚本、外部 URL 和卸载方式；安装后运行 `validate-skills.ps1`、`audit-skills.ps1` 和相关专项审计。

## 权限级别

needs-confirmation。批量安装会改变用户级 Codex 能力面，可能引入外部脚本和网络访问。每个批次都应列出技能名称、来源 URL、安装路径、权限和回退方式。

## 证据

- `scripts/audit-skills.ps1` 和 `scripts/validate-skills.ps1` 已能检查仓库内 skills 结构。
- `docs/references/assistant/third-party-skill-evaluation.md` 已规定第三方技能审查原则。
- 用户在 2026-04-27 明确要求增加批量技能安装能力。

## 最小实现

先只实现 allowlist 文件和审计脚本，不直接从未知列表安装。第一批候选应来自官方或已审查来源，且每个技能必须能说明解决的问题和验证命令。

## 验证方式

对一个 2 到 3 个技能的小批次试运行：记录来源，安装后运行技能结构校验，并在真实任务中验证触发准确性。若无法说明收益或权限边界，不进入批次。

## 回退方式

删除用户级对应 skill 目录，或移动到 `.codex\skills-disabled`；更新 allowlist 状态为 rejected 或 disabled。

## 状态

needs-confirmation

