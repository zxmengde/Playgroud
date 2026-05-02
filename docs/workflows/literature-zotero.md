# Zotero 与文献库工作流程

## 触发场景

适用于 Zotero、本地 PDF、BibTeX、RIS、CSL JSON、DOI、文献检索、论文阅读、综述写作、引用核验和参考文献整理。

## 执行要求

开始前读取 `docs/profile/user-model.md`、`docs/profile/preference-map.md` 和 `docs/workflows/research.md`。若 Zotero 数据目录、引用格式、集合范围、输出结构或导师/期刊偏好未知且影响产物质量，先少量询问；若用户暂时不想回答，采用科研保守默认值并记录未知项。

优先使用用户提供的 PDF、BibTeX/RIS/CSL JSON、DOI 列表和 Zotero 导出文件。用户已确认本机 Zotero 数据目录为 `C:\Users\mengde\Zotero`，并允许 Codex 在该目录内完成必要操作。默认仍应先使用只读连接或备份副本；任何会直接写入 `zotero.sqlite`、移动附件、改插件配置或影响 Zotero 同步状态的操作，都必须先说明备份、回退路径和验证方式。

若使用 Zotero Web API、Better BibTeX 自动导出、浏览器登录或插件安装，需要任务级授权或预授权，并写清权限和范围。不得保存 Zotero API key、账号密码或同步令牌。

本机基础检查：

```powershell
.\scripts\lib\commands\audit-zotero-library.ps1
```

## 处理顺序

先明确输出目的：证据型笔记、论文段落、综述表格、引用列表、研究问题拆解还是资料归档。不同目的对应不同深度，避免把所有文献都写成长摘要。

再建立来源表：标题、作者、年份、DOI/URL、文件路径、Zotero 集合或标签、阅读状态、与当前问题的关系。来源表优先保证可追溯。

随后进行内容处理：抽取研究问题、方法、材料、实验条件、主要结论、局限性、可迁移启发和与用户课题的关系。正式论文或报告不得使用未核验引用；无法核验的条目标注为待查线索。

最后写入知识条目或产出可编辑文件。长期有价值的结果写入 `docs/knowledge/items/` 并更新索引。

引用纪律：

- 关键 claim 必须能回到文献、数据或实验结果。
- 直接引用和转述必须分开记录，避免把改写文本当作原文。
- 只在核验 DOI、出版社页、arXiv、PubMed、IEEE、ACM 或等价来源后进入正式参考文献。
- 无法核验的来源只能作为待查线索。

## 验证

至少检查关键文献的 DOI、出版社页、PubMed、arXiv、IEEE、ACM、ScienceDirect、Nature、标准机构页面或其他可验证来源。引用格式和参考文献列表应与正文引用对应。

若 Zotero 本地库不可访问、字幕或 PDF 缺失、外部数据库不可用，应说明已完成的来源整理、未完成项和解除条件。

## 参考来源

- Zotero Web API 文档：https://www.zotero.org/support/dev/web_api/v3/start
- Zotero 数据目录说明：https://www.zotero.org/support/zotero_data
- Better BibTeX 导出说明：https://retorque.re/zotero-better-bibtex/exporting/
