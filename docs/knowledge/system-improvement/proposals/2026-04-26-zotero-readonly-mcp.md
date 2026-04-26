# 系统改进候选：zotero-readonly-mcp

- 日期：2026-04-26
- 状态：candidate

## 触发事实

用户多次要求加强 Zotero、文献库、论文写作和引用核验能力。当前仓库已有 `docs/workflows/literature-zotero.md`、`skills/literature-zotero-workflow/SKILL.md` 和 `docs/validation/v2-acceptance/zotero-pdf.md`，但仍未确认 Zotero 数据目录、Better BibTeX 状态、常用集合、标签规则和是否允许只读读取本地库。

## 候选改动

评估并可能接入 Zotero 或文献库只读 MCP；若没有合适 MCP，先实现只读导出脚本或要求用户提供 BibTeX/RIS/CSL JSON/PDF 路径。

## 权限级别

needs-confirmation。该候选可能读取本地 Zotero 数据目录、PDF 附件路径和文献元数据；不得写入 `zotero.sqlite`，不得保存 API key、账号密码或同步令牌。安装 MCP、修改用户级 Codex 配置或读取个人文献库前必须确认。

## 证据

- `docs/profile/user-model.md`：记录用户希望加强 Zotero、文献库和引用核验能力。
- `docs/workflows/literature-zotero.md`：已有只读边界和处理顺序。
- `docs/references/assistant/mcp-capability-plan.md`：将 Zotero 或文献库只读 MCP 列为下一阶段候选。
- `scripts/validate-system.ps1`：当前系统校验通过，但只能验证流程结构，不能证明真实 Zotero 任务已完成。

## 最小实现

先采集用户确认的 Zotero 数据目录和读取边界。第一步只处理用户导出的 BibTeX/RIS/CSL JSON 或用户指定的 PDF 文件夹；若重复任务证明需要实时库检索，再用 `scripts/new-mcp-adoption-review.ps1 -Name "zotero-readonly"` 生成 MCP 评估记录。

## 验证方式

完成一个只读文献样例：输入 3 到 5 条用户授权文献，输出来源表、引用核验记录和知识条目；运行 `scripts/validate-knowledge-index.ps1`、`scripts/validate-system.ps1` 和相关 MCP/技能审计。

## 回退方式

若接入 MCP，则从用户级 Codex 配置中删除对应 `[mcp_servers.*]` 段并重启 Codex；若只是脚本或模板，删除候选文件或保持为未采纳 proposal。

## 状态

needs-confirmation

