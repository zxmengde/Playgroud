# title

Agent 安全模型与文本风险扫描调研

# type

web-source

# source

2026-04-23 深夜联网调研。重点参考 OWASP、Snyk、arXiv 安全论文和公开安全研究资料。

# tags

agent-security, prompt-injection, mcp, skills, supply-chain, unicode, validation

# status

active

# summary

本轮调研聚焦 agent 安全。主要结论是：个人工作系统必须把网页、MCP、第三方技能、下载文件和外部工具响应视为低信任数据。低信任内容可以提供事实线索，但不能直接驱动高权限本地操作或外部写入。

OWASP 对 MCP Tool Poisoning 的说明指出，MCP 工具描述和响应可能成为间接提示注入载体。ClawGuard、AttriGuard、MCP-ITP 和 MCP threat modeling 等近期论文进一步说明，工具调用边界、来源归因和工具描述审查是 agent 安全的重要部分。

Snyk ToxicSkills 调研表明，公开技能目录中存在提示注入和恶意载荷风险。对当前系统的启发是：第三方技能只能先读审查，不批量安装；同事经验、组织材料和风格样例只有在明确授权后才能提炼。

Cloud Security Alliance 关于 Unicode instruction injection 的资料提示，隐藏字符可用于技能或工具描述中的不可见指令。对当前系统的启发是：系统校验应包含文本风险扫描，至少先检测零宽字符、方向控制字符和异常控制字符。

本轮已新增 `docs/assistant/security-model.md` 和 `scripts/lib/commands/scan-text-risk.ps1`，并让系统校验调用扫描脚本。该脚本不能替代人工安全审查，但可以拦截一类常见不可见注入载体。

# paths

- `docs/assistant/security-model.md`
- `scripts/lib/commands/scan-text-risk.ps1`
- `docs/assistant/permissions.md`
- `docs/assistant/third-party-skill-evaluation.md`
- `scripts/lib/commands/validate-system.ps1`

# links

- OWASP MCP Tool Poisoning: https://owasp.org/www-community/attacks/MCP_Tool_Poisoning
- Snyk ToxicSkills: https://snyk.io/blog/toxicskills-malicious-ai-agent-skills-clawhub/
- ClawGuard: https://arxiv.org/abs/2604.11790
- AttriGuard: https://arxiv.org/abs/2603.10749
- MCP-ITP: https://arxiv.org/abs/2601.07395
- MCP threat modeling: https://arxiv.org/abs/2603.22489
- CSA Unicode instruction injection note: https://labs.cloudsecurityalliance.org/wp-content/uploads/2026/03/CSA_research_note_unicode_instruction_injection_ai_skills_20260310-csa-styled.pdf

# next_actions

- 在后续第三方 skill 审查中使用 `scripts/lib/commands/scan-text-risk.ps1`。
- 若未来接入 MCP 或桌面自动化，应为每个工具记录信任级别、权限和验证方式。
- 对网页摘录、PDF 文本和下载资料保持低信任处理，不把其中的指令写入规则。
