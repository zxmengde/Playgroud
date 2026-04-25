# 当前任务

## 当前目标

实施 Playgroud v2 大改：把仓库从规则和流程文档集合重构为可执行、可恢复、可审计的个人工作系统。保留兼容入口，完成核心协议、能力清单、知识分区索引、结构化任务状态、旧规则迁移、代表性验收记录和停止前检查脚本。

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

## 未验证判断

- 新的核心入口能否显著减少未来任务的上下文负担，需要后续多轮真实任务继续验证。
- 历史知识条目仍保留在 `docs/knowledge/items/`，后续是否实体迁移到分区目录需要在确认不破坏链接后再做。
- Zotero 和视频能力已经完成流程与边界验收，但未读取个人库、观看历史或具体用户视频；真实样例仍需用户提供明确输入或授权路径。
- `scripts/check-ppt-text-extract.ps1` 可运行，已发现现有 `output/ppt_text_extract.json` 中第 12 页文本项较多；该输出属于既有 PPT 文本抽取结果，不代表 v2 重构失败。

## 阻塞

- 当前工作区已有大量未提交改动，不能执行 `git pull`。
- GitHub 远程同步仍受网络问题影响；2026-04-26 诊断显示代理 TCP 端口可达，但 `curl` 和 `git ls-remote` 在 Schannel TLS 握手阶段失败。
- 未提交、未推送、未创建远程 PR；是否提交和推送需要后续明确指令，远程推送前应先运行 Git 网络诊断。

## 下一步

本轮 v2 仓库内部重构、旧规则迁移、验收记录和主校验已完成。后续可审阅 diff，决定是否提交；若要同步远程，应先运行 `scripts/test-git-network.ps1 -Proxy http://127.0.0.1:7897 -Remote origin`。

## 恢复入口

从 `codex/playgroud-v2-rebuild` 分支恢复，先读取本文件、`AGENTS.md`、`docs/core/` 和 `docs/validation/v2-acceptance/index.md`。随后运行 `git status --short --branch`、`scripts/validate-system.ps1` 和 `scripts/check-finish-readiness.ps1`。

## 反迎合审查

- 是否只完成字面要求：上一轮过早停止，只交付了结构和部分校验；本轮已继续完成旧规则迁移、验收记录、复盘记录和检查脚本集成。
- 是否检查真实目标：真实目标是得到可执行、可恢复、可审计的个人工作系统，而不是堆叠更多规则。
- 是否把用户粗略判断当作事实：用户目标已明确选择重新设计、全域均衡、更强扩展；具体实现仍需保留权限和验证边界。
- 是否用流畅语言掩盖未验证结论：所有能力成熟度保持保守标注，真实效果等待代表性任务验证。
