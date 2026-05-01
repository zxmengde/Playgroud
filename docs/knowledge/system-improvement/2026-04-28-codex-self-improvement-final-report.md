# Codex 自我改进最终报告

## 1. 实施摘要

本轮已把 Phase 0 的仓库卫生修复升级为最终可运行对象系统。新增了 failure、lesson、routing、active load、仓库级 skills、validators、evals 和 hook capture；重写了核心入口、能力索引、知识流程和 MCP 方案；保留了 Serena、Obsidian、remote 的候选边界，但没有伪装成已接入能力。

## 2. 最终架构

- Core：`AGENTS.md`、`docs/core/index.md`
- Memory：`docs/profile/*`、`docs/tasks/*`、`docs/knowledge/items/*`、`docs/archive/*`
- Failure：`docs/knowledge/system-improvement/failures/`
- Lesson：`docs/knowledge/system-improvement/lessons/`
- Routing：`docs/knowledge/system-improvement/routing-v1.yaml`
- Skills：仓库级 9 个 skills，覆盖维护、自我改进、研究、产品、UI/UX、knowledge、tool routing 和 finish verification
- Hooks：SessionStart、PreToolUse、PostToolUse、Stop
- Evals：repeat-failure-capture、lesson-promotion、routing-selection、external-mechanism-review-check、research-memo-quality、uiux-review-quality、session-recovery、unverified-closeout-block、product-engineering-closeout
- MCP：GitHub、Browser / Web 已纳入；Serena 为 pilot；Obsidian 与 remote 为 candidate/interface-only

## 3. 文件清单

新增：

- `docs/knowledge/system-improvement/failures/*.yaml`
- `docs/knowledge/system-improvement/lessons/*.yaml`
- `docs/knowledge/system-improvement/routing-v1.yaml`
- `.agents/skills/{failure-promoter,external-mechanism-researcher,research-engineering-loop,product-engineering-closer,uiux-reviewer,knowledge-curator,tool-router,finish-verifier}/SKILL.md`
- `docs/workflows/{self-improvement,product,uiux}.md`
- `docs/validation/system-improvement/*.md`
- `scripts/self-improvement-object-lib.ps1`
- `scripts/validate-failure-log.ps1`
- `scripts/validate-lessons.ps1`
- `scripts/validate-routing-v1.ps1`
- `scripts/validate-skill-contracts.ps1`
- `scripts/validate-active-load.ps1`
- `scripts/eval-repeat-failure-capture.ps1`
- `scripts/eval-lesson-promotion.ps1`
- `scripts/eval-routing-selection.ps1`
- `scripts/eval-external-mechanism-review-check.ps1`
- `scripts/eval-research-memo-quality.ps1`
- `scripts/eval-uiux-review-quality.ps1`
- `scripts/eval-session-recovery.ps1`
- `scripts/eval-unverified-closeout-block.ps1`
- `scripts/eval-product-engineering-closeout.ps1`
- `scripts/codex-hook-post-tool-capture.ps1`

修改：

- `AGENTS.md`
- `docs/core/index.md`
- `docs/capabilities/index.md`
- `docs/knowledge/index.md`
- `docs/knowledge/system-improvement/{index,harness-log,skill-audit}.md`
- `docs/profile/preference-map.md`
- `docs/references/assistant/{external-capability-radar,external-mechanism-transfer,mcp-capability-plan}.md`
- `docs/tasks/active.md`
- `docs/workflows/{coding,research,web,knowledge}.md`
- `.codex/hooks.json`
- `scripts/{audit-active-references,check-agent-readiness,check-finish-readiness,codex-hook-risk-check,codex-hook-session-start,codex-hook-stop-check,eval-agent-system,validate-doc-structure,validate-skills,validate-system}.ps1`

未做：

- 未完成 Serena 真实安装验收；仅落地 pilot 与边界
- 未完成 Obsidian 外部 vault 写入；仅保留 knowledge-first 与 adapter 候选
- 未安装 remote/chat runtime；仅落地接口规范和权限边界

## 4. 验证结果

已通过的预提交验证：

- `validate-failure-log.ps1`
- `validate-lessons.ps1`
- `validate-routing-v1.ps1`
- `validate-skill-contracts.ps1`
- `validate-active-load.ps1`
- `check-agent-readiness.ps1`
- `validate-system.ps1`
- `eval-agent-system.ps1`
- SessionStart hook smoke
- PreToolUse hook smoke
- PostToolUse hook smoke（临时目录）
- Stop hook smoke

额外说明：

- `check-finish-readiness.ps1` 在脏工作区的非严格模式下仅剩“工作区有本地改动”这一条预期警告。
- clean-tree 的 `check-finish-readiness.ps1 -Strict` 在提交后执行。

## 5. 外部项目机制吸收结果

已落地：

- verification-first
- SessionStart 恢复摘要
- failure -> lesson -> mechanism 升级链路
- research / knowledge 分层
- UI/UX checklist

只保留为 pilot 或 candidate：

- Serena semantic code pilot
- Obsidian adapter
- remote / long-running interface

拒绝完整安装：

- `context-mode`
- `vibe-kanban`
- `claudecodeui`
- `cc-connect`
- `AI-Research-SKILLs` 全量
- `Auto-claude-code-research-in-sleep` 全量
- `oh-my-codex` 全量

## 6. MCP 结果

- Serena：未安装；已进入 routing、eval 和 pilot 边界
- GitHub：已纳入能力与路由
- Browser / Web：已纳入研究与 UI 验证路径
- Obsidian：未接外部 vault；当前本地 knowledge-first
- Remote / chat / long-running：未安装 runtime；已落地来源、权限和状态接口

## 7. 自我改进闭环演示

- `FAIL-20260427-210500-a1c201` 被提升为 `LESSON-self-improvement-not-just-hygiene`，并 promotion 到 `docs/workflows/self-improvement.md`
- `FAIL-20260427-213000-b77d42` 被提升为 `LESSON-external-scoring-needs-mechanism-evidence`，并 promotion 到 `scripts/eval-external-mechanism-review-check.ps1`
- `routing-v1.yaml` 把 self-improvement、research、product、coding、uiux、knowledge、finish、remote 路由到最小 skill / MCP 组合
- `finish-verifier` 与 Stop hook 共同阻止未验证收尾

## 8. 风险与回滚

- 回滚点：`1ea13f806754198a87cbee255ec7949e0af569fb`
- 可能误报：`validate-skill-contracts.ps1`、Stop hook 和 external mechanism eval 的边界可能仍偏保守
- 可放松项：若真实任务中误报频繁，可先放松 lesson 的 workflow gate 和 finish gate 的警告强度
- 禁用方式：
  - hooks：临时修改 `.codex/hooks.json` 或关闭用户级 `codex_hooks`
  - object validators：从 `validate-system.ps1` 中摘除相应脚本
  - candidate MCP：保持 routing 中 candidate 状态，不进入安装阶段

## 9. 下一步

只剩真实任务验证：

- 在真实代码仓库上执行 Serena 只读 pilot
- 在真实知识沉淀任务中验证 Obsidian adapter 是否必要
- 用真实产品任务、研究任务和 UI 任务检验新 skills 的触发与误报率
