# 知识沉淀流程

适用于长期有价值、已验证、可复用的信息。默认顺序是：判断层级、写本地 knowledge-first 记录、标注来源和状态、必要时准备 Obsidian 候选写入。

## 触发场景

- 研究结论、架构事实、verified conclusion
- 失败教训和 lesson 摘要
- 可复用模板、术语、路径和验证方法

## 执行要求

开始前读取 `docs/profile/user-model.md`、`docs/profile/preference-map.md` 和 `docs/tasks/active.md`。若命名、归档深度或 Obsidian 联动偏好未知，采用本地 knowledge-first 保守默认值。

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
- 可选的 Obsidian 候选写入说明

## Obsidian 边界

当前默认只写仓库内知识。只有在 vault 路径、写入范围、回退方式和 human-confirmed 权限明确时，才允许把仓库内已验证条目同步到外部 Obsidian。
