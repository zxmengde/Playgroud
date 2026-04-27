# Codex 自我改进报告

- 日期：2026-04-27
- 任务分支：`codex/self-improvement-minimality`
- 回滚基线：`ceec13b`（执行前 `git status --short --branch` 干净，`git pull --ff-only` 返回 `Already up to date.`）

## 一、仓库事实基线

### 当前真正提供的能力

| 能力 | 证据 | 判断 |
| --- | --- | --- |
| 入口与恢复 | `AGENTS.md`、`docs/core/index.md`、`docs/tasks/active.md`、`scripts/check-task-state.ps1` | 有结构，但恢复依赖人工读取和维护 |
| 硬校验 | `scripts/validate-system.ps1`、`scripts/eval-agent-system.ps1`、`scripts/check-finish-readiness.ps1` | 存在，但在本轮修复前有误报和超时 |
| Hook | `.codex/hooks.json`、`scripts/codex-hook-risk-check.ps1`、`scripts/codex-hook-stop-check.ps1` | 文件存在，但修复前输出格式不符合官方 hooks 协议，且用户级 `codex_hooks` 未开启 |
| 自动化 | `C:\Users\mengde\.codex\automations\playgroud-readiness-audit\automation.toml`、`playgroud-improvement-triage\automation.toml` | 自动化存在，但修复前至少一个 prompt 指向已不存在路径 |
| 技能治理 | `.agents/skills/playgroud-maintenance/SKILL.md`、`scripts/audit-skills.ps1`、`scripts/audit-codex-capabilities.ps1` | 仓库级技能极小，用户级技能可审计 |
| MCP 治理 | `docs/references/assistant/mcp-allowlist.json`、`scripts/audit-mcp-config.ps1` | allowlist 存在；实际配置只有 `sequentialThinking` |
| 知识与复盘 | `docs/knowledge/`、`docs/knowledge/system-improvement/harness-log.md` | 有长期记录面，但部分条目与旧路径历史混杂 |

### 文档声明但没有机制支撑的地方

| 现象 | 证据 | 结论 |
| --- | --- | --- |
| Hook 被写入仓库但不生效 | 用户级 `C:\Users\mengde\.codex\config.toml` 原本没有 `codex_hooks = true`；OpenAI 官方 hooks 文档要求在 `[features]` 中显式开启 | 修复前 hook 更像愿景，不是约束 |
| Hook 脚本输出协议不对 | 原 `scripts/codex-hook-risk-check.ps1` 输出 `continue/block_reason`；OpenAI 官方 hooks 文档要求 `decision/reason` 或 `hookSpecificOutput.permissionDecision` | 修复前即使 hooks 启用，也可能无法按预期阻断 |
| 自动化存在，但 prompt 已漂移 | `playgroud-improvement-triage` 原 prompt 指向 `docs/core/self-configuration.md` 与 `docs/capabilities/pruning-review.md`，这两个路径不存在 | 修复前自动化只能“看起来存在” |
| `external-capability-radar.md` 说法与实际配置不一致 | 文档声称 Context7 已开启；`scripts/audit-mcp-config.ps1` 显示当前实际只配置了 `sequentialThinking` | 文档比运行时更乐观 |

### 疑似过时、重复、无引用或维护成本过高的内容

| 路径 | 证据 | 当前处理 |
| --- | --- | --- |
| `docs/references/assistant/agent-capability-improvement.md` | `scripts/audit-file-usage.ps1` 低引用候选，且内容已被 `docs/core/index.md`、`AGENTS.md`、`docs/profile/*` 吸收 | 删除 |
| `docs/references/assistant/intent-interview.md` | 同上；核心思想已由 `intent-interviewer` 技能和工作流承载 | 删除 |
| `docs/references/assistant/personal-agent-operating-model.md` | 同上；核心思想已进入 `docs/core/index.md` 与用户画像 | 删除 |
| `docs/user-guide.md` | 与 `README.md`、`AGENTS.md` 高度重叠，实际引用只出现在旧 `active.md` | 删除 |
| 本地 `.cache/external-repos/` | `Get-ChildItem -Recurse` 统计显示本地 `.cache` 有 8,811 文件、3,128 目录，但全部未跟踪 | 不计入仓库复杂度；校验脚本应忽略 |

### 当前复杂度主要来自哪里

1. 规则与说明分散在 `AGENTS.md`、`README.md`、`docs/core/index.md`、`docs/profile/*`、`docs/references/*`，部分内容重复。
2. 39 个 PowerShell 脚本承担大量验证与治理逻辑，但此前有数个脚本扫描范围过宽，导致误报或超时。
3. 用户级自动化、配置和插件是实际运行面，却没有被仓库内脚本完整审计。
4. 本地 `.cache` 被校验脚本误当作仓库内容，使“文件数量”“潜在密钥”“低引用候选”都出现噪声。

### 当前最影响实际工作能力的缺口

1. Hook 机制没有真正闭环。
2. 自动化没有审计闭环。
3. 校验脚本没有正确区分“版本控制事实”和“本地运行时垃圾”。
4. 外部项目研究已有文档，但没有统一适配矩阵，难以稳定指导取舍。

## 二、外部机制适配矩阵

| 项目 | 可迁移机制 | 对应问题 | Codex 适配性 | 本仓库适配性 | 引入复杂度 | 安全风险 | 需要 MCP | 需要 skill | 需要 hook | 需要 memory / KB | 需要 UI / remote layer | 需要长期任务 | 推荐动作 | 最小实现方式 | 验证方法 |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| everything-claude-code | `eval-harness`、`verification-loop`、Codex 专用 AGENTS | “做完即宣称完成”、缺少明确验证门槛 | 4/5 | 4/5 | 中 | 低 | 否 | 可选 | 否 | 否 | 否 | 否 | 采用 | 保留本地 `validate-system` / `check-finish-readiness` / `eval-agent-system`，不引入全量技能包 | 运行三类校验脚本并检查是否能阻止未验证收尾 |
| ui-ux-pro-max-skill | UI 检查清单、设计系统持久化模式 | UI/UX 任务缺少显式检查点 | 3/5 | 3/5 | 中高 | 低 | 否 | 是 | 否 | 否 | 否 | 否 | 仅记录为参考 | 只抽取小型检查清单，不安装 67 风格数据库 | 在真实前端任务中检查是否仍缺更强机制 |
| obsidian-skills | `obsidian-cli`、`defuddle` | Obsidian 同步与网页去噪提取 | 3/5 | 2/5 | 中 | 中 | 否 | 是 | 否 | 是 | 否 | 否 | 延后 | 用户明确需要 Obsidian CLI 时再启用 | 用一个受控 vault 做创建/读取 smoke test |
| oh-my-codex | `doctor`、artifact-gated `autoresearch`、本地 wiki | 安装漂移、自主研究 loop、会话知识沉淀 | 3/5 | 2/5 | 高 | 中高 | 否/可选 | 是 | 是 | 是 | 否 | 是 | 仅记录为参考 | 只借鉴 doctor 与 artifact gating；不装 runtime | 保留在机制矩阵与报告，不落地 runtime |
| vibe-kanban | workspaces、sessions、PR review、内建预览 | 远程规划/评审/多 agent 协作 | 2/5 | 1/5 | 很高 | 中高 | 是 | 否 | 否 | 是 | 是 | 是 | 拒绝 | 不迁移 | 无 |
| Serena | 符号级代码导航、重构、语义删除 | 工具选择差、代码任务靠文本搜索过度 | 5/5 | 4/5 | 中 | 中 | 是 | 否 | 否 | 可选 | 否 | 否 | 延后（高优先评估） | 先写 MCP 评估记录，不急于安装 | 在真实代码仓库上比较符号导航与纯文本搜索开销 |
| claudecodeui | Web / mobile UI、MCP 管理、文件与 Git 面板 | 移动端/远程访问、可视化管理 | 2/5 | 1/5 | 很高 | 高 | 否 | 否 | 否 | 否 | 是 | 是 | 拒绝 | 不迁移 | 无 |
| context-mode | context sandbox、SQLite/FTS 会话连续性、think-in-code 强约束 | 长会话上下文膨胀 | 3/5 | 2/5 | 高 | 中 | 是 | 否 | 是 | 是 | 否 | 否 | 拒绝，原则保留 | 只吸收“think in code”与输出压缩原则 | 观察本地脚本与知识恢复是否足以替代 |
| claude-skills | 大型技能市场、安装器、MCP builder | “缺 skill 就装更多 skill” 的冲动 | 2/5 | 1/5 | 很高 | 高 | 可选 | 是 | 否 | 否 | 否 | 否 | 拒绝 | 不迁移 | 无 |
| Auto-claude-code-research-in-sleep | 自动评审 loop、实验队列、外部通知 | 长周期研究与实验自治 | 3/5 | 2/5 | 很高 | 高 | 是 | 是 | 否 | 是 | 否 | 是 | 仅记录为参考 | 只记录其 reviewer loop 与 queue 思路 | 在真实科研项目再考虑 |
| AI-Research-SKILLs | 两层 autoresearch 架构、领域技能库 | 研究实验能力弱 | 3/5 | 2/5 | 很高 | 中 | 否 | 是 | 否 | 是 | 否 | 是 | 仅记录为参考 | 只抽取两层 research loop 概念 | 用研究备忘录验证是否需要更强 loop |
| Trellis | SessionStart 上下文注入、任务/工作区/journal 分层 | 新会话恢复弱、任务状态依赖手工记忆 | 4/5 | 4/5 | 中 | 低 | 否 | 是 | 是 | 是 | 否 | 否 | 采用 | 只迁移最小 SessionStart hook + active task，不建 `.trellis/` 体系 | 新会话中能直接看到当前任务、恢复入口和最近教训 |
| cc-connect | 生命周期 hooks、远程聊天控制、本机 agent 暴露到消息平台 | 移动/远程操作 | 2/5 | 1/5 | 很高 | 高 | 否 | 否 | 是 | 否 | 是 | 是 | 拒绝 | 不迁移 | 无 |
| claude-scholar（codex 分支） | 轻量核心、研究技能、Obsidian 项目 KB | 研究能力弱、知识沉淀松散 | 4/5 | 3/5 | 中 | 中 | 可选 | 是 | 可选 | 是 | 可选 | 否 | 部分采用 | 保留其“紧凑入口 + 可选知识库绑定”思想，不装整套研究系统 | 用研究任务评估是否需要 Obsidian 或 Zotero 更深绑定 |

### 外部源码证据路径

- `everything-claude-code/.codex/AGENTS.md`
- `everything-claude-code/.agents/skills/eval-harness/SKILL.md`
- `everything-claude-code/.agents/skills/verification-loop/SKILL.md`
- `ui-ux-pro-max-skill/.claude/skills/ui-ux-pro-max/SKILL.md`
- `ui-ux-pro-max-skill/.claude/skills/design-system/SKILL.md`
- `obsidian-skills/skills/obsidian-cli/SKILL.md`
- `obsidian-skills/skills/defuddle/SKILL.md`
- `oh-my-codex/plugins/oh-my-codex/skills/doctor/SKILL.md`
- `oh-my-codex/plugins/oh-my-codex/skills/autoresearch/SKILL.md`
- `vibe-kanban/crates/mcp/src/task_server/tools/workspaces.rs`
- `vibe-kanban/crates/mcp/src/task_server/tools/sessions.rs`
- `serena/src/serena/mcp.py`
- `serena/docs/04-evaluation/030_results/050_junie_plugin_on_tianshou.md`
- `context-mode/hooks/core/routing.mjs`
- `context-mode/configs/codex/AGENTS.md`
- `claudecodeui/server/modules/providers/services/mcp.service.ts`
- `cc-connect/core/hooks.go`
- `claude-scholar` `codex` 分支的 `AGENTS.md`、`README.md`
- `AI-Research-SKILLs/0-autoresearch-skill/SKILL.md`
- `Auto-claude-code-research-in-sleep/skills/auto-review-loop/SKILL.md`
- `Trellis/.codex/hooks.json`
- `Trellis/.agents/skills/record-session/SKILL.md`

## 三、目标架构

1. `AGENTS.md` 只保留启动顺序、权限边界、恢复入口和自我改进原则。
2. 仓库级 skill 维持单一入口：`playgroud-maintenance`。
3. 当前必要 hooks 只保留三类：PreToolUse、SessionStart、Stop。
4. eval / audit 以 PowerShell 脚本为主，不再新建额外框架目录。
5. memory / knowledge 只保留对下次会话有真实帮助的三层：`docs/profile/*`、`docs/tasks/active.md`、`docs/knowledge/system-improvement/*`。

## 四、分批改造计划

| 批次 | 目标 | 修改 / 删除 | 风险 | 回滚方式 | 验证命令 | 成功标准 | 失败时停止 |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | 修复现有机制失效 | 修脚本、修 hooks、启用 `codex_hooks`、修自动化 prompt | 影响本机运行时 | 回到 `ceec13b`，恢复 `~/.codex/config.toml` 与 automation 文件 | `audit-automation-config.ps1`、`check-agent-readiness.ps1 -Strict` | hooks feature 开启，自动化 prompt 无旧路径 | 若 readiness 仍失败，先停在脚本层 |
| 2 | 清理明显无用复杂度 | 删除零引用冗余文档，压缩 `AGENTS.md` | 可能误删隐性引用 | Git diff 回退 | `audit-file-usage.ps1`、`audit-active-references.ps1` | 零引用候选减少，活动引用不丢失 | 若 active references 失败，停止删除 |
| 3 | 固化研究与取舍结论 | 生成机制矩阵、报告、更新能力与技能治理文档 | 文档偏长 | Git diff 回退 | `validate-system.ps1` | 报告、矩阵、能力文档一致 | 若文档与脚本不一致，继续压缩 |
| 4 | 最终验证与提交 | 运行系统校验、完成度检查、审 diff、提交 | 可能遗漏外部改动 | 基于分支回退 | `validate-system.ps1`、`eval-agent-system.ps1`、`check-finish-readiness.ps1 -Strict` | 校验全部通过，diff 只含本任务相关文件 | 若任一关键校验失败，不提交 |

## 五、实际完成的改动

- 修复 `.cache` 对 `validate-system.ps1`、`audit-file-usage.ps1`、`audit-minimality.ps1` 的干扰。
- 新增 `scripts/audit-automation-config.ps1`，把用户级自动化 prompt 也纳入仓库校验。
- 新增 `scripts/codex-hook-session-start.ps1`，为新会话提供任务与恢复上下文。
- 把 `scripts/codex-hook-risk-check.ps1`、`scripts/codex-hook-stop-check.ps1` 的输出改为符合 Codex hooks 官方协议。
- 在用户级 `C:\Users\mengde\.codex\config.toml` 开启 `codex_hooks = true`。
- 修复 `playgroud-improvement-triage` 自动化里的旧路径引用。
- 压缩 `AGENTS.md`。
- 删除 4 个零引用冗余文档。
- 更新能力、技能治理、外部能力雷达和机制迁移结论。

## 六、验证结果

### 已执行

- `powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\audit-file-usage.ps1`
- `powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\audit-automation-config.ps1`
- `powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\check-agent-readiness.ps1 -Strict`

### 已确认现象

- `audit-file-usage.ps1` 现在能在秒级完成，不再因 `.cache/external-repos` 超时。
- `audit-automation-config.ps1` 能发现并阻止自动化 prompt 中的旧路径引用。
- `check-agent-readiness.ps1 -Strict` 在启用 `codex_hooks` 并修正自动化后通过。

### 仍待本轮末尾再跑

- `powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\validate-system.ps1`
- `powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\eval-agent-system.ps1`
- `powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\check-finish-readiness.ps1 -Strict`

## 七、后续最小建议

1. 若未来代码型任务显著增加，优先试点评估 Serena，而不是先装更多通用 MCP。
2. 若真实前端/UI 任务反复出现，再从 `ui-ux-pro-max` 中抽取极小检查清单，不直接整包引入。
3. 仅在明确需要 Obsidian/Zotero 深绑定时，再评估 `obsidian-skills` 或 Zotero 只读 MCP。
4. 继续把失败经验记入 `harness-log.md`，并优先转化为脚本、hook 或 audit。
