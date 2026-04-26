# 当前任务

## 当前目标

按用户继续要求，继续对 Playgroud 控制仓库做精简和能力补充：调研 Hermes、OpenClaw 和 Bilibili 视频技能仓库，安装可审查的视频技能，把可执行策略固化为 Codex App 设置建议、脚本检查和工作流规则。

## 已读来源

- `AGENTS.md`
- `docs/profile/user-model.md`
- `docs/core/self-configuration.md`
- `docs/capabilities/pruning-review.md`
- `docs/references/assistant/plugin-mcp-availability.md`
- `docs/references/assistant/agent-benchmark-integration.md`
- `docs/validation/v2-acceptance/*.md`
- `scripts/new-citation-checklist.ps1`
- `scripts/new-web-source-note.ps1`
- `scripts/check-ppt-text-extract.ps1`
- MCP 官方安全最佳实践和官方服务器资料。
- Hermes Agent 仓库、memory、skills、MCP 和 security 文档。
- OpenClaw 仓库、configuration、skills、workspace、doctor 文档和 2026-04-06 安全研究。
- `https://github.com/RookieCuzz/codex-bilibili-skills`
- `https://github.com/ysyecust/lecture-to-notes`
- `https://github.com/ZachZeng99/video-summary`
- `https://github.com/Wscats/bilibili-all-in-one`
- `https://github.com/VoltAgent/awesome-openclaw-skills`
- `docs/workflows/video.md`
- `skills/video-source-workflow/SKILL.md`
- `docs/references/assistant/bilibili-skill-evaluation.md`

## 已执行命令

- `git status --short --branch`
- `.\scripts\git-safe.ps1 pull --ff-only`
- `rg` 检查旧路径、`output/` 引用和相关脚本引用。
- `Get-ChildItem` 检查重复大小文件、空目录和大文件。
- `Select-String` 只读检查用户级 Codex 配置中的 MCP 服务器名称和 URL。
- `python ... list-skills.py --format json`，先失败于 DNS，再经代理环境修复后成功。
- `python ... install-skill-from-github.py` 安装 `security-best-practices`、`security-ownership-map`、`security-threat-model` 与 `jupyter-notebook`。
- `npm view @modelcontextprotocol/server-sequential-thinking version` 验证包可达。
- `npx -y @modelcontextprotocol/server-sequential-thinking --version` 启动到 stdio 监听后超时，说明包已可启动但作为 MCP 服务会持续等待协议输入。
- `git rm -r -- skills/personal-work-assistant` 删除旧技能同步副本。
- 移动用户级 `.codex\skills\personal-work-assistant` 到 `.codex\skills-disabled`。
- `.\scripts\audit-minimality.ps1`
- `.\scripts\check-agent-readiness.ps1 -Strict`
- `.\scripts\validate-system.ps1`
- `.\scripts\test-codex-runtime.ps1`
- `.\scripts\test-git-network.ps1 -Proxy http://127.0.0.1:7897 -Remote origin`
- 克隆并本地检查 `lecture-to-notes`、`codex-bilibili-skills`、`video-summary`、`bilibili-all-in-one`、`openclaw`、`hermes-agent` 和 `awesome-openclaw-skills`。
- `python -m py_compile` 检查 `codex-bilibili-skills` 的 Bilibili 脚本，通过。
- `python -m py_compile` 检查 `video-summary` 主脚本，失败于语法错误。
- 运行 Codex 官方技能安装脚本安装 Bilibili 技能，因 GitHub DNS 或网络栈错误失败。
- 使用已克隆并检查过的本地副本安装 `bilibili-video-evidence` 与 `video-note-writer` 到用户级 `.codex\skills`。
- `quick_validate.py` 校验两个新安装技能，通过。
- `python -m py_compile` 校验用户级安装后的 Bilibili Python 脚本，通过。

## 产物

- 删除版本化 `output/` 生成物。
- 删除本地空目录 `output/`、`output/doc/` 和多个空的 `skills/*/references/`。
- 更新 `.gitignore`，忽略 `output/`。
- 更新生成脚本，使默认输出目录不存在时自动创建。
- 更新 PPT 文本检查脚本，要求显式传入抽取结果路径。
- 更新验收记录，保留历史检查结论，不再依赖版本化样例文件。
- 新增 `templates/assistant/mcp-adoption-review.md`。
- 新增 `scripts/new-mcp-adoption-review.ps1`。
- 新增 `scripts/audit-mcp-config.ps1`。
- 新增 `docs/references/assistant/mcp-capability-plan.md`。
- 更新系统校验、文档结构校验、工具登记、MCP 可用性记录和精简审查。
- 新增 `docs/references/assistant/agent-benchmark-integration.md`。
- 新增 `scripts/audit-minimality.ps1`、`scripts/check-agent-readiness.ps1` 和 `scripts/test-codex-runtime.ps1`。
- 更新 `scripts/repair-git-network-env.ps1`，让 Git 代理同步到 Python、npm 和 MCP 常用环境变量。
- 用户级 `config.toml` 已备份并更新：新增 `sequentialThinking` MCP，补齐 Windows 与代理环境变量，关闭 `test-android-apps` 插件。
- 用户级新增 skills：`security-best-practices`、`security-ownership-map`、`security-threat-model` 与 `jupyter-notebook`。
- 删除仓库同步副本中的旧 `personal-work-assistant` 技能。
- 用户级新增视频 skills：`bilibili-video-evidence` 与 `video-note-writer`。
- 新增 `docs/references/assistant/bilibili-skill-evaluation.md`，记录七个候选仓库评估结果。
- 新增 `scripts/audit-video-skill-readiness.ps1`，检查 Bilibili 视频技能安装和本机依赖。
- 更新 `scripts/check-agent-readiness.ps1` 与 `scripts/validate-system.ps1`，把视频技能就绪检查纳入总体验证。
- 更新 `docs/workflows/video.md`、`skills/video-source-workflow/SKILL.md` 和 `docs/validation/v2-acceptance/video-source.md`，固定 Bilibili 两阶段流程。
- 更新 `docs/references/assistant/codex-app-settings.md`，补充常规、记忆、config.toml、MCP 和用户级视频技能设置建议。
- 更新工具登记、插件/MCP 可用性记录、能力清单、路线、精简审查和外部能力雷达。

## 未验证判断

- `sequentialThinking` MCP 已写入配置并验证 npm 包可达，但需要重启 Codex 后才会在新会话中稳定暴露工具。
- Zotero 或文献库只读 MCP 仍需用户确认数据目录、读取边界和是否允许 Web API。
- 生成脚本会在后续真实任务中继续产生被忽略的 `output/` 文件，默认不进入仓库。
- 新安装 skills 需要重启 Codex 才能进入新会话技能列表。
- Bilibili 视频技能已安装并通过结构校验，但尚未用真实 Bilibili URL 完成端到端摘要样例。
- `ffmpeg`、`yt-dlp` 和 `faster-whisper` 属于转写或课程讲义路径的可选依赖，是否安装需由后续真实任务决定。

## 阻塞

- 直接接入 Zotero、本地文档索引或外部账号类 MCP 需要进一步确认权限范围。
- 外部 MCP 市场状态会变化，安装前仍需按模板重新核验来源和权限。
- 不直接安装 OpenClaw 或 Hermes 作为常驻代理，因为会扩大本机执行面。
- GitHub 下载安装脚本在本机当前进程仍可能失败；本轮安装使用了已克隆并审查的本地副本。

## 下一步

运行视频技能就绪检查、系统校验、最小化审计、运行时检查、MCP 配置审计、Git 网络验证和停止前检查；通过后提交并推送。

## 恢复入口

从 `D:\Code\Playgroud` 恢复，先运行：

```powershell
git status --short --branch
.\scripts\audit-mcp-config.ps1
.\scripts\audit-minimality.ps1
.\scripts\audit-video-skill-readiness.ps1
.\scripts\check-agent-readiness.ps1
.\scripts\validate-system.ps1
.\scripts\check-finish-readiness.ps1
```

继续阅读 `docs/references/assistant/mcp-capability-plan.md`、`docs/references/assistant/plugin-mcp-availability.md`、`docs/references/assistant/agent-benchmark-integration.md` 和 `docs/capabilities/pruning-review.md`。

## 反迎合审查

- 是否只完成字面要求：没有。本轮把最小化、MCP、skills、运行时环境和外部 agent 研究落到脚本、配置和删除动作。
- 是否检查真实目标：真实目标是减少重复维护点，同时补充低风险能力并让策略可验证。
- 是否把用户粗略判断当作事实：没有。对“还不够精简”和“能力不足”采用审计脚本、安装记录和配置差异作为证据。
- 是否用流畅语言掩盖未验证结论：没有。明确记录新 MCP 和新 skills 都需要重启 Codex 才能在后续会话完全生效。
