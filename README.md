# Playgroud：受控的小型综合个人工作代理

本仓库用于把 Codex 组织为可执行、可恢复、可审计的小型综合个人工作代理，服务科研、文献、Zotero、视频资料、Office、网页、编码、知识沉淀、GitHub、MCP 和系统维护。

用户通常只需要表达目标。Codex 负责读取上下文、判断真实需求、执行低风险工作、运行检查、记录状态，并在需要高影响操作时确认。

## 入口

- `AGENTS.md`：仓库入口和默认启动顺序。
- `docs/core/`：核心协议和个人工作代理目标。
- `docs/profile/`：用户画像、偏好地图和偏好采集问题。
- `docs/tasks/active.md`：当前任务状态和恢复入口。
- `docs/workflows/`：科研、文献、办公、编码、网页、视频和知识沉淀流程。
- `docs/capabilities/`：能力清单、成熟度和缺口。
- `docs/knowledge/`：长期知识条目和分区索引。
- `docs/references/`：按需读取的背景材料、工具说明和迁移原则。
- `docs/validation/`：代表性任务验收记录。
- `skills/`：Codex 技能定义的同步副本。
- `scripts/`：校验、审计、网络诊断和停止前检查脚本。
- `templates/`：知识、科研、办公、任务状态和复盘模板。

## 默认工作方式

复杂任务默认遵循：

1. 检查 Git 状态和任务状态。
2. 读取五个核心协议、用户画像和任务相关工作流。
3. 建立真实目标、成功标准、输入、输出、风险和验证方式。
4. 直接执行低风险工作，必要时只询问关键问题。
5. 产生产物、验证、知识记录或明确阻塞。
6. 运行停止前检查并记录剩余风险。

## 校验

常规系统校验：

```powershell
.\scripts\validate-system.ps1
```

结构与验收校验：

```powershell
.\scripts\validate-doc-structure.ps1
.\scripts\validate-acceptance-records.ps1
```

重复和精简候选审计：

```powershell
.\scripts\audit-minimality.ps1
.\scripts\audit-redundancy.ps1
.\scripts\audit-file-usage.ps1
.\scripts\audit-active-references.ps1
```

插件和 MCP 本地可见性审计：

```powershell
.\scripts\audit-codex-capabilities.ps1
.\scripts\audit-mcp-config.ps1
.\scripts\audit-automations.ps1
.\scripts\audit-skill-sync.ps1
.\scripts\check-agent-readiness.ps1
```

同步仓库 skills 到用户级 Codex skills：

```powershell
.\scripts\sync-user-skills.ps1
```

新增 MCP 前生成评估记录：

```powershell
.\scripts\new-mcp-adoption-review.ps1 -Name "zotero-readonly"
```

记录待确认的系统改进候选：

```powershell
.\scripts\new-system-improvement-proposal.ps1 -Name "zotero-readonly"
.\scripts\audit-system-improvement-proposals.ps1
```

运行个人工作系统回归 eval：

```powershell
.\scripts\eval-agent-system.ps1
```

安装本仓库本地 Git 提交前检查：

```powershell
.\scripts\install-git-hooks.ps1
```

运行维护自动化同款检查：

```powershell
.\scripts\run-agent-maintenance.ps1
```

检查本机 Zotero 库基础状态：

```powershell
.\scripts\audit-zotero-library.ps1
```

停止前检查：

```powershell
.\scripts\check-finish-readiness.ps1
```

GitHub 代理诊断：

```powershell
.\scripts\test-git-network.ps1 -Proxy http://127.0.0.1:7897 -Remote origin
```

Codex shell 中普通 Git 命令遇到 Windows 网络环境缺项时，使用包装脚本：

```powershell
.\scripts\git-safe.ps1 pull --ff-only
.\scripts\git-safe.ps1 push
```

Codex App 本地环境设置建议见 `docs/references/assistant/codex-app-settings.md`。Windows 设置脚本可调用：

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File "$env:CODEX_WORKTREE_PATH\scripts\setup-codex-environment.ps1"
```

若需要检查 Python、Node、npm、npx、代理变量和 MCP 启动前置环境：

```powershell
.\scripts\test-codex-runtime.ps1
```

## 权限

可直接执行：读取文件、检索公开资料、创建草稿和知识条目、运行非破坏性检查、截图、渲染和整理任务记录。

需确认执行：删除、覆盖、大规模移动、外部账号写入、提交表单、发送消息、购买、发布、上传、保存敏感信息、修改系统配置或长期服务。

禁止执行：保存或复述密钥、令牌、账号密码；绕过系统或网站权限；运行来源不明的第三方 agent、skill、插件或泄露源码镜像。
