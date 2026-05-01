# 知识沉淀流程

适用于长期有价值、已验证、可复用的信息。默认顺序是：判断层级、写本地 knowledge-first 记录、标注来源和状态、必要时执行 Obsidian 实际写入。

## 触发场景

- 研究结论、架构事实、verified conclusion
- 失败教训和 lesson 摘要
- 可复用模板、术语、路径和验证方法

## 执行要求

开始前读取 `docs/profile/user-model.md`、`docs/profile/preference-map.md` 和 `docs/tasks/active.md`。若命名、归档深度或 Obsidian 目标路径未知，先落到本地 knowledge-first。

写入前先判断层级：

- preference：进入 `docs/profile/*`
- lesson：进入 `docs/knowledge/system-improvement/lessons/` 和 `harness-log.md`
- research direction / architecture fact / verified conclusion：进入 `docs/knowledge/items/*`
- todo：进入 `docs/tasks/*`
- obsolete / archived：原地降级或移入 `docs/archive/`

不要把 raw failure、临时调试输出或未验证网页观点写成长期 knowledge。

## 产物

- `docs/knowledge/items/YYYY-MM-DD-title.md`
- `docs/knowledge/system-improvement/harness-log.md`
- 可选的 Obsidian 写入说明或实际写入

新建本地 knowledge item 时，优先使用 `scripts/new-knowledge-item.ps1 -Title "..." -Type "..."` 生成模板，再补充来源、状态、事实、推断和后续事项。该脚本只写入仓库内 `docs/knowledge/items/`，不直接写外部 vault。

## Obsidian 边界

当前已接通官方 Obsidian CLI。默认仍先写仓库 knowledge；若任务明确要求写入外部 vault，可使用 `obsidian` CLI 读、搜、写已注册 vault。避免直接批量改写既有笔记；优先写新 note、追加 note 或写入专门目录。
