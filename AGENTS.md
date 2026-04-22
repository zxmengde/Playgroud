# 受控的个人智能工作系统入口

本目录是 Codex 个人智能工作系统的控制仓库。进入该目录工作时，应把这里的规则、工具登记、知识库、任务记录和复盘记录视为本地事实来源。

## 必读文件

开始复杂任务前，优先读取：

- `docs/assistant/overview.md`
- `docs/assistant/preferences.md`
- `docs/assistant/execution-contract.md`
- `docs/assistant/permissions.md`
- `docs/assistant/tool-registry.md`

任务涉及科研、编码、办公、网页或知识沉淀时，同时读取相应工作流程：

- `docs/workflows/research.md`
- `docs/workflows/coding.md`
- `docs/workflows/office.md`
- `docs/workflows/web.md`
- `docs/workflows/knowledge.md`

云端 Codex 无法读取本机用户级 `.codex` 目录时，应读取仓库内 `skills/` 下的同名技能定义。该目录是本机 Codex 技能组的可同步副本。

## 工作约定

默认使用简体中文。表达应客观、严谨、平实、克制、专业、冷静、中立。

任务目标明确时，应直接执行可执行工作，包括读取文件、检索资料、生成文件、修改代码、运行检查、渲染文档、整理知识条目和记录结果。不得用泛泛建议替代可执行工作。

允许按顺序拆解复杂任务，但拆解只服务于持续推进。每次工作应尽量到达可交付产物、验证结果或明确阻塞。

遇到用户指出工作方式、语气、验证或执行深度不符合偏好时，应更新 `docs/assistant/harness-log.md`，并同步修正相关规则、技能或模板。

## 安全边界

不得保存或复述密钥、令牌、账号密码。删除、覆盖、大规模移动、外部提交、发送消息、购买、发布、长期服务安装和外部账号写入前必须确认。
