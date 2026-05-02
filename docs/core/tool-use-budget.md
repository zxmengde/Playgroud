# Tool Use Budget

本规则用于限制用脚本、skill 或 MCP 替代判断。目标是保留必要验证，同时减少无关命令和上下文噪声。

## 默认预算

每个任务默认最多使用 3 类系统脚本：

1. 状态脚本：如 `git status`、任务恢复、必要目录统计。
2. 当前产物直接相关的验证脚本：只验证本次改动涉及的对象。
3. 收尾脚本：如 `scripts/codex.ps1 validate`、`scripts/codex.ps1 eval`、finish readiness。

超过预算时，必须在任务记录或最终报告说明原因。

## 脚本运行前问题

每次运行脚本前必须能回答：

- 它回答哪个具体不确定问题？
- 不运行它有什么风险？
- 输出会改变下一步行动吗？
- 是否有更便宜的方式，例如 `rg`、直接读文件或单个测试？

若输出不会改变下一步行动，不运行。

## 禁止模式

- 为了“熟悉仓库”批量运行 doctor、audit、validate、eval、context、capability、research、uiux、knowledge。
- 用 smoke pass 替代真实用户路径验证。
- 用 validate/eval 通过掩盖未交付产物。
- 因 routing 或 skill 名称自动打开 Serena、Browser、Obsidian、GitHub 或其它 MCP。

## 保留验证

收尾验证仍必须保留。复杂任务至少保留：

- `git status --short --branch`
- 与新增 validator 或当前产物直接相关的命令
- `scripts/codex.ps1 validate`
- `scripts/codex.ps1 eval`
- `git diff --check`

若某项不能运行，必须说明原因、剩余风险和可恢复命令。
