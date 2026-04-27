# 外部机制迁移记录

本文件记录 Hermes、OpenClaw 和 everything-claude-code 对 Playgroud 的可迁移机制。结论只作为本仓库实现依据，不把外部项目宣传、目录结构或代码当作可直接使用能力。

## 资料来源

- Codex Skills: `https://developers.openai.com/codex/skills`
- Codex Hooks: `https://developers.openai.com/codex/hooks`
- Codex Automations: `https://developers.openai.com/codex/app/automations`
- Codex MCP: `https://developers.openai.com/codex/mcp`
- MCP security: `https://modelcontextprotocol.io/docs/tutorials/security/security_best_practices`
- Hermes: `https://github.com/NousResearch/hermes-agent`
- OpenClaw: `https://github.com/openclaw/openclaw`
- everything-claude-code: `https://github.com/affaan-m/everything-claude-code`

## 可迁移机制

Hermes 的价值在于技能按需加载、MCP 工具面过滤、任务后学习和记忆分层。迁移为本仓库的做法是：只保留一个仓库级维护技能，把用户级技能作为运行时能力审计对象；失败经验先进入复盘或候选提案，再经过验证进入长期规则。

OpenClaw 的价值在于 workspace、doctor、sandbox 和可恢复状态。迁移为本仓库的做法是：新增 `scripts/eval-agent-system.ps1`，检查入口、MCP、hook、自动化、任务状态和低引用候选；不安装常驻 agent。

everything-claude-code 的价值在于 hooks、commands、agents、settings 的组织经验。迁移为本仓库的做法是：新增轻量 `.codex/hooks.json`，只做风险命令拦截和停止前提示；不复制全量命令、代理模板或大规模规则包。

## 不迁移内容

- 常驻后台 agent 或本机守护进程。
- 全量 slash command、hook、agent、prompt 集合。
- 通用 filesystem、git、memory、mail、calendar、drive、payment 或 finance MCP。
- 没有真实任务、权限边界、验证方式和回退路径的外部 skill 或插件。

## 本地落点

- 核心入口：`docs/core/index.md`
- 能力和精简门槛：`docs/capabilities/index.md`
- 仓库级 skill：`.agents/skills/playgroud-maintenance/SKILL.md`
- Hook 配置：`.codex/hooks.json`
- 评估脚本：`scripts/eval-agent-system.ps1`
- MCP allowlist：`docs/references/assistant/mcp-allowlist.json`
