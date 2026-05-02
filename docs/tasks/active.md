# Active Task

## Status

正在继续执行 Codex 自我改进与能力提升。本轮重点是补全上一轮仍偏弱的 obsidian-skills、vibe-kanban、Auto-claude-code-research-in-sleep adoption，把它们落到 promotion ledger、task attempt、research queue/review gate 和统一入口命令。

## Last Updated

2026-05-03

## Goal

在 `D:\Code\Playgroud` 内完成以下可审计产物：

- `obsidian-skills` 从 partial 升级为有 `knowledge promote|promotions` 和 `docs/knowledge/promotion-ledger.md` 的 adopted 机制。
- `vibe-kanban` 从 partial 升级为有 `task board|attempt|recover` 和 `docs/tasks/attempts.md` 的 adopted 机制。
- `Auto-claude-code-research-in-sleep` 从 partial 升级为有 `research queue|enqueue|review-gate` 和 run log 的 adopted 机制。
- 合并过细 eval 脚本，保持顶层脚本数量不超过 3 个，私有命令继续通过 `scripts/codex.ps1` 统一入口调用。
- skill policy 明确 adopted mechanism 的默认 workflow/checklist load，以及 “任务触发 -> skill -> eval -> lesson” 闭环。
- capability map、adoption cards、help、validator、README、knowledge index 和 task board 同步。

## Done Criteria

- 三个目标 adoption 均为 adopted，且每项都有 local artifact、trigger、behavior delta、verification 和 rollback。
- `validate-delivery-system.ps1` 检查 promotion ledger、task attempts、research queue/review gate、help 入口和 capability 绑定。
- `scripts/codex.ps1 help` 列出新增 task、knowledge、research 子命令，且这些子命令至少完成目标化 smoke。
- `scripts/lib/commands` 中四个过细 eval 脚本已合并为 `eval-task-quality.ps1`，旧引用清零。
- `.cache/external-repos` 为 absent 或空状态。
- 最终运行 `git status --short --branch`、相关 validator、`scripts/codex.ps1 validate`、`scripts/codex.ps1 eval`、`git diff --check`、`check-finish-readiness.ps1 -Strict`。

## Hidden Obligations

- 不能用 “partial 但已有说明” 替代可调用 artifact。
- 长期任务必须可 checkpoint、resume、next-action 和 stale detection。
- research queue 不能伪装为后台服务或无人值守 runtime。
- 合并脚本后必须同步所有引用与 validator。
- 不默认启用 Serena 或其它会制造上下文噪声的 MCP。

## Read Sources

- `AGENTS.md`
- `README.md`
- `docs/core/index.md`
- `docs/tasks/active.md`
- `docs/tasks/board.md`
- `docs/tasks/attempts.md`
- `docs/knowledge/system-improvement/routing-v1.yaml`
- `docs/knowledge/promotion-ledger.md`
- `docs/knowledge/research/research-queue.md`
- `docs/capabilities/capability-map.yaml`
- `docs/capabilities/external-adoptions.md`
- `scripts/codex.ps1`

## Commands

- `git status --short --branch`
- `powershell -NoProfile -ExecutionPolicy Bypass -File scripts\codex.ps1 cache status`
- `powershell -NoProfile -ExecutionPolicy Bypass -File scripts\codex.ps1 help`
- `powershell -NoProfile -ExecutionPolicy Bypass -File scripts\codex.ps1 task board`
- `powershell -NoProfile -ExecutionPolicy Bypass -File scripts\codex.ps1 knowledge promotions`
- `powershell -NoProfile -ExecutionPolicy Bypass -File scripts\codex.ps1 research queue`
- `powershell -NoProfile -ExecutionPolicy Bypass -File scripts\lib\commands\validate-delivery-system.ps1`
- `powershell -NoProfile -ExecutionPolicy Bypass -File scripts\codex.ps1 validate`
- `powershell -NoProfile -ExecutionPolicy Bypass -File scripts\codex.ps1 eval`
- `git diff --check`

## Artifacts

- `docs/capabilities/external-adoptions.md`
- `docs/capabilities/capability-map.yaml`
- `docs/core/skill-use-policy.md`
- `docs/core/typed-object-registry.md`
- `docs/knowledge/promotion-ledger.md`
- `docs/knowledge/research/research-queue.md`
- `docs/tasks/board.md`
- `docs/tasks/attempts.md`
- `scripts/codex.ps1`
- `scripts/lib/commands/validate-delivery-system.ps1`
- `scripts/lib/commands/eval-task-quality.ps1`

## Unverified

- 最终 validate / eval / strict finish / diff 检查尚未运行。
- 推送尚未执行。

## Blockers

无当前阻塞。若 GitHub 网络失败，使用 `scripts/git-safe.ps1` 或 `scripts/codex.ps1 git ...` 记录错误并保留恢复命令。

## Next

1. 复跑完整验证链，确认 whitespace、validate、eval 均通过。
2. 查看最终 diff 与 git status。
3. 提交并推送。
4. 推送后确认工作区和远程状态。

## Recovery

```powershell
git status --short --branch
Get-Content -Raw .\docs\tasks\active.md
Get-Content -Raw .\docs\tasks\board.md
.\scripts\codex.ps1 task recover
.\scripts\codex.ps1 task board
.\scripts\codex.ps1 knowledge promotions
.\scripts\codex.ps1 research queue
.\scripts\codex.ps1 cache status
```

回滚优先使用 Git revert；未提交前可按最终报告的新增文件、修改文件和删除清单逐项恢复。

## Anti-Sycophancy

- Literal-only: 不把“外部项目已研究”写成已内化；必须有 local artifact、trigger、behavior delta、verification 和 rollback。
- Real-goal: 真实目标是未来 Codex 行为变化、目录去水和状态对齐，不是新增说明文件。
- User-premise: 外部项目贡献机制，不安装十套并行运行时。
- Unverified-claims: sample smoke 只能写成 smoke_passed，不能写成 task_proven 或 user_proven。
