# Active Task

## Status

二次整改实现与 smoke 验证已完成，待提交、严格收尾检查和推送。当前结果是顶层 `scripts/*.ps1` 从 58 个降为 3 个，并建立 `scripts/codex.ps1` 统一命令层、capability map、research state、run log 和多个可运行 smoke workflow。

## Last Updated

2026-05-02

## Goal

在 `D:\Code\Playgroud` 中完成二次整改：减少顶层脚本数量，合并重复 audit / validate / eval / check / hook / new / setup 入口，落地统一 capability map，并使 research、UI/UX、Obsidian knowledge、task recovery、context management、doctor/readiness、skill routing 和 failure lesson mechanism 至少有最小可运行入口。

## Read Sources

- `AGENTS.md`
- `README.md`
- `docs/core/index.md`
- `docs/profile/user-model.md`
- `docs/profile/preference-map.md`
- `docs/tasks/active.md`
- `docs/capabilities/index.md`
- `docs/references/assistant/external-mechanism-transfer.md`
- `docs/knowledge/system-improvement/routing-v1.yaml`
- `docs/knowledge/system-improvement/harness-log.md`
- `.codex/hooks.json`
- `scripts/`

## Commands

- `git status --short --branch`
- `Get-ChildItem scripts -Filter *.ps1`
- `rg "scripts/.+\.ps1" ...`
- `powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\codex.ps1 doctor`
- `powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\codex.ps1 audit`
- `powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\codex.ps1 validate`
- `powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\codex.ps1 eval`
- `powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\codex.ps1 research smoke`
- `powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\codex.ps1 uiux smoke`
- `powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\codex.ps1 knowledge obsidian-dry-run`
- `powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\codex.ps1 task recover`
- `powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\codex.ps1 context budget`
- `powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\codex.ps1 capability map`
- `powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\pre-commit-check.ps1`
- `git diff --check`

## Artifacts

- `scripts/codex.ps1`
- `scripts/pre-commit-check.ps1`
- `scripts/lib/commands/`
- `scripts/lib/self-improvement-object-lib.ps1`
- `docs/capabilities/capability-map.yaml`
- `docs/knowledge/research/research-state.yaml`
- `docs/knowledge/research/run-log.md`
- `.codex/hooks.json`

## Unverified

无。

## Blockers

无当前阻塞。GitHub 网络仍优先使用 `scripts/git-safe.ps1` 或 `scripts/codex.ps1 git ...` 路径。

## Next

1. 提交本轮改动。
2. 提交后运行 `scripts/lib/commands/check-finish-readiness.ps1 -Strict`。
3. 使用 `scripts/git-safe.ps1 push origin main` 推送。

## Recovery

从 `D:\Code\Playgroud` 恢复：

```powershell
git status --short --branch
Get-Content -Raw .\docs\tasks\active.md
.\scripts\codex.ps1 task recover
.\scripts\codex.ps1 context pack
.\scripts\codex.ps1 doctor
```

回滚本轮仓库改动优先使用 Git revert；用户级配置本轮不做新写入。

## Anti-Sycophancy

- Literal-only: 不把“统一入口”写成说明文件；必须能运行。
- Real-goal: 真实目标是减少重复脚本入口并保留验证能力。
- User-premise: 外部项目只贡献机制，不安装十套并行系统。
- Unverified-claims: 未跑 smoke test 的能力不得写成 active。
