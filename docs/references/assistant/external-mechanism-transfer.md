# 外部机制迁移记录

本文件只保留已经吸收进本仓库的机制，以及没有完整安装但保留的 candidate 机制。

## 已吸收

- `everything-claude-code`：完成前先验证，再声明完成
- `Trellis`：SessionStart 恢复摘要、workspace 恢复习惯
- `claude-scholar`：研究与知识分层、claim 与 citation 纪律
- `claude-skills / self-improving-agent`：failure -> lesson -> mechanism 升级链路
- `ui-ux-pro-max-skill`：UI/UX checklist 思路
- `ARIS / Auto-claude-code-research-in-sleep`：review gate 和 artifact-first 研究流程
- `context-mode`：上下文预算、原始输出不过量进入上下文、按需检索
- `oh-my-codex`：catalog manifest 与状态字段优先于散乱技能堆叠
- `AI-Research-SKILLs`：research-state、hypothesis、experiment、evidence gap 的结构化研究状态

## 已转为真实接入

- Serena：已按官方方式安装到本机，并写入用户级 Codex MCP 配置
- Obsidian：已按官方 CLI 方式接入，真实 vault 读、搜、写 smoke 已通过

## 仅保留机制，不完整安装

- `context-mode`：只保留 context routing 与 think-in-code 原则
- `vibe-kanban`、`claudecodeui`、`cc-connect`：只保留 remote、workspace、PR review、来源记录和权限边界思路
- `obsidian-skills`：只保留 vault-first 与 adapter 设计思路；实际接入改用官方 CLI

## 完整安装拒绝

- 不安装多 agent runtime
- 不安装移动端工作台
- 不安装通用 memory/filesystem/git MCP
- 不安装全量外部技能包
- 不启用默认远程实验队列或外部通知桥

理由是：这些 runtime 会增加权限面、维护面和默认上下文噪声，但当前真实任务还没有证明它们的净收益。

## 2026-05-02 最小迁移

| 机制 | 来源证据 | 本仓库落点 | 动作 |
| --- | --- | --- | --- |
| daily / library 分层 | [everything-claude-code agent-sort](https://github.com/affaan-m/everything-claude-code/blob/841beea/.agents/skills/agent-sort/SKILL.md) | 低引用审计、active load 预算 | 采用 |
| 源码证据门槛 | [everything-claude-code doctor](https://github.com/affaan-m/everything-claude-code/blob/841beea/scripts/doctor.js)、[ARIS agent guide](https://github.com/wanshuiyin/Auto-claude-code-research-in-sleep/blob/99eaa14/AGENT_GUIDE.md) | `scripts/eval-external-mechanism-review-check.ps1` | 采用 |
| UI/UX 数据检索与证据项 | [ui-ux-pro-max search](https://github.com/nextlevelbuilder/ui-ux-pro-max-skill/blob/b7e3af8/src/ui-ux-pro-max/scripts/search.py) | `scripts/eval-uiux-review-quality.ps1` | 采用轻量校验，不安装数据库 |
| Obsidian CLI / canvas 技能 | [obsidian-cli skill](https://github.com/kepano/obsidian-skills/blob/fa1e131/skills/obsidian-cli/SKILL.md)、[json-canvas skill](https://github.com/kepano/obsidian-skills/blob/fa1e131/skills/json-canvas/SKILL.md) | 当前 Obsidian CLI 接通；canvas/base 延后 | 部分采用 |
| catalog manifest | [oh-my-codex catalog](https://github.com/Yeachan-Heo/oh-my-codex/blob/09cd057/templates/catalog-manifest.json) | `docs/references/assistant/mcp-allowlist.json` 与 skill contracts | 仅记录 |
| session / workspace 分离 | [vibe-kanban sessions](https://github.com/BloopAI/vibe-kanban/blob/4deb7ec/docs/workspaces/sessions.mdx) | `docs/tasks/active.md` 和摘要式归档 | 采用 |
| context sandbox | [context-mode CLAUDE](https://github.com/mksglu/context-mode/blob/bf933a5/CLAUDE.md) | active load 行数/字节预算 | 采用轻量校验 |
| research-state | [AI-Research-SKILLs research-state](https://github.com/Orchestra-Research/AI-Research-SKILLs/blob/28f2d29/0-autoresearch-skill/templates/research-state.yaml) | research memo sample 与 product stop condition | 部分采用 |
| Codex SessionStart 模板 | [Trellis Codex session-start](https://github.com/mindfold-ai/Trellis/blob/605df56/packages/cli/src/templates/codex/hooks/session-start.py) | 现有 SessionStart hook 与 task state | 仅记录，避免全量引入 |
| Obsidian project KB | [claude-scholar Obsidian setup](https://github.com/Galaxy-Dawn/claude-scholar/blob/a61bb0a/OBSIDIAN_SETUP.md) | knowledge-first + 可选 Obsidian CLI | 部分采用 |
