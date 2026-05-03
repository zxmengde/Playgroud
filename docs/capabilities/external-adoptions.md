# External Adoption Cards

本文件记录 10 个外部项目如何转化为本仓库可触发、可验证、可回滚的本地机制。状态必须符合 `docs/core/adoption-proof-standard.md`；不得再使用粗糙 `adopted`。

## everything-claude-code

source_project: https://github.com/affaan-m/everything-claude-code
status: integration_tested
inspected_evidence:
- `scripts/doctor.js`
- `commands/quality-gate.md`
- `scripts/hooks/quality-gate.js`
- `tests/scripts/doctor.test.js`
learned_mechanism: readiness contract、doctor 检查、quality gate 和安装漂移检测。
local_artifact: `docs/core/delivery-contract.md`、`docs/core/adoption-proof-standard.md`、`scripts/lib/commands/validate-delivery-system.ps1`、`scripts/codex.ps1 doctor`。
trigger_condition: 复杂任务开始、收尾前、claim 完成前。
codex_behavior_delta: 开始复杂任务前先定义 Done Criteria 和 Hidden Obligations；收尾时检查 adoption proof、capability、eval、attempt 和 Git 状态，而不是只说 validate 通过。
user_visible_entry: `scripts/codex.ps1 doctor`、`scripts/codex.ps1 validate`。
evidence: `docs/core/delivery-contract.md`; `docs/core/adoption-proof-standard.md`; `scripts/lib/commands/check-finish-readiness.ps1`
integration_proof: `scripts/lib/commands/validate-delivery-system.ps1` 检查 proof standard 和 final claim consistency。
verification: `validate-delivery-system.ps1` 与 `check-finish-readiness.ps1 -Strict`。
rollback: 删除 adoption proof 检查并恢复旧 `docs/core/index.md` 启动顺序。
prevents_past_error: 防止 active task 仍写未验证却在最终回复声称完成。

## ui-ux-pro-max-skill

source_project: https://github.com/nextlevelbuilder/ui-ux-pro-max-skill
status: smoke_passed
inspected_evidence:
- `src/ui-ux-pro-max/templates/base/quick-reference.md`
- `src/ui-ux-pro-max/templates/base/skill-content.md`
- `data/ux-guidelines.csv`
- `cli/src/index.ts`
learned_mechanism: UI/UX review pack 应覆盖截图、responsive、accessibility、interaction states、empty/loading/error、copy、visual hierarchy 和 user task path。
local_artifact: `docs/workflows/uiux.md`、`.agents/skills/uiux-reviewer/SKILL.md`、`docs/validation/real-task-evals.md` 的 `ui-change-eval`。
trigger_condition: 任何影响界面、交互或用户路径的改动。
codex_behavior_delta: UI 任务不能只看代码或 smoke；必须收集桌面/移动端证据并检查状态与文案。
user_visible_entry: `docs/workflows/uiux.md`、`scripts/codex.ps1 eval`。
evidence: `docs/workflows/uiux.md`; `.agents/skills/uiux-reviewer/SKILL.md`; `docs/validation/real-task-evals.md`
integration_proof: 无真实 UI 截图任务证据，保持 `smoke_passed`。
verification: real-task eval 字段完整性由 `validate-delivery-system.ps1` 检查。
rollback: 恢复旧 UI workflow 和 real-task eval 条目。
prevents_past_error: 防止把 UI smoke 写成真实 UI 交付证明。

## obsidian-skills

source_project: https://github.com/kepano/obsidian-skills
status: task_used
inspected_evidence:
- `skills/obsidian-cli/SKILL.md`
- `skills/obsidian-markdown/SKILL.md`
- `references/PROPERTIES.md`
- `skills/json-canvas/SKILL.md`
learned_mechanism: raw note、frontmatter、vault targeting、Obsidian Markdown 和仓库 knowledge 的边界应分开，并且 promotion 必须可追踪。
local_artifact: `docs/workflows/knowledge.md`、`docs/knowledge/promotion-ledger.md`、`docs/validation/adoption-proof-fixtures.md`、`docs/core/typed-object-registry.md`、`scripts/codex.ps1 knowledge promote|promotions`。
trigger_condition: 信息需要从临时记录提升为长期 knowledge，或用户明确要求写 Obsidian。
codex_behavior_delta: 默认 repository knowledge-first；任何长期知识提升先写 promotion ledger，只有目标 vault、路径、回退方式明确时才写外部 Obsidian；避免把一次性信息写入长期 memory。
user_visible_entry: `scripts/codex.ps1 knowledge promote -Id ...`、`scripts/codex.ps1 knowledge promotions`、`scripts/codex.ps1 knowledge check`。
evidence: `docs/workflows/knowledge.md`; `docs/core/adoption-proof-standard.md`; `docs/validation/adoption-proof-fixtures.md`; `docs/validation/operational-acceptance-trace.md`
integration_proof: `docs/validation/adoption-proof-fixtures.md` 的 `Positive Knowledge Promotion`，以及本轮 `KPL-20260503-002` 经公开入口完成 `raw_note -> curated_note -> verified_knowledge`。
verification: `validate-delivery-system.ps1` 检查非自指 evidence、promotion lifecycle、fixture 正反例和 help 入口。
rollback: 删除 knowledge lifecycle 更新，保留原 `knowledge obsidian-dry-run`。
prevents_past_error: 防止只用 ledger 自身和 adoption card 自证 Obsidian adoption。
adoption_notes: 未吸收 JSON Canvas、批量 vault patch 和完整 Obsidian skill pack；本仓库只吸收 promotion lifecycle 与 vault 边界。

## oh-my-codex

source_project: https://github.com/Yeachan-Heo/oh-my-codex
status: smoke_passed
inspected_evidence:
- `skills/help/SKILL.md`
- `templates/catalog-manifest.json`
- `src/scripts/eval/eval-help-consistency.ts`
- `docs/STATE_MODEL.md`
- `missions/help-consistency/mission.md`
learned_mechanism: 命令 help、route 入口和实际 dispatch 必须一致，状态模型必须可被检查。
local_artifact: `scripts/codex.ps1` help、`scripts/codex.ps1 cache ...`、`scripts/lib/commands/validate-delivery-system.ps1`。
trigger_condition: 用户查看 help、Codex 需要 route 或 cache 命令、验证命令发现 help 漂移。
codex_behavior_delta: 新命令必须同步 help；validator 检查 help 是否列出 `git`、`cache`、`task`、`knowledge`、`research`。
user_visible_entry: `scripts/codex.ps1 help`、`scripts/codex.ps1 capability route <route-id>`。
evidence: `scripts/codex.ps1`; `docs/core/index.md`
integration_proof: help consistency 是 smoke 级检查，尚非真实用户确认。
verification: `validate-delivery-system.ps1` 调用 help 并检查实际命令可发现。
rollback: 恢复旧 help 文本并移除 help consistency 检查。
prevents_past_error: 防止 help 文本与实际 dispatch 漂移。

## vibe-kanban

source_project: https://github.com/BloopAI/vibe-kanban
status: task_used
inspected_evidence:
- `crates/db/src/models/task.rs`
- `docs/core-features/creating-tasks.mdx`
- `docs/core-features/completing-a-task.mdx`
- `docs/workspaces/sessions.mdx`
learned_mechanism: task board、workspace/session、task attempt、checkpoint 和 session recovery。
local_artifact: `docs/tasks/board.md`、`docs/tasks/attempts.md`、`docs/tasks/active.md`、`docs/validation/adoption-proof-fixtures.md`、`scripts/codex.ps1 task board|attempt|recover`。
trigger_condition: 多任务、长期任务、中断恢复、blocked 状态或 next action 不清。
codex_behavior_delta: 不再只靠单个 active.md；长期任务必须能写 task attempt，并包含 checkpoint、resume summary、stale detection、next action、verification 和 rollback。
user_visible_entry: `scripts/codex.ps1 task board`、`scripts/codex.ps1 task attempt -Id ...`、`scripts/codex.ps1 task recover`。
evidence: `docs/tasks/board.md`; `docs/core/adoption-proof-standard.md`; `docs/validation/adoption-proof-fixtures.md`; `docs/validation/operational-acceptance-trace.md`
integration_proof: `docs/validation/adoption-proof-fixtures.md` 的 `Positive Task Attempt Lifecycle`；本轮 `ATT-20260503-004` 通过公开入口经历 `running -> review_needed -> done`，并证明 strict finish 会阻断 open attempt。
verification: `validate-delivery-system.ps1` 检查 lifecycle、latest attempt 与 active task 一致性；strict finish gate 阻止 open attempt 伪完成。
rollback: 删除 `board.md` 并恢复旧 active/done 摘要。
prevents_past_error: 防止 latest attempt 仍为 `review_needed` 时声称提交和推送完成。
adoption_notes: 未吸收 server、workspace UI、task attempt 数据库和 Git 操作服务；本仓库保留 Markdown task attempt ledger。

## context-mode

source_project: https://github.com/mksglu/context-mode
status: partial
inspected_evidence:
- `skills/context-mode/SKILL.md`
- `src/truncate.ts`
- `tests/stale-detection.test.ts`
- `configs/codex/hooks.json`
- `hooks/codex/sessionstart.mjs`
learned_mechanism: context modes、截断预算、stale detection、SessionStart 注入和 hook route。
local_artifact: `docs/core/context-modes.md`、`docs/core/tool-use-budget.md`、`docs/knowledge/system-improvement/routing-v1.yaml`。
trigger_condition: 任务进入 delivery、research、audit、uiux、coding 或 recovery 模式。
codex_behavior_delta: 不再只有单一 active load；每个模式定义加载、禁止加载、触发、退出、预算和验证。
user_visible_entry: `docs/core/context-modes.md`、`scripts/codex.ps1 context budget`。
evidence: `docs/core/context-modes.md`; `docs/core/tool-use-budget.md`
integration_proof: 模式表由 validator 检查，但没有 runtime truncation integration proof。
verification: validator 检查 6 个 mode 名称和 tool budget 文件存在。
rollback: 删除 context modes 文件并恢复旧 active load 文本。
prevents_past_error: 降低默认加载无关 skill、MCP 或长上下文的概率。

## Auto-claude-code-research-in-sleep

source_project: https://github.com/wanshuiyin/Auto-claude-code-research-in-sleep
status: task_used
inspected_evidence:
- `tools/experiment_queue/README.md`
- `queue_manager.py`
- `templates/RESEARCH_CONTRACT_TEMPLATE.md`
- `templates/EXPERIMENT_LOG_TEMPLATE.md`
- `tools/watchdog.py`
learned_mechanism: research queue、manifest、状态机、run log、review gate 和中断恢复。
local_artifact: `docs/knowledge/research/research-queue.md`、`docs/knowledge/research/run-log.md`、`docs/validation/adoption-proof-fixtures.md`、`scripts/codex.ps1 research queue|enqueue|review-gate`、`docs/core/tool-use-budget.md`。
trigger_condition: 研究任务超过单次会话、需要夜间整理、或需要 review gate。
codex_behavior_delta: 不虚称后台长期运行；只使用可审计 queue spec、run log 和人工 review gate，外部写入需要授权边界。
user_visible_entry: `scripts/codex.ps1 research queue`、`scripts/codex.ps1 research enqueue -Id ...`、`scripts/codex.ps1 research review-gate -Id ...`。
evidence: `docs/knowledge/research/research-queue.md`; `docs/knowledge/research/run-log.md`; `docs/validation/adoption-proof-fixtures.md`; `docs/validation/operational-acceptance-trace.md`
integration_proof: `docs/validation/adoption-proof-fixtures.md` 的 `Positive Research Queue Lifecycle`；本轮 `RQ-20260503-003` 经公开入口完成 `queued -> review_gate(done) -> done`，run log 与 queue 状态一致。
verification: `validate-delivery-system.ps1` 检查 queue lifecycle、review gate、run log 一致性和缺 review gate 反例。
rollback: 删除 research queue 文件并保留原 research run log。
prevents_past_error: 防止把 queue 文档或命令入口误写成无人值守长期研究能力。
adoption_notes: 未吸收 watchdog、后台守护进程、通知服务和无人值守执行 runtime；本仓库只保留可审计队列、run log 和 review gate。

## AI-Research-SKILLs

source_project: https://github.com/Orchestra-Research/AI-Research-SKILLs
status: smoke_passed
inspected_evidence:
- `0-autoresearch-skill/SKILL.md`
- `templates/research-state.yaml`
- `templates/findings.md`
- `20-ml-paper-writing/ml-paper-writing/SKILL.md`
- `references/citation-workflow.md`
learned_mechanism: idea、literature、experiment、evidence、result、claim、limitation、figure/table/paper draft linkage。
local_artifact: `docs/workflows/research.md`、`docs/knowledge/research/research-state.yaml`、`docs/validation/real-task-evals.md`。
trigger_condition: 研究任务需要从想法推进到可审查结论或论文草稿。
codex_behavior_delta: 研究输出必须区分 idea、evidence、claim 和 limitation；图表、表格和草稿需要能追溯证据。
user_visible_entry: `docs/workflows/research.md`、`scripts/codex.ps1 research smoke`。
evidence: `docs/workflows/research.md`; `docs/knowledge/research/research-state.yaml`; `docs/validation/real-task-evals.md`
integration_proof: 当前只有 smoke 和 eval spec，未证明完整论文任务。
verification: real-task eval 和 research workflow 检查字段；现有 smoke 不升级为 `task_used`。
rollback: 恢复旧 research workflow，保留现有 research-state。
prevents_past_error: 防止把研究状态文件误当作完整研究闭环。

## Trellis

source_project: https://github.com/mindfold-ai/Trellis
status: integration_tested
inspected_evidence:
- `packages/cli/src/templates/trellis/scripts/common/types.py`
- `task_store.py`
- `registry.py`
- `templates/codex/skills/finish-work/SKILL.md`
- `test/registry-invariants.test.ts`
learned_mechanism: typed task object、registry invariant、task store 和 finish-work checklist。
local_artifact: `docs/core/typed-object-registry.md`、`docs/core/adoption-proof-standard.md`、`scripts/lib/commands/validate-delivery-system.ps1`。
trigger_condition: 新增或修改 task、failure、lesson、capability、adoption card、research queue。
codex_behavior_delta: 对象必须使用明确字段和状态枚举，禁止 active/smoke/proven 混用。
user_visible_entry: `docs/core/typed-object-registry.md`、`scripts/codex.ps1 validate`。
evidence: `docs/core/typed-object-registry.md`; `docs/core/adoption-proof-standard.md`; `docs/validation/adoption-proof-fixtures.md`
integration_proof: `scripts/lib/commands/validate-delivery-system.ps1` 检查 adoption 状态枚举、capability maturity、fixture 正反例和对象生命周期。
verification: `validate-delivery-system.ps1`。
rollback: 删除 typed object registry，并移除 validator 中的对象字段检查。
prevents_past_error: 防止 `adopted`、`experimental`、`task_proven` 等状态混用造成虚假自信。

## claude-scholar

source_project: https://github.com/Galaxy-Dawn/claude-scholar
status: smoke_passed
inspected_evidence:
- `skills/citation-verification/SKILL.md`
- `references/verification-rules.md`
- `templates/project/_system/schema.md`
- `templates/notes/source-paper.md`
- `paper-self-review/references/SECTION-CHECKLIST.md`
- `obsidian-project-kb-core/references/LIFECYCLE.md`
learned_mechanism: source reliability、claim-source alignment、citation audit、unsupported claim detection、literature note、direct quote/paraphrase boundary。
local_artifact: `docs/workflows/research.md`、`docs/workflows/literature-zotero.md`、`docs/validation/real-task-evals.md`。
trigger_condition: 写论文、综述、研究 memo、引用核验或来源可信度检查。
codex_behavior_delta: 关键 claim 必须和来源对齐；直接引用和转述边界必须说明；不支持的 claim 只能列为待查。
user_visible_entry: `docs/workflows/research.md`、`docs/workflows/literature-zotero.md`。
evidence: `docs/workflows/research.md`; `docs/workflows/literature-zotero.md`; `docs/validation/real-task-evals.md`
integration_proof: 当前只有 workflow 和 eval spec，未证明真实论文任务。
verification: real-task eval 的 writing/research 字段检查 unsupported claim、citation audit 和 quote/paraphrase。
rollback: 恢复旧 research/literature workflow 文本。
prevents_past_error: 防止把未核验来源或 unsupported claim 写成结论。
