# title

Agent 工具、Windows 自动化与办公科研能力迁移调研

# type

web-source

# source

2026-04-23 深夜联网调研。优先使用官方文档、论文、开源项目和安全报告；仅吸收公开可验证的设计原则。

# tags

ai-agent, coding-agent, windows, office, automation, evaluation, security, skills

# status

active

# summary

本轮调研扩展到编码代理、Windows 桌面自动化、Office 任务评测、网页代理评测和 MCP 安全。可迁移结论如下。

第一，编码代理的核心不是“自动写代码”，而是上下文组织。Aider 的 repository map、Continue 的 context providers、Cline 与 Roo Code 的项目规则都说明，代理需要明确知道哪些文件、规则、差异和文档应进入上下文。当前系统应在复杂代码任务开始前形成项目地图和影响范围，再修改文件。

第二，复杂任务应分离理解、规划、编辑和审查。Aider 的 ask/code 与 architect/editor 模式、Roo Code 的模式设计、Cline 的权限控制都说明，把讨论、计划、执行和检查混在一起会增加误解风险。当前系统应继续使用概念上的 Planner、Executor、Evaluator，并把停止前检查作为最低要求。

第三，Windows 自动化不能只依赖一个工具。结构化文件优先用 Office、PDF、Python、Node 等库处理；网页优先用 Playwright 或 Chrome DevTools；桌面界面可考虑 Power Automate Desktop、Microsoft UI Automation、pywinauto 或 AutoHotkey，但这些工具应限定在稳定、可观察、低风险任务上。

第四，Office 任务需要双重验收。OfficeBench 和 PPTArena 表明，代理在 Word、PPT、Excel 中不仅要完成指令，还要保持可编辑结构和视觉质量。当前系统应对 PPT 执行结构检查与渲染检查，对 Word 检查标题、目录、引用和图表编号，对 Excel 检查公式、表格和图表。

第五，网页和桌面代理评测说明，长程任务常失败于状态管理和定位错误。OSWorld、OSWorld-MCP、BrowserGym、WorkArena 和 BrowseComp 都提示，代理需要记录步骤、截图、来源、访问时间和失败点。当前系统应把网页资料和桌面操作的证据留存纳入默认流程。

第六，第三方 skills 与 MCP 工具是能力来源，也是风险来源。OWASP、Snyk 和相关论文表明，工具描述、技能文件、网页内容和下载材料可能包含间接提示注入或恶意脚本。当前系统只评估来源可信、权限清楚、脚本可审计的第三方技能，不批量安装。

第七，用户希望的是低负担、高主动性的个人工作系统。外部工具经验应转化为本地规则、脚本、模板和检查项，而不是要求用户记住更多工具名。Codex 应自行读取、判断、执行、验证和记录；需要用户参与时，只问影响结果的关键问题。

# paths

- `docs/assistant/agent-tool-landscape.md`
- `docs/assistant/agent-capability-improvement.md`
- `docs/assistant/tool-registry.md`
- `docs/workflows/coding.md`
- `docs/workflows/office.md`
- `docs/profile/user-model.md`

# links

- Aider chat modes: https://aider.chat/docs/usage/modes.html
- Aider repository map: https://aider.chat/docs/repomap.html
- Continue context providers: https://docs.continue.dev/customize/custom-providers
- Continue config reference: https://docs.continue.dev/reference
- Cline auto approve: https://docs.cline.bot/features/auto-approve
- Roo Code docs: https://docs.roocode.com/
- Microsoft Power Automate attended and unattended automation: https://learn.microsoft.com/en-us/power-automate/guidance/planning/attended-unattended
- Microsoft UI Automation: https://learn.microsoft.com/en-us/windows/win32/winauto/entry-uiauto-win32
- pywinauto getting started: https://pywinauto.readthedocs.io/en/latest/getting_started.html
- AutoHotkey v2 `#Requires`: https://doggy8088.github.io/AutoHotkeyDocs/docs/lib/_Requires.htm
- Chrome DevTools for agents: https://developer.chrome.com/docs/devtools/agents
- OSWorld: https://os-world.github.io/
- OSWorld-MCP: https://osworld-mcp.github.io/
- OfficeBench: https://github.com/zlwang-cs/OfficeBench
- PPTArena: https://arxiv.org/abs/2512.03042
- BrowseComp: https://openai.com/index/browsecomp/
- OWASP MCP Tool Poisoning: https://owasp.org/www-community/attacks/MCP_Tool_Poisoning
- Snyk ToxicSkills: https://snyk.io/blog/toxicskills-malicious-ai-agent-skills-clawhub/

# next_actions

- 将复杂代码任务的项目地图要求写入编码流程。
- 将 Office 双重验收写入办公流程。
- 将 Power Automate Desktop、pywinauto、AutoHotkey 和 Chrome DevTools MCP 写入工具登记表的候选工具部分。
- 后续若用户确认接入桌面自动化，再建立独立脚本和权限记录。
