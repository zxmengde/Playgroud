# Playgroud

这是一个极简的 Codex 工作区控制仓库。保留的东西主要有四类：

- 当前任务状态：`docs/tasks/`
- 长期知识和研究队列：`docs/knowledge/`
- 原版外部服务启动入口：`scripts/codex.ps1 vibe ...` 和 `scripts/codex.ps1 aris ...`
- 项目级外部 skills：`.codex/skills/`
- 可直接调用的统一入口：`scripts/codex.ps1`

不再保留历史审计报告、fixture、复杂 validator、eval、hooks、skills 堆叠和外部仓库缓存。原版服务和上游仓库运行态放在 `.runtime/`，不提交进 Git。

## 快速入口

```powershell
.\scripts\codex.ps1 help
.\scripts\codex.ps1 task board
.\scripts\codex.ps1 task recover
.\scripts\codex.ps1 knowledge promotions
.\scripts\codex.ps1 research queue
.\scripts\codex.ps1 capability map
.\scripts\codex.ps1 vibe status
.\scripts\codex.ps1 aris watchdog status
```

外部 skills 已迁移为项目级 Codex skills，重启 Codex 后在本仓库内按任务自动触发：

```text
D:\Code\Playgroud\.codex\skills
```

原全局 active skills 已移到 `C:\Users\mengde\.codex\skills.disabled\2026-05-04-project-level-migration` 作为回滚副本。当前项目级 active skills 为 284 个；175 个 disabled 候选已逐个复判，结论见 `docs/skill-inventory-2026-05-04.json`，安装数量、CLI 命令和重复能力清单见 `docs/external-skills.md`。

## 外部机制已吸收的本地能力

### obsidian-skills -> knowledge promotion

默认先写仓库内 promotion ledger，不直接写外部 Obsidian vault。

```powershell
.\scripts\codex.ps1 knowledge promote -Id KP-20260503-001 -Source "note or file" -Status curated_note -Target repository -Evidence "source path" -NextAction "verify or archive"
.\scripts\codex.ps1 knowledge promotions
```

### vibe-kanban -> 原版 Web 服务

需要真实 kanban UI 时，直接运行原版 `npx vibe-kanban` 服务。运行态日志和 pid 写到 `.runtime/vibe-kanban/`。

```powershell
.\scripts\codex.ps1 vibe start -Port 3210
.\scripts\codex.ps1 vibe status
.\scripts\codex.ps1 vibe stop
```

默认地址：

```text
http://127.0.0.1:3210
```

### Auto-claude-code-research-in-sleep -> 原版 ARIS watchdog 后台能力

ARIS 原仓库会克隆到 `.runtime/aris/Auto-claude-code-research-in-sleep/`。后台能力使用上游 `tools/watchdog.py`，不是 Markdown 队列替代。

```powershell
.\scripts\codex.ps1 aris install
.\scripts\codex.ps1 aris watchdog start -Interval 60
.\scripts\codex.ps1 aris watchdog status
.\scripts\codex.ps1 aris watchdog register -Name exp01 -Type training -Session exp01 -SessionType tmux -Gpus "0,1"
.\scripts\codex.ps1 aris watchdog stop
```

说明：ARIS watchdog 原版主要面向 Linux/远程实验环境，注册任务时依赖 `tmux` 或 `screen` 会话。Windows 本机可以启动 watchdog，但训练/下载任务监控通常应指向 WSL 或远程 Linux 会话。

## 目录

```text
AGENTS.md
README.md
docs/
  capabilities.md
  core.md
  external-skills.md
  profile.md
  services.md
  workflows.md
  tasks/
    active.md
    attempts.md
    board.md
  knowledge/
    promotion-ledger.md
    research-queue.md
    research-run-log.md
.codex/
  skills/
    vibe-kanban-service/
    aris-watchdog-service/
    workspace-state-workflow/
    context-mode-command-adapters/
    omx-visual-verdict/
    omx-visual-ralph/
scripts/
  codex.ps1
  git-safe.ps1
  pre-commit-check.ps1
```
