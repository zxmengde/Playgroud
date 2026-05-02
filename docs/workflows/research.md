# 科研工作流程

## 触发场景

适用于科研问题、文献检索、论文阅读、PDF 解析、网页资料整理、实验或仿真背景资料梳理。

## 执行要求

开始前读取 `docs/profile/user-model.md` 和 `docs/profile/preference-map.md`。若研究受众、来源标准、引用格式、输出结构或证据强度偏好会显著影响产物质量，先使用 `preference-intake`。若用户暂时不想回答，采用 `preference-map.md` 中的科研保守默认值，并记录待采集项。

先明确研究问题和输出形态。若涉及当前资料、软件版本、模型、标准、论文进展或法规，应联网核对。

优先使用论文、官方文档、标准、数据集和机构资料。输出时区分事实、推断和不确定信息。

研究到 claim 的最小路径：

1. idea：研究问题、假设或待验证方向。
2. literature：来源、引用、可靠性和与问题的关系。
3. experiment：实验、仿真、计算或人工核验路径。
4. evidence：数据、表格、图、截图、引用或运行结果。
5. result：由 evidence 支撑的观察结果。
6. claim：可以写入正文或报告的结论。
7. limitation：证据不足、适用范围和替代解释。
8. figure / table / paper draft linkage：图表和草稿段落必须能追溯到 evidence。

若任务需要 research memo、实验设计、结果解释或证据缺口分析，按 `routing-v1.yaml` 调用 `research-engineering-loop`，并优先形成 memo、experiment plan 或 evidence gap list，而不是只给口头摘要。

涉及 Zotero、本地 PDF、BibTeX、RIS、CSL JSON、DOI 列表、引用核验或文献库整理时，同时读取 `docs/workflows/literature-zotero.md`，并使用 `literature-zotero-workflow`。Zotero 本地数据库默认只读处理，不得直接写入 `zotero.sqlite`。

涉及论文、综述、报告或可发表文本时，引用真实性必须单独检查。不得生成无法核验的文献条目。每条关键引用应尽量保留 DOI、出版社页面、arXiv、PubMed、ACL Anthology、IEEE、ACM、Nature、ScienceDirect、机构页面或其他可验证来源。若引用只来自二手网页，应标注可信度限制。

Scholarly source discipline：

- source reliability：区分论文、标准、官方文档、二手网页、模型输出和个人笔记。
- claim-source alignment：每个关键 claim 至少能指向一个来源或实验结果。
- citation audit：引用条目、正文引用和来源链接需要对应。
- unsupported claim detection：无法支撑的 claim 写为待查，不进入正式结论。
- literature note：记录研究问题、方法、材料、结论、局限性和适用范围。
- direct quote / paraphrase boundary：直接引用必须短且有来源；转述不能改变原意。

对新近、冷门或高影响结论，应进行来源交叉核对。无法核验的来源不得进入正式参考文献，只能作为待查线索。

## 产物

默认产出 research memo、实验计划或本地知识条目。知识条目路径为 `docs/knowledge/items/YYYY-MM-DD-title.md`，应包含来源链接、文件路径、关键词、摘要、状态和后续可执行事项。
