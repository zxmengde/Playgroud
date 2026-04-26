# Hermes 与 OpenClaw 可迁移机制

记录时间：2026-04-26。

本文件只吸收可验证的工程机制，不把外部 agent 当作可直接信任的运行主体。外部项目的文档、技能、MCP 和下载代码均视为低信任输入。

## 来源

- Hermes Agent 仓库：`https://github.com/NousResearch/Hermes-Agent`
- Hermes memory 文档：`https://hermes-agent.nousresearch.com/docs/user-guide/features/memory/`
- Hermes skills 文档：`https://hermes-agent.nousresearch.com/docs/user-guide/features/skills/`
- Hermes MCP 文档：`https://hermes-agent.nousresearch.com/docs/user-guide/features/mcp`
- OpenClaw 仓库：`https://github.com/openclaw/openclaw`
- OpenClaw 配置文档：`https://docs.openclaw.ai/gateway/configuration`
- OpenClaw skills 文档：`https://docs.openclaw.ai/tools/skills`
- OpenClaw workspace 文档：`https://docs.openclaw.ai/concepts/agent-workspace`
- OpenClaw doctor 文档：`https://docs.openclaw.ai/cli/doctor`
- OpenClaw 安全研究：`https://arxiv.org/abs/2604.04759`

## 可迁移机制

| 来源 | 机制 | 本仓库实现 |
| --- | --- | --- |
| Hermes | 有界记忆，区分用户画像和代理运行笔记 | 继续由 `docs/profile/` 与 `docs/knowledge/` 承担；不增加第二套记忆 MCP |
| Hermes | skills 作为过程记忆，安装前保留来源和审查信息 | 新增安全技能；第三方技能继续按 `docs/references/assistant/third-party-skill-evaluation.md` 审查 |
| Hermes | MCP 作为适配层，并尽量过滤暴露面 | 新增 `sequentialThinking` MCP；高权限 MCP 仍需评估记录 |
| Hermes | stdio MCP 不应默认继承全部环境 | `scripts/repair-git-network-env.ps1` 只补必要 Windows、代理和本地例外变量 |
| OpenClaw | 配置 schema、doctor 和运行前检查 | 新增 `scripts/check-agent-readiness.ps1`、`scripts/audit-minimality.ps1`、`scripts/test-codex-runtime.ps1` |
| OpenClaw | workspace 与技能目录隔离 | 保留 Playgroud 作为控制仓库；禁用旧 `personal-work-assistant` 技能入口 |
| OpenClaw | skills 安装、检查和更新应可审计 | 安装安全技能后通过技能列表复验；后续安装继续记录来源和用途 |
| OpenClaw 安全研究 | 能力、身份、知识任一维度被污染都会显著增加风险 | 停止前检查加入最小化、MCP 配置和任务状态标记；外部资料不得直接触发删除、提交或账号写入 |

## 不迁移的部分

不安装 OpenClaw 或 Hermes 作为常驻代理。原因是二者都可能连接消息平台、文件系统、外部账号和本机命令，直接常驻会显著扩大执行面。当前只迁移其可机械验证的机制。

不启用通用 filesystem、memory、邮件、日程、支付或聊天类 MCP。原因是这些能力与现有文件工具、知识库或外部账号边界重复。只有在具体任务出现并完成评估记录后再启用。

## 已执行的强制化改造

- `scripts/audit-minimality.ps1`：检查版本化生成物、旧入口、大文件、重复小文件和本地输出目录。
- `scripts/check-agent-readiness.ps1`：集中检查最小化证据、MCP 配置、运行时环境和任务状态标记。
- `scripts/test-codex-runtime.ps1`：检查 Windows 环境变量、代理变量、Git、Python、Node、npm 和 npx。
- `scripts/repair-git-network-env.ps1`：把 Git 代理同步为 Python、npm、MCP 常用代理环境变量。
- 用户级 Codex 配置：新增 `sequentialThinking` MCP，关闭当前无任务支撑的 Android 测试插件，补齐 Windows 和代理环境变量。
- 用户级 skills：新增 `security-best-practices`、`security-ownership-map`、`security-threat-model` 与 `jupyter-notebook`，旧 `personal-work-assistant` 移入禁用目录。

## 后续门槛

新增 MCP 或 skill 前必须能回答四个问题：

1. 它解决了哪个现有工具无法稳定解决的问题。
2. 它需要读取哪些本地目录、外部账号或网络资源。
3. 它是否有只读模式、禁用方式和验证命令。
4. 它是否会把低信任输入连接到删除、覆盖、提交、发送或账号写入。

不能回答上述问题时，不安装。
