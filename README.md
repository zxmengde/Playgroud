# 受控的个人智能工作系统

本仓库是 Codex 在 Windows 环境中使用的个人智能工作系统控制仓库。它存放规则、工具登记、知识库、任务记录、模板、校验脚本和复盘记录。

## 入口

Codex 在本仓库工作时应先读取 `AGENTS.md`，再根据任务类型读取 `docs/assistant/` 和 `docs/workflows/` 下的对应文件。

## 目录

- `docs/assistant/`：系统目标、偏好、执行契约、权限、工具登记和复盘记录。
- `docs/workflows/`：科研、编码、办公、网页和知识沉淀流程。
- `docs/knowledge/`：长期知识条目和索引。
- `docs/tasks/`：当前任务、已完成任务和阻塞任务。
- `templates/`：科研、办公、编码、知识条目和复盘模板。
- `skills/`：与本机 Codex 技能组对应的可同步技能定义，便于云端 Codex 读取。
- `scripts/`：可复用的本地校验和辅助脚本。
- `output/`：验收或任务生成的输出文件。

## 校验

在 PowerShell 中运行：

```powershell
.\scripts\validate-system.ps1
```

该脚本检查必需结构、语言约束和潜在敏感信息。

## 权限

本仓库不保存密钥、令牌、账号密码。外部账号写入、发送消息、发布、购买、删除、覆盖和大规模移动文件前需要明确确认。
