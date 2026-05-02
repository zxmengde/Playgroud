# Playgroud 核心协议

本文件是 Playgroud 控制仓库的单一核心入口。它只定义真实执行循环、权限边界、active load、对象系统、技能路由、MCP 边界和收尾门槛；具体实现细节进入 workflow、skill、validator、hook 和知识条目。

## 目标

Playgroud 的目标不是保存更多规则，而是让 Codex 在本仓库中工作时更少重复犯错、更会恢复、更会研究、更会验证、更会沉淀经验，并且保持可回滚、可审计。

## 默认执行循环

1. 检查 Git 状态。工作区干净且同步不会覆盖用户改动时，可以执行快进同步。
2. 读取 `docs/tasks/active.md`、`docs/tasks/board.md`、本文件、`docs/core/delivery-contract.md`、`docs/profile/user-model.md`、`docs/profile/preference-map.md`。
3. 复杂任务先定义 User Outcome、Done Criteria、Hidden Obligations、Non-goals、Risk Surface 和 Verification Plan。
4. 外部机制和 capability 状态以 `docs/core/adoption-proof-standard.md` 为准；不得把文档存在或命令入口写成能力完成。
5. 使用 `docs/knowledge/system-improvement/routing-v1.yaml` 选择最小必要 workflow、skill、MCP 和脚本；预算见 `docs/core/tool-use-budget.md` 与 `docs/core/skill-use-policy.md`。
6. 落地产物、运行 validators 与 evals、更新任务状态和必要知识。
7. 收尾前通过 finish gate，不把未验证状态伪装成完成。

## Active Load

默认全量加载：

- `AGENTS.md`
- `docs/core/index.md`
- `docs/core/delivery-contract.md`
- `docs/core/adoption-proof-standard.md`
- `docs/profile/user-model.md`
- `docs/profile/preference-map.md`
- `docs/tasks/active.md`
- `docs/tasks/board.md`

默认摘要加载：

- 最近的 open failure：只加载 `id`、`phase`、`domain`、`impact`、`status`、`summary`
- 最近的 active lesson：只加载 `id`、`target`、`status`、`title`

只在检索时读取：

- `docs/archive/`
- `docs/knowledge/items/`
- `docs/knowledge/system-improvement/proposals/`
- `closed`、`suppressed`、`rejected` failure
- `deprecated`、`rolled_back`、`expired`、`rejected` lesson

## Memory 分层

- user preference：`docs/profile/user-model.md` 与 `docs/profile/preference-map.md`
- failure lesson：`docs/knowledge/system-improvement/lessons/` 与 `harness-log.md`
- research direction：`docs/knowledge/items/*`
- architecture fact：`docs/knowledge/items/*`
- verified conclusion：`docs/knowledge/items/*`
- todo：`docs/tasks/active.md`、`docs/tasks/done.md`、`docs/tasks/blocked.md`
- obsolete / archived：`docs/archive/` 或原文件状态降级

遗忘规则：

- raw failure 不进入长期默认加载，只保留摘要或检索入口
- 过期、废弃、回滚对象不得进入默认上下文
- preference、lesson 和 knowledge 冲突时，以最新已验证证据为准，旧记录降级为 superseded、deprecated、obsolete 或 archived

## Failure 与 Lesson

- failure 对象路径：`docs/knowledge/system-improvement/failures/`
- lesson 对象路径：`docs/knowledge/system-improvement/lessons/`
- hook 只允许创建最小 failure 草稿，不允许直接写 lesson、profile 或长期 knowledge
- Codex 负责 triage、promotion target 选择、lesson review、关闭或 suppress
- lesson 可以 promotion 到 `memory / skill / hook / eval / workflow / MCP`
- promoted 或 verified lesson 才要求 target_path 已存在或具备明确外部配置证据

## Routing 与 Skills

`docs/knowledge/system-improvement/routing-v1.yaml` 是实际路由依据，不是说明文档。默认顺序是：先判 phase，再判 domain，再判能力缺口，再选最小必要 skill 和 MCP。

当前仓库级 skills：

- `playgroud-maintenance`
- `failure-promoter`
- `external-mechanism-researcher`
- `research-engineering-loop`
- `product-engineering-closer`
- `uiux-reviewer`
- `knowledge-curator`
- `tool-router`
- `finish-verifier`

## MCP 边界

- Serena：不默认打开。普通文件读取、grep、git、简单修改不使用 Serena。只有真实代码导航、符号引用、跨文件重构或文本检索反复失败时才允许启用；启用前说明 CLI 为什么不够、查询什么、何时退出、如何避免弹窗和重复 server。
- GitHub：可用于 issue、PR、repo metadata 和外部项目 review；外部账号写入仍需任务级授权或预授权。
- Browser / Web：用于外部项目、研究资料和 UI 证据；不替代本地文件读取。
- Obsidian：官方 CLI 可用于读、搜、写已注册 vault；默认仍先写仓库 knowledge，外部 vault 写入必须有目标、权限和回滚方式。
- Remote / long-running：当前只有 queue spec、来源记录、run log 和 review gate，不默认启用长期服务。

## Hooks 与 Evals

- SessionStart：输出 active load 摘要和恢复入口
- PreToolUse：阻断明显危险操作和范围不清的外部写入
- PostToolUse：对命令失败和关键验证失败创建或更新 failure 草稿
- Stop：阻止未验证收尾，不做复杂语义判断

必须维持的 validator 能力由 `scripts/codex.ps1 validate` 统一调度；私有实现位于 `scripts/lib/commands/`。

必须维持的 eval：

- repeat-failure-capture
- lesson-promotion
- routing-selection
- external-mechanism-review-check
- research-memo-quality
- uiux-review-quality
- session-recovery
- unverified-closeout-block

真实任务 eval 规格见 `docs/validation/real-task-evals.md`。adoption proof fixture 见 `docs/validation/adoption-proof-fixtures.md`。sample smoke 只能证明 `smoke_passed`；fixture proof 只能证明 `integration_tested`；真实任务证据不足时不得写成 `task_used` 或 `user_confirmed`。

## 权限边界

可直接执行：

- 本仓库内的结构化对象、skills、workflow、hook、validator、knowledge 和任务状态修改
- 可回滚的脚本、测试、构建、截图、diff 审查、提交和推送

需要任务级授权或预授权：

- 仓库外不可逆删除、覆盖、大规模移动或重要资料修改
- 外部账号写入、表单提交、发送消息、发布、购买、长期服务和系统级配置修改
- 保存任何敏感信息

## Finish Gate

复杂任务结束前必须确认：

- failure、lesson、routing、skill、validator、hook、MCP 和文档状态一致
- 已运行 `scripts/codex.ps1 validate`
- 已运行 `scripts/codex.ps1 eval`
- 已运行 `scripts/lib/commands/check-finish-readiness.ps1 -Strict`
- active task、knowledge 和 harness 摘要已更新
- latest task attempt 不是 `running` 或 `review_needed`
- final report、active task、board、attempt 和 Git 状态不矛盾
- 没有把低信任输出当作系统事实
