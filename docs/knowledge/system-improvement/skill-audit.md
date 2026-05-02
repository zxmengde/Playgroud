# 技能审计记录

本文件记录 Playgroud 当前的技能治理策略。重点不在“技能数量”，而在触发是否准确、是否减少重复说明、是否真正改善验证质量。

## 当前结构

- 仓库级技能共有 9 个：`playgroud-maintenance`、`failure-promoter`、`external-mechanism-researcher`、`research-engineering-loop`、`product-engineering-closer`、`uiux-reviewer`、`knowledge-curator`、`tool-router`、`finish-verifier`。
- 用户级任务型能力继续保留在 `C:\Users\mengde\.codex\skills\` 与插件缓存，例如 `coding-workflow`、`research-workflow`、`office-workflow`、`web-workflow`、`literature-zotero-workflow`、`video-source-workflow`。
- 本仓库不再维护用户级技能的同步副本，避免双份入口与版本漂移。

## 当前判断

- 仓库级技能已经从“极小但单一”调整为“核心有限但能力完整”。这些技能直接承载 failure、lesson、routing、research、product、UI/UX、knowledge 和 finish gate。
- 高价值技能必须同时满足：触发边界清楚、能产生产物、能给出验证方式、能说明写权限边界。
- 技能变更后必须运行：

```powershell
.\scripts\lib\commands\validate-skills.ps1
.\scripts\lib\commands\validate-skill-contracts.ps1
.\scripts\lib\commands\audit-skills.ps1
```

## 保留原则

- 继续保持“仓库级只保留系统性能力，用户级按需承担具体任务型能力”的结构。
- 只有当某类失败在真实任务中反复出现，且 workflow、validator 或现有 skill 无法覆盖时，才继续增加仓库级技能。
