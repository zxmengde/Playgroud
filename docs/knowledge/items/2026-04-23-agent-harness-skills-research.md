# title

AI agent harness、skills 与个人工作系统调研

# type

web-source

# source

2026-04-23 深夜联网调研。优先使用官方文档、论文、开源项目说明和安全报道；未下载或使用泄露源码。

# tags

ai-agent, codex, claude-code, skills, harness, memory, personalization, workflow, safety

# status

active

# summary

本次调研的重点不是收集更多工具名，而是判断哪些工程原则可以迁移到当前个人工作系统。主要结论如下。

第一，长期可用的 agent 系统不是靠更长提示词形成，而是靠可读取、可执行、可验证的 harness。OpenAI Harness Engineering 强调把关键上下文放入仓库内的版本化文件，使 agent 能直接读取业务、规则、脚本和检查结果。对当前系统的启发是：`AGENTS.md` 应继续保持入口和目录作用，细节放入 `docs/`、`skills/`、`templates/` 和 `scripts/`；用户偏好、工作标准、验收方式和复盘记录必须成为可检索事实。

第二，skills 的价值在于按需加载和可复用程序知识。OpenAI 与 Anthropic 的 skills 文档都强调：技能描述决定触发可靠性，`SKILL.md` 应保持聚焦，复杂资料放入引用文件或脚本中，观察实际使用后再迭代。对当前系统的启发是：不能把 `office-workflow`、`research-workflow` 等写成通用流程清单；每个 workflow 都要先检查用户画像和任务场景，缺少关键偏好时进入低负担采集。

第三，用户画像不是一次问卷能够完成。近期 personalization 研究把 agent 能力拆成任务完成、主动提问和个性化适配三类目标；长期记忆研究强调偏好、经验、事实和当前工作状态应分层保存。MIT 关于个性化与迎合风险的报道提示：系统越了解用户，越需要保留纠错能力，不能只顺从用户观点。对当前系统的启发是：Codex 应记录用户偏好，但也要保留直接指出更合适路径的职责。

第四，长任务需要独立评估。Anthropic 的长期应用 harness 使用 planner、generator、evaluator 三种角色，尤其强调由 evaluator 独立检查运行结果。Claude Code hooks 文档显示，Stop hook 可阻止 agent 在检查失败时结束。对当前系统的启发是：在 Codex 当前环境中，应至少形成“计划者、执行者、审查者”三段式自检；涉及代码、文档、PPT、网页和科研结论时，应尽量用脚本、渲染、截图、测试或来源交叉核对来约束主观判断。

第五，subagents 和多 agent 不是越多越好。Claude Code subagents、AutoGen、CrewAI、OpenHands、LangGraph 等资料共同表明：多 agent 的关键是隔离上下文、限定工具权限、明确产物、保存状态和让人工在高风险节点介入。对当前系统的启发是：在没有明确需要时，不应为了形式而拆出多个 agent；但在调研、代码审查、长文档设计、PPT 视觉检查等任务中，可以用概念上的独立角色或工具检查降低自我评估偏差。

第六，第三方 skills 和泄露源码不能直接引入。skills 市场中的“同事能力蒸馏”类项目说明了 Work Skill 与 Persona 分层建模的价值，但也带来隐私、授权和数据来源风险。Claude Code 泄露源码相关报道显示，围绕泄露物的仓库存在法律和恶意软件风险。当前系统应只吸收公开、合法、可验证的设计原则，不下载、不安装、不复制泄露源码或来源不明技能。

第七，办公和科研任务需要更细的验收。PPTArena 说明 PowerPoint 编辑应同时关注指令遵循和视觉质量，并结合结构差异与幻灯片图像检查。近期关于无效引用的论文和 Nature 报道说明，AI 生成文献条目已经成为科研写作的实际风险，因此当前系统必须把引用核验作为正式科研输出的固定步骤。

第八，工具接入必须按安全边界设计。OWASP 对 MCP Tool Poisoning 的说明和近期 MCP 安全论文都指出，外部工具响应可能把恶意指令带入 agent 上下文。当前系统应将网页、MCP、邮件、第三方技能和下载文件视为不可信数据；高权限本地操作、账号写入和外部发布必须隔离并确认。

第九，第三方 skills 应先评估后迁移。Anthropic 官方 skills 仓库可作为结构参考，但其说明也要求在关键任务前充分测试。SWE-Skills-Bench 的结果提示，多数公开软件工程 skills 对端到端任务未必有收益，甚至可能因版本或上下文不匹配造成干扰。因此当前系统应优先吸收方法并重写为自有规则，而不是批量安装。

第十，个性化记忆需要分层，而不是把全部对话保存为长期事实。HiMeS、Mem-PAL、Memoria 和 PASK 等近期研究共同指向一个方向：短期任务状态、长期用户偏好、工作区知识、全局经验和主动意图识别应分开管理。对当前系统的启发是：`user-model.md` 只保存稳定画像，任务细节进 `active.md`，来源和结论进知识条目，失败与修正进复盘记录。

第十一，停止前检查应制度化。OpenAI Codex 最佳实践强调，把重复流程转化为 skills，把稳定流程转化为 automations；Claude Code hooks 文档中的 Stop hook 思路说明，agent 不应在任务未完成、校验失败或仍有明显后续工作时结束。对当前系统的启发是：即使当前环境不能直接配置同类 hooks，也应把停止前检查写成本地规则，并在复杂任务中主动执行。

第十二，风格技能和同事经验提炼技能需要更严格的授权与样例标准。Claude Skills 资料强调，skill 适合封装已经被反复验证的工作方法、模板、材料和质量标准；公开 skills 目录则显示可用技能数量增长很快，但来源差异很大。对当前系统的启发是：可以学习“把稳定工作方式封装成技能”的方法，但不能在缺少授权和样例时提炼他人信息；风格类技能必须有正例、反例和验收方式。

# paths

- `docs/assistant/agent-capability-improvement.md`
- `docs/assistant/memory-model.md`
- `docs/assistant/pre-finish-check.md`
- 历史 skill 质量入口已由 `scripts/validate-skill-contracts.ps1` 和 `docs/references/assistant/third-party-skill-evaluation.md` 取代
- `docs/profile/user-model.md`
- `docs/assistant/intent-interview.md`
- `skills/preference-intake/SKILL.md`

# links

- OpenAI Harness Engineering: https://openai.com/index/harness-engineering/
- OpenAI Codex best practices: https://developers.openai.com/codex/learn/best-practices
- OpenAI Codex customization: https://developers.openai.com/codex/concepts/customization
- Anthropic Agent Skills best practices: https://docs.claude.com/en/docs/agents-and-tools/agent-skills/best-practices
- Claude Code subagents: https://code.claude.com/docs/en/sub-agents
- Claude Code hooks: https://code.claude.com/docs/en/hooks
- Claude Code memory: https://code.claude.com/docs/en/memory
- Anthropic long-running harness design: https://www.anthropic.com/engineering/harness-design-long-running-apps
- LangGraph durable execution: https://docs.langchain.com/oss/python/langgraph/durable-execution
- AutoGen multi-agent conversation: https://microsoft.github.io/autogen/0.2/docs/Use-Cases/agent_chat/
- CrewAI documentation: https://docs.crewai.com/
- OpenHands repository: https://github.com/OpenHands/OpenHands
- SemaClaw paper: https://arxiv.org/abs/2604.11548
- Training Proactive and Personalized LLM Agents: https://arxiv.org/abs/2511.02208
- Personalized assistant with evolving conditional memory: https://aclanthology.org/2025.coling-main.254/
- MIT News on personalization and sycophancy risk: https://news.mit.edu/2026/personalization-features-can-make-llms-more-agreeable-0218
- PPTArena benchmark: https://arxiv.org/abs/2512.03042
- Fabricated citation taxonomy: https://arxiv.org/abs/2602.05930
- Nature report on hallucinated citations: https://www.nature.com/articles/d41586-026-00969-z
- Microsoft declarative agent practices: https://learn.microsoft.com/en-us/microsoft-365/copilot/extensibility/declarative-agent-best-practices
- OWASP MCP Tool Poisoning: https://owasp.org/www-community/attacks/MCP_Tool_Poisoning
- MCP security analysis: https://arxiv.org/abs/2601.17549
- System-level defenses against indirect prompt injection: https://arxiv.org/abs/2603.30016
- OpenAI practical guide to building agents: https://cdn.openai.com/business-guides-and-resources/a-practical-guide-to-building-agents.pdf
- Anthropic Building Effective AI Agents: https://resources.anthropic.com/building-effective-ai-agents
- Anthropic public skills repository: https://github.com/anthropics/skills
- OpenAI skills catalog: https://github.com/openai/skills
- Claude Skills tutorial: https://claude.com/resources/tutorials/teach-claude-your-way-of-working-using-skills
- Anthropic skills directory: https://skills.sh/anthropics
- SkillsBench paper: https://www.skillsbench.ai/skillsbench.pdf
- Agent skill security analysis: https://arxiv.org/abs/2603.16572
- SWE-Skills-Bench: https://arxiv.org/abs/2603.15401
- CoEvoSkills: https://arxiv.org/abs/2604.01687
- OpenClaw safety reporting: https://www.techradar.com/pro/how-to-safely-experiment-with-openclaw
- Cybernews Claude Code leak reporting: https://cybernews.com/tech/claude-code-leak-spawns-fastest-github-repo/
- TechRadar malware warning: https://www.techradar.com/pro/security/be-careful-what-you-click-hackers-use-claude-code-leak-to-push-malware
- PASK intent-aware proactive agents: https://arxiv.org/abs/2604.08000
- HiMeS personalized assistant memory: https://arxiv.org/abs/2601.06152
- Mem-PAL personalized dialogue memory: https://arxiv.org/abs/2511.13410
- Memoria scalable agentic memory: https://arxiv.org/abs/2512.12686

# next_actions

- 将“用户画像分层”和“偏好渐进采集”写入系统规则，而不是只依赖一次问卷。
- 为复杂任务增加概念上的 planner、executor、evaluator 自检流程。
- 为 Office、科研、编码、网页四类任务建立偏好缺失判断表。
- 对第三方 skills 建立只读评估准则：先审计来源、权限、脚本和外部访问，再决定是否借鉴。
- 把停止前检查、技能质量标准和分层记忆模型纳入系统校验。
- 为第三方、同事经验和风格 skills 使用 `templates/assistant/skill-adoption-review.md` 做审查记录。
- 在后续真实任务中记录哪些规则确实改善结果，哪些只是增加负担。
