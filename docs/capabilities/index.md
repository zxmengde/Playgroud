# 能力清单、路线与精简门槛

本文件记录当前真正生效的能力、仍然存在的缺口，以及“足够最简”的判断标准。结论以仓库文件、脚本运行结果和用户级运行时配置为依据，不把愿景当作已实现能力。

## 当前能力

| 能力 | 当前成熟度 | 当前证据 | 主要缺口 |
| --- | --- | --- | --- |
| 任务恢复 | 可用 | `docs/tasks/active.md`、`scripts/check-task-state.ps1`、SessionStart hook 上下文注入 | 仍依赖人工维护任务状态 |
| 结构校验与完成度检查 | 可用 | `scripts/validate-system.ps1`、`scripts/check-finish-readiness.ps1`、`scripts/eval-agent-system.ps1` | 仍缺 CI 层自动执行 |
| Hook 风险拦截 | 可用 | `.codex/hooks.json`、`scripts/codex-hook-risk-check.ps1`、用户级 `codex_hooks = true` | 尚未覆盖更细的文件写入风险 |
| 自动化漂移检测 | 可用 | `scripts/audit-automation-config.ps1`、`playgroud-readiness-audit`、`playgroud-improvement-triage` | 只覆盖本仓库相关自动化 |
| 文档/知识最小化审计 | 可用 | `scripts/audit-minimality.ps1`、`scripts/audit-file-usage.ps1`、`scripts/audit-active-references.ps1` | 低引用仍需人工裁决 |
| 外部能力治理 | 可用 | `docs/references/assistant/external-capability-radar.md`、`mcp-allowlist.json`、自我改进报告 | 仍缺真实 Serena/Zotero MCP 接入样例 |
| Git / 环境诊断 | 可用 | `scripts/git-safe.ps1`、`scripts/test-git-network.ps1`、`scripts/setup-codex-environment.ps1` | Git 网络仍依赖本机代理环境 |
| 科研 / Zotero / 视频 / Office 路由 | 可用 | 现有用户级 skills、`scripts/audit-zotero-library.ps1`、`scripts/audit-video-skill-readiness.ps1` | 缺少更多真实项目验收记录 |

## 当前缺口

| 缺口 | 现状 | 当前判断 |
| --- | --- | --- |
| 语义代码工具 | 尚未安装 Serena 或同类语义 MCP | 高价值，但对控制仓库本身不是立即必需，保留为高优先评估项 |
| UI/UX 能力 | 主要依赖全局前端指令和通用 workflow | 需要在真实前端任务中验证是否还需引入更明确的检查清单 |
| 研究实验 loop | 只有知识与报告结构，没有自治实验调度层 | 默认不引入长周期自动研究机制 |
| CI / 机器级回归 | 当前依赖本地 PowerShell 校验 | 对控制仓库有价值，但优先级低于现有脚本闭环和 hooks |

## 精简门槛

“足够最简”以以下标准判断：

- `AGENTS.md` 只保留启动顺序、权限边界、恢复入口和自我改进原则。
- 仓库级 skill 维持单一入口；任务型能力留在用户级 skills 或 workflow。
- 校验脚本只统计受版本控制或明确相关的文件，不把 `.cache` 等运行时垃圾计入仓库复杂度。
- 自动化、hook、MCP 必须有明确用途、验证方法和停用路径。
- 0 引用且已被核心协议吸收的文档应删除或合并。

## 当前保留的复杂度

- `docs/core/index.md`：作为唯一核心协议入口保留。
- `docs/profile/`、`docs/tasks/active.md`、`docs/knowledge/system-improvement/`：这是恢复和长期经验复用的最小集合。
- `scripts/` 下的审计脚本：数量偏多，但大多承担硬验证，不是纯说明文本。
- 用户级 skills、plugins、automations：保留在用户目录，不在仓库中复制。

## 当前不保留的方向

- 常驻 agent、远程 UI、移动端工作台、kanban 平台、通用 memory/filesystem/git MCP。
- 没有真实收益证明的批量技能安装和自治研究 loop。
- 只会增加文档层数、不会提升验证或恢复能力的“体系化”扩展。
