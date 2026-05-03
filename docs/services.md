# Services

本文件只记录可直接运行的原版外部服务入口。

## Vibe Kanban

来源：`BloopAI/vibe-kanban` npm 包。

启动：

```powershell
.\scripts\codex.ps1 vibe start -Port 3210
```

状态：

```powershell
.\scripts\codex.ps1 vibe status
```

停止：

```powershell
.\scripts\codex.ps1 vibe stop
```

默认访问：

```text
http://127.0.0.1:3210
```

运行态：

```text
.runtime/vibe-kanban/state.json
.runtime/vibe-kanban/stdout.log
.runtime/vibe-kanban/stderr.log
```

## ARIS Watchdog

来源：`wanshuiyin/Auto-claude-code-research-in-sleep` 原仓库。

安装或更新：

```powershell
.\scripts\codex.ps1 aris install
.\scripts\codex.ps1 aris update
```

启动后台 watchdog：

```powershell
.\scripts\codex.ps1 aris watchdog start -Interval 60
```

注册任务：

```powershell
.\scripts\codex.ps1 aris watchdog register -Name exp01 -Type training -Session exp01 -SessionType tmux -Gpus "0,1"
.\scripts\codex.ps1 aris watchdog register -Name dl01 -Type download -Session dl01 -SessionType tmux -TargetPath "/data/file"
```

状态：

```powershell
.\scripts\codex.ps1 aris watchdog status
```

停止：

```powershell
.\scripts\codex.ps1 aris watchdog stop
```

运行态：

```text
.runtime/aris/Auto-claude-code-research-in-sleep/
.runtime/aris/watchdog/
.runtime/aris/watchdog-state.json
.runtime/aris/watchdog-stdout.log
.runtime/aris/watchdog-stderr.log
```

ARIS watchdog 原版主要面向 Linux/远程实验环境，任务注册依赖 `tmux` 或 `screen` 会话。Windows 本机可以启动 watchdog；训练或下载任务监控通常应指向 WSL 或远程 Linux 会话。
