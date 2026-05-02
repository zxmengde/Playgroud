# Zotero 与 PDF 验收

## 输入

- `docs/workflows/literature-zotero.md`
- 用户级 `literature-zotero-workflow` skill
- `templates/research/citation-checklist.md`

## 执行路径

本轮不读取本机 Zotero 数据目录、最近打开文件、浏览历史或个人 PDF 集合。验收只检查流程是否要求使用用户提供的导出文件、PDF 路径或明确授权的只读目录，并把引用、PDF、BibTeX/RIS 和核验结论分开记录。

## 产物

- `docs/workflows/literature-zotero.md`
- 用户级 `literature-zotero-workflow` skill
- `templates/research/citation-checklist.md`
- 历史引用核验清单样例，当前不再作为版本化文件保留。

## 验证

- `scripts/lib/commands/validate-skills.ps1` 验证 Zotero/PDF 技能结构。
- `scripts/lib/commands/audit-skills.ps1` 检查技能是否包含触发、读取、执行、产物和验证。
- `scripts/lib/commands/validate-acceptance-records.ps1` 检查本验收记录完整。

## 复盘

Zotero/PDF 能力的关键不是默认读取更多本地资料，而是在得到授权输入后保持可追溯：文献条目、PDF 证据、引用格式和正文用途必须能对应。

## 边界

个人 Zotero 库和本地 PDF 集合可能包含个人资料或未公开研究材料，未经明确路径和目的授权不得扫描。该能力当前成熟度仍应保持为草稿或边界已明确的可用状态。
