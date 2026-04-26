# 当前任务

## 当前目标

按用户要求对 Playgroud 控制仓库进行进一步重构：明确 Codex 应成为怎样的同伴，补充自我设置协议，做减法减少重复画像和无效入口，做加法补齐 Codex App 设置、插件/MCP 选择规则和 Git 网络长期修复路径，并运行校验。

用户已进一步确认：执行长期本机 Git 修复脚本，把本轮仓库改造提交并推送，并给出截图对应的 Codex App 选项设置和官方插件安装建议。

## 已读来源

- `AGENTS.md`
- `README.md`
- `docs/core/*`
- `docs/profile/user-model.md`
- `docs/profile/preference-map.md`
- `docs/tasks/active.md`
- `docs/capabilities/*`
- `docs/references/assistant/git-network-troubleshooting.md`
- `docs/references/assistant/external-capability-radar.md`
- `docs/references/assistant/tool-registry.md`
- `scripts/test-git-network.ps1`
- `scripts/repair-git-network-env.ps1`
- 用户提供的 Codex App 设置截图，包括 Git、环境、MCP 和插件列表。

## 已执行命令

- `git status --short --branch`
- `Get-Content` 读取核心协议、能力路线、精简审查、Git 网络诊断、工具登记和现有脚本。
- `scripts/test-git-network.ps1 -Proxy http://127.0.0.1:7897 -Remote origin -TimeoutSeconds 20`
- `git config --show-origin --get-regexp "^(http|https)\..*proxy|^http\.proxy|^https\.proxy"`
- 直接 `git pull --ff-only` 复现 `Unknown error 10106`。
- `scripts/repair-git-network-env.ps1; git pull --ff-only` 验证修复后可拉取。
- `scripts/install-codex-git-network-fix.ps1 -SetUserEnvironment -SetGlobalGitProxy` 已执行，写入用户级 Windows 基础环境变量并设置全局 Git 代理为 `http://127.0.0.1:7897`。

## 产物

- `docs/core/self-configuration.md`
- `docs/references/assistant/codex-app-settings.md`
- `scripts/git-safe.ps1`
- `scripts/setup-codex-environment.ps1`
- `scripts/install-codex-git-network-fix.ps1`
- `scripts/audit-profile-duplication.ps1`
- 更新 `scripts/repair-git-network-env.ps1`
- 更新 `scripts/test-git-network.ps1`
- 更新 `scripts/validate-system.ps1`
- 更新 `scripts/check-finish-readiness.ps1`
- 更新 `scripts/validate-doc-structure.ps1`
- 更新 `AGENTS.md`
- 更新 `README.md`
- 更新 `skills/personal-work-assistant/references/user-profile.md`
- 更新 `docs/capabilities/pruning-review.md`
- 更新 `docs/capabilities/companion-roadmap.md`
- 更新 `docs/capabilities/index.md`
- 更新 `docs/references/assistant/tool-registry.md`
- 更新 `docs/references/assistant/git-network-troubleshooting.md`

## 未验证判断

- Codex App 的本地环境脚本需要用户在设置界面中配置后，才能验证新工作树是否自动应用。
- 长期 Git 修复脚本已执行，但新 Codex 进程是否继承用户环境变量需要重启 Codex 后再验证。
- 插件清单基于用户截图和当前已启用插件记录，未逐个联网核验市场插件的最新权限说明。
- 旧技能画像已收敛为指针，但 `docs/profile/user-model.md` 与 `docs/profile/preference-map.md` 仍需要继续作为两个主维护点并保持一致。

## 阻塞

- 长期本机 Git 网络修复已经按用户确认执行。剩余限制是需要重启 Codex 后验证新进程中的直接 Git 命令。
- 删除样例输出、旧文件或进一步合并画像属于本地数据删除或较大整理，执行前需要单独确认。

## 下一步

运行系统校验、Git 包装脚本验证、停止前检查，提交并推送本轮改造，并在最终回复中说明截图对应设置、插件建议、当前 Git 网络状态和仍需重启验证的事项。

## 恢复入口

从 `D:\Code\Playgroud` 恢复，先运行：

```powershell
git status --short --branch
.\scripts\git-safe.ps1 status --short --branch
.\scripts\validate-system.ps1
.\scripts\check-finish-readiness.ps1
```

继续阅读 `docs/core/self-configuration.md`、`docs/references/assistant/codex-app-settings.md` 和 `docs/references/assistant/git-network-troubleshooting.md`。

## 反迎合审查

- 是否只完成字面要求：本轮不只回答“会怎么改”，已新增协议、设置建议、脚本和校验入口。
- 是否检查真实目标：真实目标是得到更可执行、可恢复、可审计的个人工作代理，而不是批量安装插件或堆叠规则。
- 是否把用户粗略判断当作事实：用户要求长期解决 Git 网络问题，但系统级持久修改仍需确认；本轮先完成进程级修复和包装脚本。
- 是否用流畅语言掩盖未验证结论：已复现直接 Git 失败，也验证修复后可拉取；长期设置已执行，但新进程继承效果需要重启 Codex 后验证。
