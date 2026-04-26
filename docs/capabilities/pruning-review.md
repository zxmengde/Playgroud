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
| 用户画像重复信息 | `skills/personal-work-assistant/references/user-profile.md` 已改为指针 | 主画像仍有两个维护点 | 后续只在 `docs/profile/` 更新画像；运行 `scripts/audit-profile-duplication.ps1` |
| 宽泛 skill | 部分 skill 仍承担较多路由职责 | 过度拆分会降低触发稳定性 | 只在真实任务显示重复或冲突时拆分 |
| 外部工具候选 | GitHub、MCP、第三方 agent 项目很多 | 批量安装会增加权限和维护负担 | 先记录能力雷达，按任务试用 |
| `.codex/` 工作区目录 | Codex App 自动生成本地环境状态 | 提交后会把本机状态误当作仓库事实 | 加入 `.gitignore`，不版本化 |
| `docs/archive/assistant-v1/` 空目录 | 旧归档正文已合并为摘要，目录为空 | 空目录无版本价值 | 从本地删除空目录 |

## 执行门槛

精简前必须满足四项条件：有替代路径；相关校验脚本已更新；链接和索引不失效；用户确认允许删除或移动。

精简后必须运行 `scripts/validate-system.ps1` 和 `scripts/check-finish-readiness.ps1`。涉及旧路径时，还应运行 `scripts/validate-doc-structure.ps1`。

## 当前结论

本轮已在用户确认后删除分散旧入口和 v1 归档正文，并把旧技能中的重复用户画像收敛为指针。后续又把 `.codex/` 自动生成目录加入忽略规则，避免本机应用状态进入仓库。`scripts/audit-redundancy.ps1`、`scripts/audit-profile-duplication.ps1` 与 `scripts/audit-codex-capabilities.ps1` 继续用于检查重复入口、重复画像和插件可见状态。
