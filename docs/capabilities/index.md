# 能力清单、证据状态与回滚入口

本文件只记录当前真正落地并可检查的能力。统一能力地图见 `docs/capabilities/capability-map.yaml`，外部项目内化卡片见 `docs/capabilities/external-adoptions.md`。

## 状态枚举

| 状态 | 含义 |
| --- | --- |
| declared | 只有文档声明 |
| smoke_passed | 只有样例或 smoke 路径通过 |
| experimental | 可试用，但未证明稳定 |
| task_proven | 通过真实任务 eval 或真实交付证据 |
| user_proven | 用户在真实使用中确认有效 |
| deprecated | 保留历史，不再默认使用 |

不得把 sample smoke 直接写成 `task_proven` 或 `user_proven`。

## 当前能力

| capability | maturity_status | 用户入口 | 证据 | 主要限制 |
| --- | --- | --- | --- | --- |
| delivery-readiness-contract | experimental | `docs/core/delivery-contract.md`、`scripts/codex.ps1 validate` | delivery contract、validator | 不能自动判断语义质量 |
| command-help-route | smoke_passed | `scripts/codex.ps1 help`、`capability route` | help validator、dispatch | 只检查关键 help 项 |
| uiux-real-review-pack | smoke_passed | `docs/workflows/uiux.md`、real-task eval | UI workflow、eval spec | 尚无本仓库真实 UI 截图任务 |
| knowledge-promotion-lifecycle | experimental | `docs/workflows/knowledge.md` | knowledge workflow、object registry | Obsidian 写入仍需目标和回滚 |
| task-board-session-recovery | experimental | `docs/tasks/board.md`、`task recover` | board、active/done | 无 kanban server |
| context-modes | experimental | `docs/core/context-modes.md` | mode table、tool budget | 非运行时截断引擎 |
| research-queue-review-gate | experimental | `docs/knowledge/research/research-queue.md` | queue spec、run log | 无后台服务 |
| research-to-claim-pipeline | smoke_passed | `docs/workflows/research.md` | research workflow、eval spec | research smoke 不证明完整论文任务 |
| typed-object-registry | experimental | `docs/core/typed-object-registry.md` | registry、validator | 非完整 schema 编译器 |
| system-audit-validate-eval | smoke_passed | `scripts/codex.ps1 audit/validate/eval` | 统一入口、脚本结果 | 不能替代真实任务交付 |
| failure-lesson-mechanism-loop | smoke_passed | `scripts/codex.ps1 eval failure-loop` | failure/lesson validators | 样例对象仍需人工判断高影响 lesson |

## 外部机制绑定

| 外部项目 | 本地能力 |
| --- | --- |
| everything-claude-code | delivery-readiness-contract、system-audit-validate-eval、failure-lesson-mechanism-loop |
| ui-ux-pro-max-skill | uiux-real-review-pack |
| obsidian-skills | knowledge-promotion-lifecycle |
| oh-my-codex | command-help-route、system-audit-validate-eval |
| vibe-kanban | task-board-session-recovery |
| context-mode | context-modes |
| Auto-claude-code-research-in-sleep | research-queue-review-gate |
| AI-Research-SKILLs | research-queue-review-gate、research-to-claim-pipeline |
| Trellis | typed-object-registry、task-board-session-recovery、delivery-readiness-contract |
| claude-scholar | research-to-claim-pipeline、knowledge-promotion-lifecycle |

## MCP 边界

| 方向 | 当前处理 |
| --- | --- |
| Serena | 不默认启用；只在真实符号导航、引用查询或跨文件重构时使用 |
| GitHub | 用于远程 Git、issue/PR 或仓库元数据；外部账号写入仍需授权边界 |
| Browser / Web | 用于外部资料和真实 UI 证据；不替代本地文件读取 |
| Obsidian | repository knowledge-first；外部 vault 写入需要目标、权限和回滚方式 |
| Remote / long-running | 仅有 queue spec、run log 和 review gate；无后台 runtime |

## 回滚

能力回滚以 `docs/capabilities/capability-map.yaml` 的 `rollback` 字段为准。若能力只处于 `declared`、`smoke_passed` 或 `experimental`，不得在最终报告中写成用户已经验证。
