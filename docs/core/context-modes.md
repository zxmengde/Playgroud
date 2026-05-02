# Context Modes

上下文模式用于减少默认加载和工具误用。模式不是运行时服务，而是复杂任务开始前的选择表。

| mode | 触发条件 | 默认加载 | 禁止加载 | 退出条件 | 预算 | 验证要求 |
| --- | --- | --- | --- | --- | --- | --- |
| delivery | 多文件交付、仓库维护、提交前收尾 | `AGENTS.md`、`docs/core/index.md`、`docs/core/delivery-contract.md`、`docs/tasks/active.md`、相关 workflow | 外部仓库全文、无关 skill 示例、Serena 默认启动 | Done Criteria 满足且验证结果记录 | 3 类脚本，最多 2 个 skill | 产物、验证、任务状态、回滚说明 |
| research | 科研、外部机制、文献、证据整理 | 研究问题、`docs/workflows/research.md`、来源清单、必要外部证据 | 未验证结论写入长期 knowledge、批量下载、长期服务 | evidence gap 和下一步明确 | 2 类脚本，按需联网 | 来源、事实/推断区分、局限性 |
| audit | 目录、引用、能力状态、配置审计 | 目标文件、索引、相关 validator | 为熟悉仓库运行全套命令、读取无关 archive | 审计问题被修复或记录 | 目录/引用统计加一个验证脚本 | 统计、断链、回滚路径 |
| uiux | UI 改动或评审 | 页面/组件、`docs/workflows/uiux.md`、验收场景 | 只看代码下结论、无截图声称通过 | 桌面/移动端和状态证据齐备 | 浏览器/截图工具按需，最多 1 个 UI skill | screenshot、responsive、accessibility、interaction |
| coding | 代码实现、调试、测试 | 相关源码、测试入口、`docs/workflows/coding.md` | 默认 Serena、无关项目全量读取 | 测试或最小验证完成 | 状态、相关测试、收尾脚本 | 测试结果、diff、风险 |
| recovery | 恢复长任务或中断任务 | `docs/tasks/active.md`、`docs/tasks/board.md`、`scripts/codex.ps1 task recover` 输出 | 外部写入、重建无关上下文 | next action 清楚且阻塞记录 | 1 个恢复命令加必要文件读取 | checkpoint、resume summary、next action |

Serena 例外：只有符号引用、跨文件重构或文本检索失败时进入；启用前说明 CLI 为什么不够、要查什么、何时退出、如何避免重复 server 或弹窗。
