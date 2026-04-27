# 科研文献验收

## 输入

- `docs/knowledge/items/2026-04-23-boe-mems-pre-research-boundary-literature-check.md`
- `docs/workflows/research.md`
- `templates/research/citation-checklist.md`

## 执行路径

先区分科研事实、推断和未核验来源，再用引用核验清单固定 DOI、出版社页面、本地 PDF 或 Zotero 路径等字段。该验收不新增外部文献结论，只验证 v2 是否能把科研任务转为可检查的本地产物。

## 产物

- `templates/research/citation-checklist.md`
- `scripts/new-artifact.ps1 -Type citation-checklist`
- 历史引用核验清单样例，原路径为 `output/v2-research-literature-citation-checklist.md`，当前不再作为版本化文件保留。
- `docs/knowledge/research/index.md`

## 验证

- `scripts/new-artifact.ps1 -Type citation-checklist` 已验证可生成核验清单输出；新输出默认写入被忽略的 `output/` 目录。
- `scripts/validate-acceptance-records.ps1` 检查本记录字段完整。
- `scripts/validate-system.ps1` 纳入引用模板和知识索引检查。

## 复盘

科研能力不能只生成流畅综述。正式文本前必须区分已核验引用、待核验引用和不能进入参考文献的线索。本轮把该要求固化为模板和验收记录。

## 边界

未联网重新核验所有文献，不把既有知识条目的引用真实性提升为已验证事实。正式论文或项目报告仍需逐条核验 DOI、出版社页或数据库记录。

