# 精简审查

本文件记录可精简对象和执行结果。旧兼容入口与 v1 归档已在用户明确要求后合并和删除。

## 精简目标

精简的目标是降低上下文负担、减少重复维护点、减少旧路径干扰，并保留恢复和审计能力。精简不等于减少验证；凡是减少验证能力的操作都不应执行。

## 候选项

| 对象 | 现状 | 风险 | 建议动作 |
| --- | --- | --- | --- |
| `docs/assistant/*.md` 兼容入口 | 已合并为 `docs/assistant/index.md` | 旧路径不再可直接打开 | 已更新校验脚本；后续使用索引和当前路径 |
| `docs/archive/assistant-v1/` | 已合并为 `docs/archive/assistant-v1-summary.md` | 旧正文细节不再逐文件保留 | 保留摘要作为历史说明 |
| `output/v2-*` 样例 | 代表性验收输出 | 删除会减少验收证据 | 保留；后续迁移到 validation 附件区 |
| 用户画像重复信息 | `docs/profile/` 与部分 skill references 有交叉 | 合并不当会丢失个人偏好 | 先列出重复段落，再确认合并 |
| 宽泛 skill | 部分 skill 仍承担较多路由职责 | 过度拆分会降低触发稳定性 | 只在真实任务显示重复或冲突时拆分 |
| 外部工具候选 | GitHub、MCP、第三方 agent 项目很多 | 批量安装会增加权限和维护负担 | 先记录能力雷达，按任务试用 |

## 执行门槛

精简前必须满足四项条件：有替代路径；相关校验脚本已更新；链接和索引不失效；用户确认允许删除或移动。

精简后必须运行 `scripts/validate-system.ps1` 和 `scripts/check-finish-readiness.ps1`。涉及旧路径时，还应运行 `scripts/validate-doc-structure.ps1`。

## 当前结论

本轮已在用户确认后删除分散旧入口和 v1 归档正文。`scripts/audit-redundancy.ps1` 继续用于检查是否重新出现重复入口。
