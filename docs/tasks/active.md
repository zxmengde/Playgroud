# 当前任务

## 当前目标

按用户 2026-04-27 要求完成 Playgroud 自我进化式优化：以仓库事实、可运行检查、引用关系、外部调研和 diff 为依据，降低无效复杂度，补齐受控自我改进流程，并提交、推送本轮改动。

## 已读来源

- `AGENTS.md`
- `README.md`
- `docs/core/companion-target.md`
- `docs/core/self-configuration.md`
- `docs/core/identity-and-goal.md`
- `docs/core/permission-boundary.md`
- `docs/core/execution-loop.md`
- `docs/core/memory-state.md`
- `docs/core/finish-readiness.md`
- `docs/profile/user-model.md`
- `docs/profile/preference-map.md`
- `docs/tasks/active.md`
- `docs/workflows/coding.md`
- `docs/workflows/research.md`
- `docs/workflows/knowledge.md`
- `docs/capabilities/index.md`
- `docs/capabilities/gap-review.md`
- `docs/capabilities/companion-roadmap.md`
- `docs/capabilities/pruning-review.md`
- `docs/references/assistant/tool-registry.md`
- `docs/references/assistant/automation-policy.md`
- `docs/references/assistant/external-capability-radar.md`
- `docs/references/assistant/agent-benchmark-integration.md`
- `docs/references/assistant/mcp-allowlist.json`
- `docs/knowledge/index.md`
- `docs/knowledge/system-improvement/index.md`
- `docs/knowledge/system-improvement/harness-log.md`
- `docs/validation/v2-acceptance/index.md`
- `skills/*/SKILL.md`
- `scripts/*.ps1`
- Hermes Agent 官方文档：memory、skills、MCP、cron 与 security 相关页面。
- OpenClaw 官方文档：agent workspace、skills、hooks、doctor、configuration 相关页面。

## 已执行命令

- `git status --short --branch`
- `git switch -c codex/self-evolution-optimization`
- `rg --files`
- `git diff -- docs/capabilities/pruning-review.md`
- `scripts/validate-system.ps1`，首次失败于已删除历史摘要仍被强制引用。
- `scripts/check-finish-readiness.ps1`，首次失败于同一缺失引用。
- `scripts/audit-minimality.ps1`
- `scripts/audit-redundancy.ps1`
- `scripts/audit-file-usage.ps1`
- `scripts/audit-active-references.ps1`
- `scripts/audit-codex-capabilities.ps1`
- `scripts/audit-mcp-config.ps1`
- `scripts/audit-system-improvement-proposals.ps1`
- `scripts/validate-skills.ps1`
- `scripts/validate-acceptance-records.ps1`
- `scripts/audit-video-skill-readiness.ps1`
- 用户级自动化文件检查：`C:\Users\mengde\.codex\automations\*\automation.toml`
- Codex App 自动化删除：删除每日 `local` 自动化 `automation`。
- `scripts/audit-automations.ps1`
- `scripts/validate-knowledge-index.ps1`
- `scripts/validate-doc-structure.ps1`
- `scripts/validate-system.ps1`，改动后通过。

## 产物

- 删除已失去当前价值的 `docs/archive/assistant-v1-summary.md`，并同步移除强制校验、知识索引和验收记录中的当前引用。
- 删除用户级每日 `local` 自动化 `automation`，避免一次性完整授权长期化；保留两个 worktree 自动化。
- 新增 `docs/references/assistant/index.md`，把长引用清单从入口迁移为按需索引。
- 新增 `docs/references/assistant/self-improvement-loop.md`，定义受控自我改进流程。
- 新增 `scripts/audit-automations.ps1`，检查长期自动化是否越过边界。
- 增强 `scripts/new-system-improvement-proposal.ps1`、`scripts/audit-system-improvement-proposals.ps1` 和 `templates/assistant/system-improvement-proposal.md`，要求候选改动带 `memory`、`skill`、`config`、`hook`、`doc`、`eval` 或 `automation` 分类。
- 增强 `scripts/validate-knowledge-index.ps1`，检查知识索引中本地路径是否存在。
- 新增 `docs/validation/v2-acceptance/self-improvement-loop.md` 并接入验收校验。
- 更新能力、自动化、外部能力、工具登记、复盘记录和精简审查文档。

## 未验证判断

- Hermes 与 OpenClaw 的迁移判断来自公开仓库和官方文档；没有安装或运行二者，因此只作为机制借鉴，不作为本仓库已有能力。
- `scripts/audit-file-usage.ps1` 仍列出低引用候选，但低引用不等于无用；skills 和模板可能由 Codex App 或特定任务触发。
- 两个保留的 Codex App 自动化已通过本地文件审计确认存在，但尚未等待下一次周期运行。

## 阻塞

- Git 远端推送尚未执行。提交前需再次运行停止前检查、查看 diff 和 Git 状态。
- 是否进一步合并旧研究资料、删减 `agents/openai.yaml` 或低引用模板，需要更多真实任务证据；本轮不凭引用计数删除。

## 下一步

运行 `scripts/check-finish-readiness.ps1`，查看 diff，随后 stage、commit、push。

## 恢复入口

从 `D:\Code\Playgroud` 恢复：

```powershell
git status --short --branch
.\scripts\validate-system.ps1
.\scripts\check-finish-readiness.ps1
.\scripts\audit-automations.ps1
.\scripts\audit-active-references.ps1
```

## 反迎合审查

- 是否只完成字面要求：没有。已基于失败校验、自动化文件和引用关系做了删除、索引收敛、脚本增强和验收记录。
- 是否检查真实目标：真实目标是让仓库更简洁、可靠、可恢复、可审计，而不是增加新一层 agent 框架。
- 是否把用户粗略判断当作事实：没有。用户认为复杂度过高，但本轮只删除已证实失效的历史摘要引用和高风险自动化，未仅凭低引用计数删除技能或模板。
- 是否用流畅语言掩盖未验证结论：没有。验证结果写入任务状态；未运行 Hermes/OpenClaw 和自动化周期未触发均已列为未验证判断。
