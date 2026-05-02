# Research Memo

## Question

Serena 接通后是否能降低真实代码库中的跨文件定位成本。

## Why This Matters

当前文本检索在符号级重构任务中容易造成上下文浪费。

## Sources

- 官方安装说明
- 项目源码
- 当前仓库的 `routing-v1.yaml`

## Facts

- 当前用户级 Codex 配置已有 Serena MCP 条目，入口为本机 `serena` 命令。
- `scripts/lib/commands/audit-serena-obsidian-readiness.ps1` 能验证 `serena --version` 和本地 MCP smoke。
- `routing-v1.yaml` 已把 Serena 标为 enabled，并要求先使用只读导航。

## Inferences

- Serena 有望改善跨文件定位与引用查找效率，但真实收益仍需要在具体代码仓库中测量。

## Uncertainty

- 真实收益需要在目标代码仓库中验证。

## Experiment / Verification Plan

- 选择一个真实代码仓库。
- 对比 `rg + read` 与 Serena 只读导航的步数和错误率。

## Decision

- 采用只读导航与引用查找；编辑阶段按真实任务另行验证。

## What Should Be Remembered

- Serena 的只读阶段和编辑阶段必须分离。
