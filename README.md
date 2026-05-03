# Playgroud：受控的小型综合个人工作代理

本仓库用于把 Codex 组织为可执行、可恢复、可审计的小型综合个人工作代理，服务科研、文献、Zotero、视频资料、Office、网页、编码、知识沉淀、GitHub、MCP 和系统维护。

用户通常只需要表达目标。Codex 负责读取上下文、判断真实需求、执行工作、运行检查、记录状态，并在越过可信工作区授权或既有预授权边界时确认。

## 入口

- `AGENTS.md`：仓库入口和默认启动顺序。
- `docs/core/index.md`：核心协议、权限边界、执行循环、记忆恢复和停止前检查。
- `docs/core/delivery-contract.md`：复杂任务开始前的交付合同。
- `docs/core/adoption-proof-standard.md`：外部机制内化证据标准和状态枚举。
- `docs/core/tool-use-budget.md`：脚本、skill 和 MCP 使用预算。
- `docs/core/context-modes.md`：delivery、research、audit、uiux、coding、recovery 模式。
- `docs/profile/`：用户画像、偏好地图和偏好采集问题。
- `docs/tasks/active.md`：当前任务状态和恢复入口。
- `docs/tasks/board.md`：active、next、blocked、done、checkpoint 和 resume summary。
- `docs/workflows/`：科研、文献、办公、编码、网页、视频和知识沉淀流程。
- `docs/capabilities/index.md`：能力清单、成熟度、路线、缺口和精简门槛。
- `docs/capabilities/external-adoptions.md`：外部项目机制的本地 adoption cards。
- `docs/knowledge/`：长期知识条目和分区索引。
- `docs/references/`：按需读取的背景材料、工具说明和迁移原则。
- `docs/archive/`：历史摘要。
- `docs/validation/`：代表性任务验收记录和 adoption proof fixture。
- `.agents/skills/`：仓库级 Codex 技能。
- `scripts/`：校验、审计、网络诊断和停止前检查脚本。
- `templates/`：知识、科研、办公、任务状态和复盘模板。

## 默认工作方式

复杂任务默认遵循：

1. 检查 Git 状态和任务状态。
2. 读取 active task、task board、核心协议和用户画像。
3. 按 `docs/core/delivery-contract.md` 建立真实目标、完成证据、隐性责任、风险和验证方式。
4. 再选择最小必要 workflow、skill、MCP 和脚本。
5. 直接执行低风险工作，必要时只询问关键问题。
6. 产生产物、验证、知识记录或明确阻塞。
7. 运行停止前检查并记录剩余风险。

## 统一入口

常规任务优先使用统一入口，不直接调用 `scripts/lib/commands/` 下的私有实现：

```powershell
.\scripts\codex.ps1 doctor
.\scripts\codex.ps1 audit
.\scripts\codex.ps1 validate
.\scripts\codex.ps1 eval
.\scripts\codex.ps1 task board
.\scripts\codex.ps1 task attempt -Id ATT-YYYYMMDD-001 -TaskId TASK-YYYYMMDD-name -Status running -Checkpoint "..." -NextAction "..."
.\scripts\codex.ps1 task recover
.\scripts\codex.ps1 context budget
.\scripts\codex.ps1 research queue
.\scripts\codex.ps1 research enqueue -Id RQ-YYYYMMDD-001 -Question "..." -State queued
.\scripts\codex.ps1 research review-gate -Id RQ-YYYYMMDD-001 -Decision review_needed
.\scripts\codex.ps1 research smoke
.\scripts\codex.ps1 uiux smoke
.\scripts\codex.ps1 knowledge promote -Id KP-YYYYMMDD-001 -Source "..." -Status curated_note -Target repository
.\scripts\codex.ps1 knowledge promotions
.\scripts\codex.ps1 knowledge obsidian-dry-run
.\scripts\codex.ps1 capability map
.\scripts\codex.ps1 git status --short
.\scripts\codex.ps1 cache status
```

安装本仓库本地 Git 提交前检查：

```powershell
.\scripts\codex.ps1 setup git-hooks
```

GitHub 代理诊断：

```powershell
.\scripts\codex.ps1 git ls-remote --heads origin main
```

外部研究缓存清理：

```powershell
.\scripts\codex.ps1 cache status
.\scripts\codex.ps1 cache clean-external-repos
```

Codex shell 中普通 Git 命令遇到 Windows 网络环境缺项时，使用包装脚本：

```powershell
.\scripts\git-safe.ps1 pull --ff-only
.\scripts\git-safe.ps1 push
```

Codex App 本地环境设置建议见 `docs/references/assistant/codex-app-settings.md`。Windows 设置脚本可调用：

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File "$env:CODEX_WORKTREE_PATH\scripts\codex.ps1" setup environment
```

若需要检查 Python、Node、npm、npx、代理变量和 MCP 启动前置环境：

```powershell
.\scripts\codex.ps1 doctor
```

## 权限

可直接执行：读取文件、检索公开资料、创建草稿和知识条目、运行检查、截图、渲染和整理任务记录。

在 `D:\Code\Playgroud` 内默认采用高自主模式。Codex 可直接执行可审计、可回退的创建、修改、删除、覆盖、移动、批量重命名、提交、推送和分支整理。

需要任务级授权或预授权：仓库外不可逆删除或覆盖、外部账号写入、提交表单、发送消息、购买、发布、上传、保存敏感信息、修改系统配置或长期服务。授权范围不清时，Codex 应先准备方案、命令和风险说明，停在实际执行前。

禁止执行：保存或复述密钥、令牌、账号密码；绕过系统或网站权限；运行来源不明的第三方 agent、skill、插件或泄露源码镜像；在对象、预算、影响范围或回退方式不清时执行资金支出、公开发布、账号权限变更、仓库外不可逆删除或长期服务启用。

普通文件读取、grep、git 和简单修改不使用 Serena。只有真实代码导航、符号引用或跨文件重构时才启用 Serena，并在启用前说明 CLI 为什么不够、查询内容、退出条件和避免重复 server 的方式。

外部机制状态以 `docs/core/adoption-proof-standard.md` 为准。`adopted` 不再作为状态使用；只有有非自指 evidence、integration proof、validator 语义检查和回滚路径的机制，才能写成 `integration_tested` 或更高等级。`task_used` 必须指向真实任务 trace，例如 `docs/validation/operational-acceptance-trace.md`；不得把 fixture proof 写成用户确认。
