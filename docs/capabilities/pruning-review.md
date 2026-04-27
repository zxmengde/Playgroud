# 精简审查

本文件记录可精简对象和执行结果。旧兼容入口与 v1 归档已在用户明确要求后合并和删除。

## 精简目标

精简的目标是降低上下文负担、减少重复维护点、减少旧路径干扰，并保留恢复和审计能力。精简不等于减少验证；凡是减少验证能力的操作都不应执行。

## 候选项

| 对象 | 现状 | 风险 | 建议动作 |
| --- | --- | --- | --- |
| `docs/assistant/*.md` 兼容入口 | 已合并为 `docs/assistant/index.md` | 旧路径不再可直接打开 | 已更新校验脚本；后续使用索引和当前路径 |
| `output/` 旧生成物 | 验收记录已保留结果摘要 | 直接依赖样例会增加仓库噪声 | 已删除并加入 `.gitignore`；新生成物默认不版本化 |
| 旧 `personal-work-assistant` 技能 | 只是兼容入口，实际转交 `assistant-router` | 继续保留会扩大触发面 | 已从仓库同步副本删除；用户级副本已移入 `.codex\skills-disabled` |
| 宽泛 skill | 部分 skill 仍承担较多路由职责 | 过度拆分会降低触发稳定性 | 只在真实任务显示重复或冲突时拆分 |
| 外部工具候选 | GitHub、MCP、第三方 agent 项目很多 | 批量安装会增加权限和维护负担 | 先记录能力雷达，按任务试用 |
| Bilibili 外部技能候选 | 七个仓库已审查 | 全部安装会引入下载、发布、账号凭据和重依赖 | 只安装 `bilibili-video-evidence` 与 `video-note-writer`；其他候选保留为参考 |
| `.codex/` 工作区目录 | Codex App 自动生成本地环境状态 | 提交后会把本机状态误当作仓库事实 | 加入 `.gitignore`，不版本化 |
| `docs/archive/assistant-v1-summary.md` | 已由前序精简删除，但校验和索引曾继续引用 | 删除不完整会导致停止前检查失败 | 本轮移除强制校验和索引引用，并增加知识索引路径校验 |
| 旧 agent 研究条目和长参考文档 | 多数内容已被核心协议、能力清单、外部能力雷达和受控自我改进流程吸收 | 继续保留会扩大上下文和维护面，并包含旧路径 | 本轮删除 6 个早期 web-source 知识条目、6 个旧参考文档和旧用户教程 |
| Skill 同步状态 | 仓库同步副本可能和用户级 `.codex/skills` 漂移 | Codex 实际触发旧 skill，仓库校验却显示正常 | 新增 `scripts/audit-skill-sync.ps1` 和 `scripts/sync-user-skills.ps1`，并接入系统校验 |
| 低引用文件 | `scripts/audit-file-usage.ps1` 当前列出低引用候选 | 低引用不等于无用；templates 可能只在特定任务中使用 | 暂不凭计数继续删除。下一步只处理实际漂移、断链或真实任务证明无用的对象 |
| 每日本地“自我优化”自动化 | 直接复用一次性完整授权提示，在本地 checkout 中长期运行 | 会把一次性授权误变成长期授权 | 已删除；保留两个 worktree 只读或 proposal-only 自动化，并由 `scripts/audit-automations.ps1` 审计 |

## 执行门槛

精简前必须满足四项条件：有替代路径；相关校验脚本已更新；链接和索引不失效；用户确认允许删除或移动。

精简后必须运行 `scripts/validate-system.ps1` 和 `scripts/check-finish-readiness.ps1`。涉及旧路径时，还应运行 `scripts/validate-doc-structure.ps1`。

## 当前结论

本轮已在用户确认后删除分散旧入口和 v1 归档正文，并把 `.codex/` 自动生成目录和 `output/` 生成物加入忽略规则，避免本机应用状态和一次性输出进入仓库。本次进一步删除旧 `personal-work-assistant` 技能同步副本，并把用户级同名技能移入禁用目录。

2026-04-27 复查确认：历史摘要删除后，仓库应同步删除校验和索引中的强制引用，而不是恢复一个只为通过校验存在的历史文件。长期自动化也不能保留一次性完整授权提示。

2026-04-27 追加复查：用户指出“历史文件、版本文件、记录文件和过时文档”仍未充分处理后，本轮进一步删除早期 agent 调研流水和旧参考文档，压缩 `docs/tasks/done.md`，并增加 skill 同步审计。

后续以脚本证据为准：

```powershell
.\scripts\audit-minimality.ps1
.\scripts\audit-redundancy.ps1
.\scripts\audit-profile-duplication.ps1
.\scripts\audit-file-usage.ps1
```

2026-04-27 复查：文件使用审计仍会列出若干轻量模板和 skill 的 `agents/openai.yaml`。这些文件可能由 Codex App 或特定任务使用，暂不凭引用计数删除。
