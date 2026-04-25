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

`assistant-router`、`execution-governor`、`style-governor` 是横向控制技能，触发范围较宽但有必要；风险是过度触发和上下文负担，需要保持正文简洁。

`research-workflow`、`coding-workflow`、`office-workflow`、`web-workflow` 是主流程技能。它们能覆盖常见任务，但还需要真实任务样例来证明触发准确性和产物质量。

`literature-zotero-workflow` 与 `video-source-workflow` 解决了新增能力入口问题，但目前只完成流程层建设，尚未经过真实 Zotero 库和真实视频链接验证。

`personal-work-assistant` 是兼容性技能，后续应避免继续扩展；新能力应进入更窄的技能或工作流。

## 后续要求

每次新增或修改技能后，运行：

```powershell
.\scripts\validate-skills.ps1
.\scripts\audit-skills.ps1
```

若审计发现缺少产物、验证或确认边界，应优先补齐。若一个技能只增加提示长度而不能减少重复说明或提高验证质量，应简化或合并。

