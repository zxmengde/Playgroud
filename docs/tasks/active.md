# Active Task

## Goal

根据用户反馈，将 Playgroud 从偏保守的确认模式调整为可信工作区高自主模式，并引入任务级授权或预授权表达。目标是让 Codex 在本仓库内直接完成可审计、可回退的文件操作、提交、推送和分支整理；对外部账号、发布、购买、长期服务、仓库外文件和可能敏感信息，用范围清楚的授权减少重复确认。

## Read Sources

- `AGENTS.md`
- `README.md`
- `docs/core/index.md`
- `docs/profile/user-model.md`
- `docs/profile/preference-map.md`
- `docs/references/assistant/codex-app-settings.md`
- `docs/user-guide.md`
- `scripts/codex-hook-risk-check.ps1`
- 用户关于 YOLO 与开放更多权限的反馈

## Commands

- `git status --short --branch`
- `rg -n "必须等待|均需确认|不执行高影响|需确认|仍需确认|必须确认|先确认|需要用户确认|用户确认后|前需要确认|前确认|确认边界|确认要求" AGENTS.md README.md docs scripts templates -S`
- Hook sample checks:
  - `Remove-Item -Recurse .\tmp` -> continue true
  - `Remove-Item -Recurse C:\Users\mengde\Desktop` -> blocked
  - `git reset --hard` -> blocked
- `pwsh.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\validate-system.ps1`
- `powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\validate-system.ps1`
- `powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\eval-agent-system.ps1`
- `git diff --check`

## Artifacts

- 更新 `AGENTS.md`、`docs/core/index.md`、`README.md`、`docs/user-guide.md`
- 更新 `docs/profile/user-model.md` 与 `docs/profile/preference-map.md`
- 更新 `docs/references/assistant/codex-app-settings.md`
- 调整 `scripts/codex-hook-risk-check.ps1`，允许可信工作区内相对路径或显式路径的删除命令，继续阻止仓库外危险命令
- 将高影响事项从“永久禁止放开”调整为“可任务级授权或预授权，但必须有对象、范围、预算或影响边界、有效期、验证和回退方式”

## Unverified

- 仍需运行最终完成度检查、提交和推送。

## Blockers

当前无阻塞。若 GitHub 推送失败，将先使用 `scripts/git-safe.ps1` 和 Git 网络诊断脚本定位。

## Next

提交前运行最终完成度检查，然后提交和推送：

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\check-finish-readiness.ps1 -Strict
git status --short --branch
```

## Recovery

从 `D:\Code\Playgroud` 恢复：

```powershell
git status --short --branch
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\validate-system.ps1
```

## Anti-Sycophancy

- Literal-only: 不只回应“我相信 Codex”，而是把偏好写入规则、偏好和 hook。
- Real-goal: 真实目标是减少用户介入，同时保持可审计和可恢复。
- User-premise: 用户认为限制过多；此判断与此前规则中多处硬确认文本一致，已改为预授权机制。
- Unverified-claims: 不声称可以保存或复述密钥、令牌、账号密码；不把对象、预算、影响范围或回退方式不清的外部影响动作写成默认自动执行。
