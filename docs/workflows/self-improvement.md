# 自我改进工作流

适用于 `D:\Code\Playgroud` 内的系统级改进任务。默认顺序是：恢复上下文、识别 failure、判断是否需要 lesson、决定 promotion target、实施最小机制、运行 validators 和 evals、更新任务状态与 harness 摘要。

最小输入：

- `AGENTS.md`
- `docs/core/index.md`
- `docs/tasks/active.md`
- `docs/knowledge/system-improvement/routing-v1.yaml`
- `docs/knowledge/system-improvement/failures/`
- `docs/knowledge/system-improvement/lessons/`

最小输出：

- 结构化 failure 或 lesson
- 对应的 workflow、skill、hook、eval、validator、memory 或 MCP 变更
- `scripts/validate-system.ps1`、`scripts/eval-agent-system.ps1`、`scripts/check-finish-readiness.ps1 -Strict` 的结果

不要把自我改进误缩成仓库卫生。清理、压缩和脚本修复只有在服务于 failure、lesson、routing、memory、hook、eval 或 skill 时才算完成。
