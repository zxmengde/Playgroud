# 当前任务

## 当前目标

按用户 2026-04-27 要求继续对 Playgroud 做仓库级精简：不仅处理脚本，也处理所有文件和结构。判断标准改为：除非文件能证明支撑当前执行、验证、恢复、知识沉淀、权限边界或专项任务，否则应合并、删除或收敛到索引。

## 已读来源

- `AGENTS.md`
- `README.md`
- `docs/core/index.md`
- `docs/profile/user-model.md`
- `docs/profile/preference-map.md`
- `docs/tasks/active.md`
- `docs/workflows/coding.md`
- `docs/workflows/research.md`
- `docs/workflows/knowledge.md`
- `docs/capabilities/index.md`
- `docs/references/assistant/index.md`
- `docs/references/assistant/tool-registry.md`
- `docs/references/assistant/automation-policy.md`
- `docs/references/assistant/external-capability-radar.md`
- `docs/references/assistant/mcp-allowlist.json`
- `docs/knowledge/index.md`
- `docs/knowledge/system-improvement/harness-log.md`
- `docs/validation/v2-acceptance.md`
- `skills/*/SKILL.md`
- `scripts/*.ps1`
- Hermes Agent 官方文档：memory、skills、MCP、cron 与 security 相关页面。
- OpenClaw 官方文档：agent workspace、skills、hooks、doctor、configuration 相关页面。

## 已执行命令

- `git status --short --branch`
- `git pull --ff-only`
- `rg --files`
- `git ls-files`
- `scripts/audit-minimality.ps1`
- `scripts/audit-redundancy.ps1`
- `scripts/audit-file-usage.ps1`
- `scripts/audit-active-references.ps1`
- `scripts/audit-codex-capabilities.ps1`
- `scripts/audit-mcp-config.ps1`
- `scripts/audit-system-improvement-proposals.ps1`
- `scripts/audit-automations.ps1`
- `scripts/audit-skill-sync.ps1`
- `scripts/sync-user-skills.ps1`
- `scripts/eval-agent-system.ps1`
- `scripts/validate-knowledge-index.ps1`
- `scripts/validate-doc-structure.ps1`
- `scripts/validate-acceptance-records.ps1`
- `scripts/validate-system.ps1`
- `scripts/check-finish-readiness.ps1`
- `scripts/pre-commit-check.ps1`
- `scripts/new-artifact.ps1` 五类产物临时生成测试，临时文件已清理。
- `scripts/sync-user-skills.ps1`，删除用户级已退休横向 skills，当前同步 10 个仓库 skills。
- `rg` 旧路径检查，未发现已删除核心协议、能力分文件、验收分文件、分区知识索引、低调用模板或 agent YAML 的当前引用。
- `scripts/validate-system.ps1`，仓库级精简后通过；审计显示 skill 定义 10 个、Markdown 53 个、低引用候选 8 个且均为实际 `SKILL.md`。
- `scripts/check-finish-readiness.ps1`，通过；仅提示当前有待提交改动。
- `scripts/pre-commit-check.ps1`，通过。

## 产物

- 核心协议合并为 `docs/core/index.md`，删除七个分散核心短文档。
- 能力差距、能力路线和精简审查合并到 `docs/capabilities/index.md`，删除分散能力文档。
- 代表性验收记录合并为 `docs/validation/v2-acceptance.md`，删除旧分散验收目录文件。
- 知识索引收敛为 `docs/knowledge/index.md`，删除四个分区索引。
- 删除旧 assistant 索引、空阻塞任务文件和已完成任务摘要文件。
- 删除 13 个 skill 附带的 agent YAML，保留 `SKILL.md` 作为仓库同步副本的唯一 skill 定义。
- 删除 `assistant-router`、`execution-governor` 和 `style-governor` 三个横向控制 skills；对应行为已由 `AGENTS.md`、`docs/core/index.md`、用户画像和会话规则承担。
- 删除未被脚本或工作流调用的低价值模板，仅保留仍被生成器或工作流使用的模板。
- 合并模板生成脚本为 `scripts/new-artifact.ps1`，删除五个旧 `new-*` 脚本。
- 将画像重复检查并入 `scripts/audit-redundancy.ps1`，删除旧画像重复审计脚本。
- 更新校验脚本、skill 同步脚本、README、引用索引、复盘记录和相关文档路径。

## 未验证判断

- Hermes 与 OpenClaw 的迁移判断来自公开仓库和官方文档；没有安装或运行二者，因此只作为机制借鉴，不作为本仓库已有能力。
- 两个保留的 Codex App 自动化已通过本地文件审计确认存在，但尚未等待下一次周期运行。
- 当前会话加载的 skill 元数据可能仍来自同步前状态；运行 `scripts/sync-user-skills.ps1` 后，新会话会读取更新后的用户级副本。

## 阻塞

- 当前仓库级精简改动已通过系统校验、停止前检查和提交前检查，尚未提交和推送。

## 下一步

查看 diff，随后提交、推送并更新草稿 PR。

## 恢复入口

从 `D:\Code\Playgroud` 恢复：

```powershell
git status --short --branch
.\scripts\validate-system.ps1
.\scripts\check-finish-readiness.ps1
.\scripts\audit-active-references.ps1
```

## 反迎合审查

- 是否只完成字面要求：没有。用户指出不应只处理脚本后，本轮转为仓库级结构精简。
- 是否检查真实目标：真实目标是让仓库默认更简洁、更可靠、更可恢复、更可审计，而不是维护所有历史文件。
- 是否把用户粗略判断当作事实：没有。删除对象基于低引用、无调用路径、内容重复、空文件或可合并结构，而不是只基于用户判断。
- 是否用流畅语言掩盖未验证结论：没有。后续必须以校验脚本、diff、文件数量变化和旧路径引用检查作为完成证据。
