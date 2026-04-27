# 技能审计记录

本文件记录仓库内 skills 的结构和成熟度审查。它不替代真实任务验证。

## 审查标准

每个技能至少应满足：

- 触发描述清楚，能区分适用场景和不适用场景。
- 正文说明需要读取的上下文或工作流。
- 说明产物是什么。
- 说明如何验证。
- 涉及账号、外部写入、删除、覆盖、下载或长期运行时说明确认边界。
- 无模板占位和无过度冗长正文。

## 当前判断

横向控制技能已重新评估。路由、执行到底和回答风格已由 `AGENTS.md`、`docs/core/index.md`、用户画像和全局会话规则承担，不再保留为单独 skill，以减少触发面和维护点。

`research-workflow`、`coding-workflow`、`office-workflow`、`web-workflow` 是主流程技能。它们能覆盖常见任务，但还需要真实任务样例来证明触发准确性和产物质量。

`literature-zotero-workflow` 与 `video-source-workflow` 解决了新增能力入口问题，但目前只完成流程层建设，尚未经过真实 Zotero 库和真实视频链接验证。

`personal-work-assistant` 已从仓库同步副本删除，用户级同名技能已移入 `.codex\skills-disabled`。本轮继续删除旧横向控制 skills，后续由项目入口和核心协议承担默认行为。

2026-04-26 新增用户级技能 `security-best-practices`、`security-ownership-map`、`security-threat-model` 与 `jupyter-notebook`。前三项用于 MCP、第三方 agent、插件和脚本接入前的安全审查；后一项用于科研和数据分析中的 notebook 处理。安装后需要重启 Codex 才能在新会话中自动进入可用技能列表。

## 后续要求

每次新增或修改技能后，运行：

```powershell
.\scripts\validate-skills.ps1
.\scripts\audit-skills.ps1
```

若审计发现缺少产物、验证或确认边界，应优先补齐。若一个技能只增加提示长度而不能减少重复说明或提高验证质量，应简化或合并。

