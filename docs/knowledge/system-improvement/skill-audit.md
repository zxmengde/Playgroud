# 技能审计记录

本文件记录 Playgroud 当前的技能治理策略。重点不在“技能数量”，而在触发是否准确、是否减少重复说明、是否真正改善验证质量。

## 当前结构

- 仓库级只保留一个技能：`.agents/skills/playgroud-maintenance/SKILL.md`。它负责本仓库结构、hook、自动化、任务恢复和精简治理。
- 任务型能力主要放在用户级 `~/.codex/skills/`，例如 `coding-workflow`、`research-workflow`、`office-workflow`、`web-workflow`、`literature-zotero-workflow`、`video-source-workflow`。
- 本仓库不再维护用户级技能的同步副本，避免出现双份入口、误触发和版本漂移。

## 当前判断

- 仓库级技能已经足够小，但要靠 `scripts/audit-codex-capabilities.ps1` 和 `scripts/audit-skills.ps1` 持续观察用户级技能面是否膨胀。
- 高价值技能应满足三个条件：触发边界清楚、能产生产物、能给出验证方式。否则宁可把规则写进 workflow 或脚本。
- 技能格式和边界要求继续以 `docs/references/assistant/skill-quality-standard.md` 为准。
- `ui-ux-pro-max`、`AI-Research-SKILLs`、`claude-scholar` 这一类外部技能包，默认只提取方法，不整包安装进本仓库。

## 结论

- 继续保持“仓库级极小、用户级按需”的结构。
- 只有当某类失败在真实任务中反复出现，且现有 workflow 或脚本无法约束时，才考虑新增仓库级技能。
- 新增或修改技能后，必须运行：

```powershell
.\scripts\validate-skills.ps1
.\scripts\audit-skills.ps1
```

