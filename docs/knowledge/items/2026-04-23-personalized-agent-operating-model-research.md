# title

个人化 Agent 运行模型调研

# type

web-source

# source

2026-04-23 深夜联网调研。来源包括 OpenAI、Anthropic、arXiv、公开评测和安全研究资料。

# tags

personalization, agent-architecture, memory, skills, context, evaluation, safety

# status

active

# summary

本轮调研表明，个人工作系统不应简单追求更多 agent、更多技能或更长提示词。更合理的方向是把单个主 Agent 的上下文、工具、权限、记忆和退出条件做清楚，在确有需要时再引入分工。

OpenAI 的 agent 指南强调，应从清晰工具、结构化指令和适当的编排模式开始，并根据工具风险设置人工确认。Anthropic 的 agent 设计文章强调，复杂框架可能遮蔽真实提示、工具调用和响应，简单可组合流程通常更容易调试。对当前系统的启发是：优先让 Codex 主体更稳，不为了形式增加多代理结构。

个性化 agent 综述把能力拆成用户画像、记忆、规划和行动执行。ProPerSim 则强调，主动建议需要通过用户反馈持续校准。对当前系统的启发是：用户画像不能一次问完，应从真实任务反馈中逐步更新；但个性化不等于迎合，仍应保留指出更合适路径的职责。

ContextBench 显示，编码代理常存在探索上下文和真正使用上下文之间的差距。对当前系统的启发是：复杂编码任务需要项目地图和受影响文件清单，但地图不能替代真实文件阅读。

SWE-Skills-Bench 与 SkillsBench 共同说明，skills 的收益取决于任务、模型、harness 和验证方式，不是所有技能都会提高结果。对当前系统的启发是：第三方技能先评估后迁移，自有技能也要用真实任务验证，不以数量作为改进指标。

长任务评测和上下文压缩资料说明，任务越长越需要状态保存和结构化摘要。对当前系统的启发是：30 分钟以上、多文件、多来源或跨回合任务，应把状态写入 `active.md`、知识条目、复盘记录或阻塞记录，避免中断后从头开始。

# paths

- `docs/assistant/personal-agent-operating-model.md`
- `docs/assistant/execution-contract.md`
- `docs/assistant/memory-model.md`
- `docs/assistant/skill-quality-standard.md`
- `docs/profile/user-model.md`

# links

- OpenAI Practical Guide to Building Agents: https://openai.com/business/guides-and-resources/a-practical-guide-to-building-ai-agents/
- Anthropic Building Effective Agents: https://www.anthropic.com/engineering/building-effective-agents
- Personalized LLM-Powered Agents survey: https://arxiv.org/abs/2602.22680
- ProPerSim: https://arxiv.org/abs/2509.21730
- ContextBench: https://arxiv.org/abs/2602.05892
- SWE-Skills-Bench: https://arxiv.org/abs/2603.15401
- SkillsBench: https://www.skillsbench.ai/
- Factory context compression evaluation: https://factory.ai/news/evaluating-compression
- METR long task evaluation: https://evals.alignment.org/blog/2025-03-19-measuring-ai-ability-to-complete-long-tasks/

# next_actions

- 将个人化 Agent 运行模型加入系统必读文件和校验。
- 将工具风险分级、上下文地图和长任务状态写入执行契约。
- 在后续真实任务中观察这些规则是否减少重复询问和过早结束。
