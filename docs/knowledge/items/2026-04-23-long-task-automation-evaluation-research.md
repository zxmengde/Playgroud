# title

长任务、自动化维护与 Agent 评测调研

# type

web-source

# source

2026-04-23 联网调研。重点参考 OpenAI Codex 文档、METR、BrowseComp、LongCLI-Bench、OccuBench 和 Claude Code hooks 文档。

# tags

long-task, automation, worktree, evaluation, recovery, hooks, codex

# status

active

# summary

本轮调研聚焦长任务能力和自动化维护。主要结论是：个人工作系统不能只依赖更长提示词或单次对话，而应把长任务拆成可恢复状态、可验证产物和低风险自动化维护。

OpenAI Codex 文档将 automations 定位为稳定重复工作的调度机制，skills 定义方法，automations 定义时间和运行环境。自动化可以在本地 checkout 或 worktree 中运行；worktree 更适合隔离后台任务，避免影响用户正在编辑的文件。

METR 的长任务评测提出以人类完成时长衡量 agent 可完成任务长度。对当前系统的启发是：长任务能力要通过“持续执行、局部验证、状态保存和中断恢复”来提高，而不是只要求模型一次性完成很长输出。

BrowseComp 说明浏览任务需要持续检索、调整搜索路径和证据验证。LongCLI-Bench 的结果显示长程命令行编程任务中，许多失败发生在早期步骤，且需要同时评估需求满足和回归避免。OccuBench 提醒：隐性数据缺损比显式错误更难发现，因此长任务验收应检查输入是否缺字段、来源是否截断、验证信号是否充分。

Claude Code hooks 的 Stop hook 思路对本系统有参考意义：在停止前运行测试或状态检查，防止 agent 在未验证时结束。当前系统不照搬外部 hooks，而是将同类约束写入 `docs/assistant/pre-finish-check.md`、`docs/assistant/long-task-quality.md` 和本地校验脚本。

# paths

- `docs/assistant/automation-policy.md`
- `docs/assistant/long-task-quality.md`
- `docs/assistant/pre-finish-check.md`
- `templates/assistant/automation-review.md`
- `templates/assistant/long-task-state.md`

# links

- OpenAI Codex Automations: https://developers.openai.com/codex/app/automations
- OpenAI Codex Best Practices: https://developers.openai.com/codex/learn/best-practices
- OpenAI Codex Worktrees: https://developers.openai.com/codex/app/worktrees
- METR Measuring AI Ability to Complete Long Tasks: https://metr.org/blog/2025-03-19-measuring-ai-ability-to-complete-long-tasks/
- OpenAI BrowseComp: https://openai.com/index/browsecomp/
- Claude Code hooks guide: https://code.claude.com/docs/en/hooks-guide
- LongCLI-Bench: https://arxiv.org/abs/2602.14337
- OccuBench: https://arxiv.org/abs/2604.10866

# next_actions

- 对长任务默认使用 `templates/assistant/long-task-state.md` 的字段进行恢复记录。
- 对任何新自动化先使用 `templates/assistant/automation-review.md` 判断是否值得创建。
- 后续继续补充 Office、科研和编码任务的真实偏好采集样例。

