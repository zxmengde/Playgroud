# External Mechanism Review Sample

## Question

是否应为跨文件重构任务引入 Serena。

## Candidate

- Serena

## Mechanisms

- 符号级导航
- 引用查找
- 只读 pilot

## Evidence

- 假定已读取关键源码与安装说明
- 与当前 `rg + read` 基线进行对比

## Minimum Implementation

- 先只读 pilot
- 仅在 pilot 通过后评估编辑阶段

## Re-evaluation

- 若三个真实任务没有明显收益，则继续维持 candidate 状态
