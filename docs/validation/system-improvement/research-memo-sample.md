# Research Memo

## Question

Serena 是否能降低控制仓库外真实代码库中的跨文件定位成本。

## Why This Matters

当前文本检索在符号级重构任务中容易造成上下文浪费。

## Sources

- 官方安装说明
- 项目源码
- 当前仓库的 `routing-v1.yaml`

## Facts

- 当前仓库尚未安装 Serena。
- `routing-v1.yaml` 已把 Serena 定义为 pilot candidate。

## Inferences

- 若 pilot 通过，Serena 有望改善跨文件定位与引用查找效率。

## Uncertainty

- 真实收益需要在目标代码仓库中验证。

## Experiment / Verification Plan

- 选择一个真实代码仓库。
- 对比 `rg + read` 与 Serena 只读导航的步数和错误率。

## Decision

- 当前维持 pilot candidate，不直接默认安装。

## What Should Be Remembered

- Serena 的只读阶段和编辑阶段必须分离。
