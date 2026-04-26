# 当前任务

## 当前目标

在 Playgroud v2 基础上进行面向“小型综合个人工作代理”的二次重构：明确用户应得到怎样的同伴，建立必须能力矩阵，精简重复入口，补充外部能力雷达、Codex 插件、skills、MCP 和 GitHub 候选仓库评估，并把结果接入本地校验。

## 已读来源

- `AGENTS.md`
- `README.md`
- `docs/profile/user-model.md`
- `docs/profile/preference-map.md`
- `docs/assistant/*`
- `docs/workflows/*`
- `docs/knowledge/index.md`
- `docs/knowledge/items/*`
- `docs/core/*`
- `docs/references/assistant/*`
- `docs/archive/assistant-v1/*`
- `docs/validation/v2-acceptance/*`
- `skills/*/SKILL.md`
- `scripts/*.ps1`
- 用户确认的 v2 大改计划。
- OpenAI Codex 官方 best practices、customization skills、plugin build 文档。
- MCP 规范和安全原则资料。
- 本机已启用 Codex 插件 manifest。
- GitHub 候选仓库 URL 清单；实时数据因本地代理问题未可靠获取。

## 已执行命令

- `git status --short --branch`
- `git switch -c codex/playgroud-v2-rebuild`
- 使用 Node REPL 完成仓库清单、结构分析和 Git 状态读取。
- 使用本地文件迁移脚本将旧 `docs/assistant` 正文迁移到 `docs/references/assistant/`、`docs/archive/assistant-v1/`、`docs/capabilities/` 和 `docs/knowledge/system-improvement/`，并在旧路径留下兼容入口。
- `scripts/new-citation-checklist.ps1 -Title v2-research-literature-acceptance -OutputPath output/v2-research-literature-citation-checklist.md`
- `scripts/new-web-source-note.ps1 -Url https://www.anthropic.com/engineering/building-effective-agents -Title v2-web-source-acceptance -OutputPath output/v2-web-source-acceptance-web-source.md`
- `scripts/validate-doc-structure.ps1`
- `scripts/validate-acceptance-records.ps1`
- `scripts/validate-system.ps1`
- 本轮重新执行 `git status --short --branch` 和 `rg --files`。
- 读取本机插件 manifest：Browser Use、GitHub、Superpowers、Documents、Presentations、Spreadsheets。
- 查询 OpenAI 官方 Codex 文档和 MCP 相关资料。
- 使用 `tool_search` 复核可发现的 Codex app 自动化工具。
- 在用户确认后合并并删除旧兼容入口与 v1 归档候选。
- 诊断 GitHub 代理，定位到 Codex shell 进程缺少 Windows 基础网络环境变量，并新增修复脚本。
- `scripts/test-git-network.ps1 -Proxy http://127.0.0.1:7897 -Remote origin`
- `scripts/audit-redundancy.ps1`
- `scripts/validate-system.ps1`
- `scripts/check-finish-readiness.ps1`

## 产物

- `docs/core/identity-and-goal.md`
- `docs/core/permission-boundary.md`
- `docs/core/execution-loop.md`
- `docs/core/memory-state.md`
- `docs/core/finish-readiness.md`
- `docs/capabilities/index.md`
- `docs/capabilities/gap-review.md`
- `docs/references/assistant/*`
- `docs/archive/assistant-v1/*`
- `docs/validation/v2-acceptance/index.md`
- `docs/validation/v2-acceptance/research-literature.md`
- `docs/validation/v2-acceptance/zotero-pdf.md`
- `docs/validation/v2-acceptance/video-source.md`
- `docs/validation/v2-acceptance/office-document.md`
- `docs/validation/v2-acceptance/code-change.md`
- `docs/validation/v2-acceptance/web-source.md`
- `docs/knowledge/system-improvement/harness-log.md`
- `docs/knowledge/system-improvement/skill-audit.md`
- `docs/knowledge/research/index.md`
- `docs/knowledge/project/index.md`
- `docs/knowledge/web-source/index.md`
- `docs/knowledge/system-improvement/index.md`
- `scripts/check-task-state.ps1`
- `scripts/validate-knowledge-index.ps1`
- `scripts/check-finish-readiness.ps1`
- `scripts/validate-doc-structure.ps1`
- `scripts/validate-acceptance-records.ps1`
- `scripts/new-citation-checklist.ps1`
- `scripts/new-web-source-note.ps1`
- `scripts/check-ppt-text-extract.ps1`
- `output/v2-research-literature-citation-checklist.md`
- `output/v2-web-source-acceptance-web-source.md`
- `templates/research/citation-checklist.md`
- `templates/web/source-note.md`
- 收敛后的 `skills/*/SKILL.md`
- 更新后的 `AGENTS.md`、`README.md`、`docs/knowledge/index.md` 和 `scripts/validate-system.ps1`
- `docs/core/companion-target.md`
- `docs/references/assistant/external-capability-radar.md`
- `docs/capabilities/companion-roadmap.md`
- `docs/capabilities/pruning-review.md`
- `scripts/audit-redundancy.ps1`
- `docs/assistant/index.md`
- `docs/archive/assistant-v1-summary.md`
- `scripts/repair-git-network-env.ps1`

## 未验证判断

- 新增的个人工作代理目标能否减少未来任务的上下文负担，需要后续多轮真实任务继续验证。
- 历史知识条目仍保留在 `docs/knowledge/items/`，后续是否实体迁移到分区目录需要在确认不破坏链接后再做。
- Zotero 和视频能力已经完成流程与边界验收，但未读取个人库、观看历史或具体用户视频；真实样例仍需用户提供明确输入或授权路径。
- `scripts/check-ppt-text-extract.ps1` 可运行，已发现现有 `output/ppt_text_extract.json` 中第 12 页文本项较多；该输出属于既有 PPT 文本抽取结果，不代表 v2 重构失败。
- GitHub 热门仓库未获取到可靠实时 star 数；本轮只记录候选和引入标准。
- 删除旧兼容入口后，历史旧路径不再可直接打开；当前入口已合并到 `docs/assistant/index.md` 和 `docs/archive/assistant-v1-summary.md`。

## 阻塞

- `gh` 未安装，不能使用 GitHub CLI 创建 PR；本次按用户要求执行本地 Git 提交和远程同步。
- 用户画像仍存在三个维护点，后续可单独合并：`docs/profile/user-model.md`、`docs/profile/preference-map.md`、`skills/personal-work-assistant/references/user-profile.md`。

## 下一步

本轮本地重构、旧入口删除、GitHub 代理环境修复和校验已完成。当前 Git 操作将提交并推送到远程 `main`。

## 恢复入口

从当前分支恢复，先读取本文件、`AGENTS.md`、`docs/core/companion-target.md`、`docs/capabilities/companion-roadmap.md`、`docs/capabilities/pruning-review.md` 和 `docs/references/assistant/external-capability-radar.md`。随后运行 `git status --short --branch`、`scripts/audit-redundancy.ps1`、`scripts/validate-system.ps1` 和 `scripts/check-finish-readiness.ps1`。

## 反迎合审查

- 是否只完成字面要求：不能只回答“会怎么改”，本轮已把目标、路线、外部能力和精简审查写入仓库。
- 是否检查真实目标：真实目标是得到小而全面、可执行、可恢复、可审计的个人工作代理，而不是堆叠更多规则。
- 是否把用户粗略判断当作事实：用户提出“全部工具、全部能力”是强度要求，不代表应调用高风险或无关工具；本轮使用相关安全工具并记录边界。
- 是否用流畅语言掩盖未验证结论：所有能力成熟度保持保守标注，真实效果等待代表性任务验证。
