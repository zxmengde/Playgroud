# Codex 自我改进报告

日期：2026-05-02  
仓库：`D:\Code\Playgroud`

## 范围

本轮目标是用仓库事实和运行验证改进 Codex 在本仓库中的长期工作能力。处理对象包括 active task、failure / lesson、外部机制研究、MCP 配置、hooks、eval、workflow、低引用文件和最终收尾链。

## 事实基线

- Git 基线：`git status --short --branch` 显示位于 `main...origin/main`。
- 直接 `git pull --ff-only` 失败：GitHub Schannel TLS 握手失败。
- Git 网络诊断：`scripts/lib/commands/test-git-network.ps1 -Remote origin` 中代理可达，`git ls-remote` 返回 `964e631... refs/heads/main`。
- 文件基线：`git ls-files` 为 156 个跟踪文件；`audit-minimality.ps1` 通过，低引用审计初始候选为 4 个。
- 验证基线：`validate-system.ps1` 和 `eval-agent-system.ps1` 初始失败，原因是用户级 Codex 配置缺少 `codex_hooks = true`，且 Serena readiness 脚本未识别当前 Serena MCP 入口。

## 实际改动

- 备份并修正 `C:\Users\mengde\.codex\config.toml`：新增 `codex_hooks = true`，将 Serena MCP 从 `uvx git+https://github.com/oraios/serena` 改为本机 `serena start-mcp-server --project-from-cwd --context=codex`。
- 重写 `docs/tasks/active.md` 为当前任务状态，新增 `Status` 和 `Last Updated`，解决中断恢复入口停留在上一轮 Serena/Obsidian 任务的问题。
- 更新 `scripts/lib/commands/check-task-state.ps1`，要求 active task 必须包含 `Status`、`Last Updated` 和 ISO 日期。
- 更新 `scripts/lib/commands/archive-task-state.ps1`，默认只写摘要归档；完整 active 原文需要显式 `-IncludeFull`。
- 更新 `scripts/lib/commands/validate-active-load.ps1`，增加 active load 行数和字节预算，当前为 488 行、27844 字节。
- 强化 `scripts/lib/commands/eval-task-quality.ps1 -Name external-mechanism-review-check`，外部机制评估必须包含 commit、path、line 证据，禁止假定式证据。
- 强化 `scripts/lib/commands/eval-task-quality.ps1 -Name uiux-review-quality`，UI/UX 样例必须覆盖桌面、移动、交互、无障碍和响应式证据。
- 强化 `scripts/lib/commands/eval-task-quality.ps1 -Name product-engineering-closeout`，产品工程样例必须包含成功标准、回滚和停止条件。
- 更新 validation samples，使样例与当前 Serena 已接通事实一致。
- 更新 `docs/workflows/coding.md`，把 Serena 从 candidate 改为已接通的只读导航优先工具。
- 更新 `docs/workflows/knowledge.md`，登记 `scripts/lib/commands/new-knowledge-item.ps1` 作为本地 knowledge item 生成入口。
- 更新外部机制迁移记录、能力雷达、MCP 方案和工具登记。

## 删除 / 合并 / 归档

- 删除 `.agents/skills/playgroud-maintenance/agents/openai.yaml`：未被当前 Codex skill 加载机制使用，且低引用。
- 删除 `docs/references/assistant/mcp-reviews/2026-04-26-sequentialThinking.md`：结论已合并到 `docs/references/assistant/mcp-capability-plan.md`。
- 删除 `docs/references/assistant/skill-quality-standard.md`：职责已由 `scripts/lib/commands/validate-skill-contracts.ps1` 和 `docs/references/assistant/third-party-skill-evaluation.md` 覆盖。
- 修正两个历史 knowledge item 中对旧 `docs/assistant/skill-quality-standard.md` 的引用。
- 更新 `docs/tasks/done.md`，补充 2026-04-28 和 2026-05-01 归档摘要。

## 新增或修改的机制

- Failure：新增 `FAIL-20260502-003500-d56836.yaml`，记录运行配置与能力登记失配。
- Lesson：新增 `LESSON-runtime-claims-need-readiness-eval.yaml`，要求 MCP、hook、自动化和外部 CLI 完成声明必须通过配置、readiness 和 active task 同步验证。
- Eval：外部机制、UI/UX、产品工程 eval 从“标题存在”提高到“证据字段存在且可审计”。
- Active load：新增预算校验，防止默认上下文继续膨胀。
- Task archive：默认摘要式归档，避免 `done.md` 变成旧 active task 堆积区。
- MCP readiness：Serena 使用本机命令入口，降低 GitHub TLS 不稳定对新会话启动的影响。

## 外部项目机制筛选

| 机制 | 来源证据 | 解决问题 | 本仓库动作 | 结论 |
| --- | --- | --- | --- | --- |
| daily / library 分层 | `everything-claude-code@841beea:.agents/skills/agent-sort/SKILL.md` | 避免默认加载过多 skill 和规则 | active load 预算、低引用删除 | 采用 |
| doctor / readiness | `everything-claude-code@841beea:scripts/doctor.js` | 防止安装或配置漂移被文档掩盖 | 保留 readiness eval，修正 Serena 配置 | 采用 |
| UI 数据检索与 evidence-first review | `ui-ux-pro-max-skill@b7e3af8:src/ui-ux-pro-max/scripts/search.py` | UI/UX 判断缺少可视和交互证据 | 强化 UI/UX eval 证据字段 | 采用轻量形态 |
| Obsidian CLI 与 canvas/base | `obsidian-skills@fa1e131:skills/obsidian-cli/SKILL.md`、`skills/json-canvas/SKILL.md` | 知识库写入和 Obsidian 格式能力 | 保持官方 CLI，canvas/base 延后 | 部分采用 |
| catalog manifest | `oh-my-codex@09cd057:templates/catalog-manifest.json` | skill 状态散乱、重复安装 | 复用 MCP allowlist 和 skill contracts | 仅记录 |
| session / workspace 分离 | `vibe-kanban@4deb7ec:docs/workspaces/sessions.mdx` | 长任务中断恢复和多会话边界 | active task 状态与摘要归档 | 采用 |
| local-only MCP 边界 | `vibe-kanban@4deb7ec:docs/integrations/vibe-kanban-mcp-server.mdx` | 远程和本地权限混淆 | 保持 remote interface-only | 延后 |
| context sandbox / 预算 | `context-mode@bf933a5:CLAUDE.md` | 原始输出挤占上下文 | active load 行数/字节预算 | 采用轻量形态 |
| 研究管线与跨审查 | `Auto-claude-code-research-in-sleep@99eaa14:AGENT_GUIDE.md` | 研究和实验缺少 reviewer / executor 分离 | 强化研究与外部机制 eval | 部分采用 |
| 实验队列 | `Auto-claude-code-research-in-sleep@99eaa14:tools/experiment_queue/queue_manager.py` | 远程长实验调度 | 不启用默认远程队列 | 拒绝本轮安装 |
| research-state | `AI-Research-SKILLs@28f2d29:0-autoresearch-skill/templates/research-state.yaml` | 假设、实验、证据缺口难恢复 | 保留 research memo 和 stop condition | 部分采用 |
| 大型技能包 | `AI-Research-SKILLs@28f2d29:.claude-plugin/marketplace.json` | 覆盖面广但默认负担大 | 不安装全量 98 个技能 | 拒绝 |
| SessionStart 注入 | `Trellis@605df56:packages/cli/src/templates/codex/hooks/session-start.py` | 新会话恢复缺上下文 | 保留现有 SessionStart 和 active task | 仅记录 |
| task store | `Trellis@605df56:packages/cli/src/templates/trellis/scripts/common/task_store.py` | 任务状态可恢复 | 摘要式归档，不引入 Trellis CLI | 部分采用 |
| Obsidian project KB | `claude-scholar@a61bb0a:OBSIDIAN_SETUP.md` | 科研知识需要项目级 vault 结构 | knowledge-first，Obsidian 可选写入 | 部分采用 |
| 研究 hook / 安全 hook | `claude-scholar@a61bb0a:hooks/hooks.json` | 自动记录与风险拦截 | 保留现有 hook 链，不复制外部 hooks | 仅记录 |

## 保留的复杂度及原因

- 9 个仓库级 skills 保留：它们对应 routing-v1 的真实领域，且 `validate-skill-contracts.ps1` 全部通过。
- 58 个 PowerShell 脚本保留：虽然数量较多，但当前低引用审计已降为 0，且 validators、evals、audit、Git 网络修复和 Office/视频/Zotero 能力分工明确。
- `docs/knowledge/items/` 保留为 retrieval-only：不进入默认 active load，但保留历史研究证据。
- Remote / long-running 仍保持 interface-only candidate：外部 runtime、长期服务和凭据边界尚未形成低维护验证路径。

## 验证结果

- `scripts/lib/commands/audit-file-usage.ps1`：通过，低引用候选从 4 降为 0。
- `scripts/lib/commands/audit-minimality.ps1`：通过，无版本化生成物、旧入口或大文件。
- `scripts/lib/commands/check-task-state.ps1`：通过。
- `scripts/lib/commands/validate-active-load.ps1`：通过，always=5，lines=488，bytes=27844。
- `scripts/lib/commands/validate-failure-log.ps1`：通过，3 个 failure 对象。
- `scripts/lib/commands/validate-lessons.ps1`：通过，3 个 lesson 对象。
- `scripts/lib/commands/validate-routing-v1.ps1`：通过。
- `scripts/lib/commands/validate-skill-contracts.ps1`：通过。
- `scripts/lib/commands/eval-agent-system.ps1`：通过，tracked_file_count=156，low_reference_candidates=0，codex_hooks_enabled=pass，serena_obsidian_readiness=pass。
- `scripts/lib/commands/validate-system.ps1`：报告写入后复跑通过。
- `scripts/lib/commands/pre-commit-check.ps1`：报告写入后复跑通过。
- `git diff --check`：通过，仅有换行符提示，无空白错误。

`check-finish-readiness.ps1 -Strict` 需要在提交后工作区干净时运行；未提交 diff 会触发严格模式 warning。

## 失败或未完成事项

- 普通 `git pull --ff-only` 仍可能在当前 shell 中遇到 Schannel TLS 握手失败；当前可用路径是 `scripts/git-safe.ps1` 或先运行网络修复脚本。
- 未启用全量 kanban、remote runtime、context-mode MCP、ARIS 长期实验队列和全量 AI research skill 包；原因是维护面、权限面和默认上下文成本高于当前已验证收益。
- Serena 编辑阶段仍需要在真实代码任务中继续积累收益证据。

## 新增清单

- Knowledge / failure：`docs/knowledge/system-improvement/failures/FAIL-20260502-003500-d56836.yaml`
- Knowledge / lesson：`docs/knowledge/system-improvement/lessons/LESSON-runtime-claims-need-readiness-eval.yaml`
- 报告：`docs/Codex 自我改进报告.md`
- Skill：无新增；保留 9 个仓库级 skill。
- Hook：无新增 hook 文件；用户级配置启用 `codex_hooks = true`。
- Eval：修改 external mechanism、UI/UX、product engineering 三个 eval。
- MCP：未新增 MCP；修正 Serena MCP 启动入口。

## 外部写入清单

- 写入 `C:\Users\mengde\.codex\config.toml`。
- 创建备份 `C:\Users\mengde\.codex\config.toml.bak-20260502-003513`。
- 克隆 10 个外部仓库到 `C:\Users\mengde\AppData\Local\Temp\playgroud-external-research-20260502-003944`，研究后已删除该临时目录。
- 未写入外部账号、未发布、未提交表单、未保存 secret。

## 新增依赖清单

无新增依赖。使用了本机已有 `serena 1.2.0`、Obsidian CLI、Git、PowerShell、`rg` 和现有仓库脚本。

## Git 状态与 Diff 摘要

生成本报告前的 diff 摘要：24 个已跟踪文件变更，258 行新增、214 行删除；另新增 2 个对象文件。删除 3 个低引用文件，修改 task state、workflow、eval、validation sample、能力记录和 harness log。

当前工作区仍为未提交状态；提交前需再次运行 `git status`、`validate-system.ps1`、`eval-agent-system.ps1` 和可行的 finish gate。

## 回滚方法

- 仓库内变更：使用 Git 回退本次提交，或按 diff 逐文件恢复。
- 用户级 Codex 配置：用 `C:\Users\mengde\.codex\config.toml.bak-20260502-003513` 覆盖当前 `config.toml`，然后重启 Codex。
- 外部临时研究目录：已删除，无需回滚；若需复查，按报告中的仓库提交号重新浅克隆。

## 下次如何避免重复犯错

- 声称 MCP、hook、CLI 或自动化能力已接通前，先跑对应 readiness 脚本和 `eval-agent-system.ps1`。
- 外部项目研究必须给出 commit、path、line，不允许用 README 印象或“假定已读取”作为证据。
- 长任务恢复先读 `docs/tasks/active.md` 的 `Status`、`Last Updated`、`Unverified`、`Blockers` 和 `Recovery`。
- 自我改进类任务不得只做文档清理；至少要触达 failure / lesson / eval / workflow / hook / skill / MCP 中的一类机制。
- 清理低引用文件时，同批更新引用、索引和验证脚本。

## 后续最小建议

1. 在真实代码任务中记录 Serena 只读导航的步数收益，三次后决定是否把编辑阶段从按需提升为默认可用。
2. 为 UI/UX 任务补一个真实截图样例目录，只保留小图或路径，不把大截图长期版本化。
3. 将 GitHub TLS 问题继续收敛到 `git-safe.ps1` 或 Codex 环境脚本，避免普通 Git 命令与诊断脚本结果分裂。
