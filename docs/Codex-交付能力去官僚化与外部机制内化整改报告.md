# Codex 交付能力去官僚化与外部机制内化整改报告

日期：2026-05-03  
工作区：`D:\Code\Playgroud`  
范围：仓库内可审计、可回滚改动；未写入外部账号、外部 vault、用户级配置或长期服务。

## 实际完成的改动

- 建立 `docs/core/delivery-contract.md`，要求复杂任务先定义 User Outcome、Done Criteria、Hidden Obligations、风险面、验证计划和停止条件。
- 建立 `docs/core/tool-use-budget.md`，限制用脚本替代判断。
- 建立 `docs/core/skill-use-policy.md`，为 9 个仓库级 skill 设定 default: do_not_load、加载条件、禁用条件和 max_read。
- 建立 `docs/core/context-modes.md`，定义 delivery、research、audit、uiux、coding、recovery 六种模式。
- 建立 `docs/core/typed-object-registry.md`，统一 task、failure、lesson、capability、external adoption、research queue 的字段和状态。
- 建立 `docs/capabilities/external-adoptions.md`，为 10 个指定外部项目写入 adoption cards。
- 重写 `docs/capabilities/capability-map.yaml` 和 `docs/capabilities/index.md`，用新成熟度枚举替代旧 active。
- 建立 `docs/validation/real-task-evals.md`，覆盖 writing、Python package、UI change、repo maintenance 四类真实任务 eval 规格。
- 建立 `docs/tasks/board.md`，补 active/next/blocked/done、checkpoint、resume summary、stale detection 和 next action。
- 建立 `docs/knowledge/research/research-queue.md`，只声明可审计 queue spec、run log 和 review gate，不声明后台服务。
- 建立 `docs/references/assistant/hook-risk-stdin-smoke.md`，说明 hook risk 的标准输入 JSON 调用方式。
- 新增 `scripts/lib/commands/validate-delivery-system.ps1`，并接入 `scripts/codex.ps1 validate` 与 `scripts/codex.ps1 eval`。
- 修复 `scripts/codex.ps1 help`，补 `git <args>` 与 `cache <name>`。
- 新增 `scripts/codex.ps1 cache status` 和 `scripts/codex.ps1 cache clean-external-repos`。
- 更新 `AGENTS.md`、`README.md`、`docs/core/index.md`、`routing-v1.yaml`，把启动顺序改为 git status -> active/core -> delivery contract -> 最小 workflow/skill/MCP/scripts。
- 更新 UI/UX、research、literature-zotero、knowledge workflow，补证据、引用、状态和任务路径要求。
- 归档旧 active task 到 `docs/tasks/done.md`，创建本轮 active task。

## 删除、合并与归档

- 删除 `.cache/external-repos`：12693 个文件、4027 个目录。
- 删除空 `.cache` 目录。
- 删除未跟踪树输出 `list.txt`。
- 删除未跟踪一次性报告目录 `docs/reports/`。
- 删除空目录 `.agents/skills/playgroud-maintenance/agents`。
- 删除空目录 `docs/references/assistant/mcp-reviews`。
- 归档旧二次整改任务：`docs/tasks/done.md` 记录提交 `c552c2f` 已在 `origin/main`。

## 目录整改前后数字

| 指标 | 整改前 | 整改后 |
| --- | ---: | ---: |
| tracked file count | 161 | 173（本报告提交后） |
| tracked directory count | 62 | 43 |
| all directory count | 4355 | 44 |
| empty directory count | 38 | 0 |
| one-file directory count | 1639 | 17 |
| directories with only `index.md` | 4 | 2 |
| max directory depth | 13 | 4 |
| docs/ max directory depth | 4 | 4 |
| `.agents/skills/*` empty dirs | 1 | 0 |
| `scripts/lib/commands` 脚本数 | 56 | 57 |
| `.cache/external-repos` 文件数 | 12693 | 0 |
| `.cache/external-repos` 目录数 | 4027 | 0 |
| stale report dirs | `docs/reports` | 0 |
| 顶层目录数量 | 6 | 5 |
| README/AGENTS 入口存在性 | 存在 | 存在并已同步新入口 |

说明：one-file 目录仍有 17 个，主要来自稳定索引、对象目录或既有分区。没有为压低数字而移动到更深层。

## 外部项目 adoption 状态摘要

| 项目 | 状态 | 本地 artifact |
| --- | --- | --- |
| everything-claude-code | adopted | delivery contract、doctor/validate、delivery validator |
| ui-ux-pro-max-skill | adopted | UI/UX workflow、uiux-reviewer、real-task eval |
| obsidian-skills | partial | knowledge workflow、object registry、capability map |
| oh-my-codex | adopted | help 修复、cache/git 可发现性、help validator |
| vibe-kanban | partial | task board、active task、task recover |
| context-mode | adopted | context modes、tool budget、routing 更新 |
| Auto-claude-code-research-in-sleep | partial | research queue、review gate、run log validator |
| AI-Research-SKILLs | adopted | research workflow、research-to-claim eval 字段 |
| Trellis | adopted | typed object registry、adoption/capability validator |
| claude-scholar | adopted | source discipline、citation audit、unsupported claim 检查 |

adopted/partial 合计 10 项。未使用 researched_only。

## 后续行为变化

- 复杂任务开始前必须先有 Done Criteria 和 Hidden Obligations；否则不做大规模修改。
- UI 任务必须看真实界面，至少说明截图、desktop/mobile、interaction、状态、accessibility、copy 和用户任务路径。
- Knowledge 默认 repository-first；Obsidian 写入需要目标 vault、路径、权限和回滚方式。
- 长任务不再只靠 `active.md`；使用 `docs/tasks/board.md` 记录 checkpoint 和 next action。
- research queue 只能表示可审计队列和 review gate，不表示后台服务。
- Serena 不默认启用；普通文件读取、grep、git、简单修改不用 Serena。
- Capability 状态从 active 降级到 declared / smoke_passed / experimental / task_proven / user_proven / deprecated。
- sample smoke 不再写成真实任务证明。

## Capability 状态变化

旧 capability map 中 9 项写为 active、1 项写为 experimental。本轮改为：

- experimental：delivery-readiness-contract、knowledge-promotion-lifecycle、task-board-session-recovery、context-modes、research-queue-review-gate、typed-object-registry。
- smoke_passed：command-help-route、uiux-real-review-pack、research-to-claim-pipeline、system-audit-validate-eval、failure-lesson-mechanism-loop。
- task_proven / user_proven：本轮未使用，避免虚高。

## 新增限制

- Tool budget：每个任务默认最多 3 类系统脚本；脚本输出不会改变下一步行动时不运行。
- Skill policy：9 个仓库级 skill 默认 do_not_load，只读触发条件、输出契约和最短 checklist。
- MCP policy：Serena、Browser、GitHub、Obsidian 不因 routing 或 skill 名称自动打开；普通 CLI 能解决的问题不引入 MCP。

## 新增真实任务 eval

`docs/validation/real-task-evals.md` 定义 4 个真实任务回放 eval：

- writing-revision-eval
- python-package-delivery-eval
- ui-change-eval
- repo-maintenance-eval

每个 eval 均包含 task_input、expected_user_outcome、hidden_obligations、required_artifacts、required_verification、common_failure_modes、pass_conditions、fail_conditions、evidence_required、rollback_or_recovery。

## 状态漂移修复

- `docs/tasks/active.md` 不再停留在“二次整改待提交/推送”。
- `docs/tasks/done.md` 记录旧任务已由 `c552c2f` 推送到 `origin/main`。
- `scripts/codex.ps1 help` 已列出实际支持的 `git` 和 `cache`。
- hook risk 标准输入 JSON smoke 已文档化。
- capability map 已移除旧 `status: active` 字段。
- `.cache/external-repos` 已删除，并可用 `cache status` 检查。

## 验证结果

已通过：

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\lib\commands\validate-delivery-system.ps1
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\codex.ps1 help
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\codex.ps1 cache status
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\codex.ps1 capability map
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\codex.ps1 task recover
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\lib\commands\validate-active-load.ps1
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\lib\commands\validate-doc-structure.ps1
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\lib\commands\audit-minimality.ps1
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\lib\commands\validate-routing-v1.ps1
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\lib\commands\check-task-state.ps1
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\codex.ps1 validate
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\codex.ps1 eval
git diff --check
```

关键结果：

- `validate-delivery-system.ps1`：PASS，10 个 adoption cards 全部为 adopted 或 partial，capability map 11 项均使用新 maturity_status。
- `scripts/codex.ps1 validate`：System validation passed。
- `scripts/codex.ps1 eval`：overall pass，current_files=173，delivery_system_contracts pass。
- `git diff --check`：退出码 0；只出现 CRLF 行尾提示，没有 whitespace error。
- `scripts/codex.ps1 cache status`：external_repos_state absent，files=0，directories=0。
- `scripts/codex.ps1 help`：已列出 `git <args>` 和 `cache <name>`。

待提交后运行：

- `powershell -NoProfile -ExecutionPolicy Bypass -File scripts\lib\commands\check-finish-readiness.ps1 -Strict`

原因：strict finish readiness 会把未提交本地改动记为 warning；因此应在提交后作为最终收尾门运行。

## 未完成事项

- 需要在本报告写入后重新运行完整验证链。
- 若 GitHub 推送失败，需要记录网络错误和恢复命令。
- UI/UX、research、Obsidian、context 等能力仍主要是 smoke_passed 或 experimental，不能写成 user_proven。

## 新增依赖清单

无新增外部依赖。未安装外部 runtime、MCP、服务或第三方包。

## 外部写入清单

无外部写入。未写 Obsidian vault、GitHub issue/PR、外部账号、系统配置或长期服务。

## Git 状态

本报告写入时仍为本地未提交改动。最终提交前已查看：

```powershell
git status --short --branch
```

状态为 `## main...origin/main`，并列出本轮相关修改与新增文件。未见用户无关改动残留。

## 关键 diff 摘要

- 新增核心合同与预算文件：`docs/core/*.md`。
- 新增外部 adoption cards：`docs/capabilities/external-adoptions.md`。
- 重写 capability map：`docs/capabilities/capability-map.yaml`。
- 新增真实任务 eval：`docs/validation/real-task-evals.md`。
- 新增任务板与研究队列：`docs/tasks/board.md`、`docs/knowledge/research/research-queue.md`。
- 新增集中验证门：`scripts/lib/commands/validate-delivery-system.ps1`。
- 修改统一入口：`scripts/codex.ps1`。
- 清理缓存和未跟踪噪声。

## 回滚方法

- 若已提交：优先 `git revert <commit>`。
- 若未提交：删除新增文件，恢复修改文件，并用 `git status --short --branch` 确认。
- cache 清理回滚：本轮删除的是忽略缓存，需重新克隆外部项目才能恢复；adoption cards 已保留证据路径和机制结论。
- 对外部账号、用户级配置和长期服务无回滚需求，因为本轮未写入。

## 下一次 Codex 应避免的问题

- 不用批量脚本熟悉仓库；先定义具体不确定问题。
- 不把外部项目阅读写成已内化；必须有本地触发点、行为变化、验证和回滚。
- 不默认打开 Serena 或其它 MCP；先说明 CLI 为什么不够。
- 不用 active 或 smoke 这样的粗词描述成熟度；使用 capability map 枚举。
- 不保留临时 clone、树输出或一次性报告目录。
- 发现 task、help、hook、capability、README 和实际行为不一致时，低风险范围内直接修复。
