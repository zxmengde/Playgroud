# Active Task

## Status

正在执行 Codex 交付能力去官僚化、外部机制内化和目录去水整改。本轮不是新增大型框架，而是把 10 个外部项目的机制写成可触发、可验证、可回滚的本地能力，同时清理缓存、任务状态、help、hook 文档和能力成熟度漂移。

## Last Updated

2026-05-03

## Goal

在 `D:\Code\Playgroud` 内完成以下可审计产物：

- 10 张 external adoption cards，至少 8 项为 adopted 或 partial。
- capability map 使用 declared / smoke_passed / task_proven / user_proven / experimental / deprecated。
- delivery contract、tool budget、skill/MCP 使用政策和 context modes 接入启动顺序。
- 真实任务 eval 规格接入 validate 或 eval。
- `.cache/external-repos` 清理并提供 `cache status` / `cache clean-external-repos`。
- active task、help、hook risk stdin 文档和 README / AGENTS / core index 对齐。
- 运行指定验证链并写最终整改报告。

## Done Criteria

- `docs/capabilities/external-adoptions.md` 覆盖 10 个外部项目，且 validator 通过。
- `docs/capabilities/capability-map.yaml` 不再使用旧 `status: active`。
- `scripts/lib/commands/validate-delivery-system.ps1` 接入 `scripts/codex.ps1 validate` 和 `scripts/codex.ps1 eval`。
- 目录统计有整改前后对比，缓存噪声已清理或阻塞已记录。
- `scripts/codex.ps1 help` 列出 `git` 和 `cache`。
- hook risk 标准输入 JSON smoke 示例存在。
- 最终运行 `git status --short --branch`、新增 validator、`validate`、`eval`、`git diff --check`。

## Hidden Obligations

- 清理未跟踪树输出和一次性 report 噪声。
- 删除 `.agents/skills/*` 下空目录。
- 同步 README、AGENTS、core index、workflow、capability index 和 task board。
- 不把 smoke 写成真实任务证明。
- 不默认启用 Serena 或其它会制造上下文噪声的 MCP。

## Read Sources

- `AGENTS.md`
- `README.md`
- `docs/core/index.md`
- `docs/core/delivery-contract.md`
- `docs/tasks/active.md`
- `docs/tasks/board.md`
- `docs/knowledge/system-improvement/routing-v1.yaml`
- `docs/capabilities/capability-map.yaml`
- `docs/capabilities/external-adoptions.md`
- `scripts/codex.ps1`

## Commands

- `git status --short --branch`
- `powershell -NoProfile -ExecutionPolicy Bypass -File scripts\codex.ps1 cache status`
- `powershell -NoProfile -ExecutionPolicy Bypass -File scripts\codex.ps1 cache clean-external-repos`
- `powershell -NoProfile -ExecutionPolicy Bypass -File scripts\lib\commands\validate-delivery-system.ps1`
- `powershell -NoProfile -ExecutionPolicy Bypass -File scripts\codex.ps1 validate`
- `powershell -NoProfile -ExecutionPolicy Bypass -File scripts\codex.ps1 eval`
- `git diff --check`

## Artifacts

- `docs/core/delivery-contract.md`
- `docs/core/tool-use-budget.md`
- `docs/core/skill-use-policy.md`
- `docs/core/context-modes.md`
- `docs/core/typed-object-registry.md`
- `docs/capabilities/external-adoptions.md`
- `docs/validation/real-task-evals.md`
- `docs/tasks/board.md`
- `docs/knowledge/research/research-queue.md`
- `scripts/lib/commands/validate-delivery-system.ps1`
- `docs/Codex-交付能力去官僚化与外部机制内化整改报告.md`

## Unverified

- 最终 validate / eval / diff 检查尚未运行。
- 推送尚未执行。

## Blockers

无当前阻塞。若 GitHub 网络失败，使用 `scripts/git-safe.ps1` 或 `scripts/codex.ps1 git ...` 记录错误并保留恢复命令。

## Next

1. 完成脚本、validator、文档和目录清理。
2. 清理 `.cache/external-repos`、`list.txt` 和一次性 report。
3. 运行验证链，修复失败或记录阻塞。
4. 写最终整改报告、提交并推送。

## Recovery

```powershell
git status --short --branch
Get-Content -Raw .\docs\tasks\active.md
Get-Content -Raw .\docs\tasks\board.md
.\scripts\codex.ps1 task recover
.\scripts\codex.ps1 cache status
```

回滚优先使用 Git revert；未提交前可按最终报告的新增文件、修改文件和删除清单逐项恢复。

## Anti-Sycophancy

- Literal-only: 不把“外部项目已研究”写成已内化；必须有 local artifact、trigger、behavior delta、verification 和 rollback。
- Real-goal: 真实目标是未来 Codex 行为变化、目录去水和状态对齐，不是新增说明文件。
- User-premise: 外部项目贡献机制，不安装十套并行运行时。
- Unverified-claims: sample smoke 只能写成 smoke_passed，不能写成 task_proven 或 user_proven。
