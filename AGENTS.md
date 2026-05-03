# Playgroud 工作规则

始终使用简体中文，语气客观、直接、克制。

本仓库只保留少数工作入口。复杂任务先看：

1. `git status --short --branch`
2. `README.md`
3. `docs/core.md`
4. `docs/tasks/active.md`

默认不启动 Serena、MCP、浏览器、Obsidian 或后台服务。用户明确要求原版服务或后台运行时，可以使用 `scripts/codex.ps1 vibe ...` 和 `scripts/codex.ps1 aris watchdog ...` 启停。普通文件读取、搜索、修改和 Git 操作用 CLI 完成。

## 权限边界

`D:\Code\Playgroud` 内可直接读取、修改、删除、移动和整理文件。仓库外不可逆删除、外部账号写入、发布、购买、系统级配置和敏感信息保存需要用户确认。

## 本地能力

- task：`scripts/codex.ps1 task board|attempt|recover`
- knowledge：`scripts/codex.ps1 knowledge promote|promotions`
- research：`scripts/codex.ps1 research queue|enqueue|review-gate|run-log`
- vibe-kanban：`scripts/codex.ps1 vibe start|status|stop`
- ARIS watchdog：`scripts/codex.ps1 aris install|watchdog start|watchdog status|watchdog stop`
- git：`scripts/codex.ps1 git <args>`

不要用脚本、验证和报告替代实际交付。需要检查时，只跑与当前改动直接相关的最小命令。
