# Playgroud：受控的小型综合个人工作代理

本仓库用于把 Codex 组织为可执行、可恢复、可审计的小型综合个人工作代理，服务科研、文献、Zotero、视频资料、Office、网页、编码、知识沉淀、GitHub、MCP 和系统维护。

用户通常只需要表达目标。Codex 负责读取上下文、判断真实需求、执行工作、运行检查、记录状态，并在越过可信工作区授权或既有预授权边界时确认。

## 入口

- `AGENTS.md`：仓库入口和默认启动顺序。
- `docs/core/index.md`：核心协议、权限边界、执行循环、记忆恢复和停止前检查。
- `docs/profile/`：用户画像、偏好地图和偏好采集问题。
- `docs/tasks/active.md`：当前任务状态和恢复入口。
- `docs/workflows/`：科研、文献、办公、编码、网页、视频和知识沉淀流程。
- `docs/capabilities/index.md`：能力清单、成熟度、路线、缺口和精简门槛。
- `docs/knowledge/`：长期知识条目和分区索引。
- `docs/references/`：按需读取的背景材料、工具说明和迁移原则。
- `docs/archive/`：历史摘要。
- `docs/validation/`：代表性任务验收记录。
- `.agents/skills/`：仓库级 Codex 技能。
- `scripts/`：校验、审计、网络诊断和停止前检查脚本。
- `templates/`：知识、科研、办公、任务状态和复盘模板。

## 默认工作方式

复杂任务默认遵循：

1. 检查 Git 状态和任务状态。
2. 读取核心协议、用户画像和任务相关工作流。
3. 建立真实目标、成功标准、输入、输出、风险和验证方式。
4. 直接执行低风险工作，必要时只询问关键问题。
5. 产生产物、验证、知识记录或明确阻塞。
6. 运行停止前检查并记录剩余风险。

## 统一入口

常规任务优先使用统一入口，不直接调用 `scripts/lib/commands/` 下的私有实现：

```powershell
.\scripts\codex.ps1 doctor
.\scripts\codex.ps1 audit
.\scripts\codex.ps1 validate
.\scripts\codex.ps1 eval
.\scripts\codex.ps1 task recover
.\scripts\codex.ps1 context budget
.\scripts\codex.ps1 research smoke
.\scripts\codex.ps1 uiux smoke
.\scripts\codex.ps1 knowledge obsidian-dry-run
.\scripts\codex.ps1 capability map
```

安装本仓库本地 Git 提交前检查：

```powershell
.\scripts\codex.ps1 setup git-hooks
```

GitHub 代理诊断：

```powershell
.\scripts\codex.ps1 git ls-remote --heads origin main
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
