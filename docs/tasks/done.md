# 已完成任务摘要

本文件只保留恢复所需的里程碑，不再保存逐文件历史流水。旧路径、旧入口和已删除实验记录不作为当前事实来源；需要系统运行状态时，以 `docs/tasks/active.md`、`docs/knowledge/system-improvement/harness-log.md` 和验证脚本为准。

| 日期 | 里程碑 | 当前承载位置 | 验证 |
| --- | --- | --- | --- |
| 2026-04-22 | 建立 Playgroud 控制仓库、任务状态、知识库、模板和本地 skills 同步副本 | `AGENTS.md`、`README.md`、`docs/core/`、`docs/tasks/`、`docs/knowledge/`、`skills/`、`templates/` | `scripts/validate-system.ps1` |
| 2026-04-23 | 将用户画像、偏好采集、执行约束、停止前检查和文本风险扫描纳入系统 | `docs/profile/`、`docs/core/`、`docs/assistant/forbidden-terms.json`、`scripts/scan-text-risk.ps1` | `scripts/check-finish-readiness.ps1` |
| 2026-04-25 | 补充 Zotero、视频资料、成本控制、Git 网络诊断和技能审计能力 | `docs/workflows/literature-zotero.md`、`docs/workflows/video.md`、`docs/references/assistant/cost-control.md`、`scripts/test-git-network.ps1`、`scripts/audit-skills.ps1` | 专项脚本和系统校验 |
| 2026-04-26 | 完成 v2 结构收敛，建立核心协议、能力清单、验收记录、MCP 治理和自动化策略 | `docs/core/`、`docs/capabilities/`、`docs/validation/v2-acceptance/`、`docs/references/assistant/mcp-capability-plan.md`、`docs/references/assistant/automation-policy.md` | `scripts/validate-doc-structure.ps1`、`scripts/validate-acceptance-records.ps1` |
| 2026-04-27 | 删除失效历史摘要和高风险自动化，新增受控自我改进流程、自动化审计、提案分类和 skill 同步审计 | `docs/references/assistant/self-improvement-loop.md`、`scripts/audit-automations.ps1`、`scripts/audit-system-improvement-proposals.ps1`、`scripts/audit-skill-sync.ps1` | `scripts/validate-system.ps1`、`scripts/check-finish-readiness.ps1` |
