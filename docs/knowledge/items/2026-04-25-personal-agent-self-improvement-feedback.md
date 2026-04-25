---
title: 个人 Agent 自我改进反馈与落地记录
type: system-improvement
source: 当前用户反馈、仓库诊断、公开工具文档
tags: [agent, preference, zotero, video, git, cost]
status: active
paths:
  - docs/profile/user-model.md
  - docs/assistant/execution-contract.md
  - docs/assistant/cost-control.md
  - docs/assistant/git-network-troubleshooting.md
  - docs/assistant/capability-gap-review.md
  - docs/assistant/skill-audit.md
  - docs/workflows/literature-zotero.md
  - docs/workflows/video.md
  - skills/literature-zotero-workflow/SKILL.md
  - skills/video-source-workflow/SKILL.md
  - scripts/audit-skills.ps1
  - scripts/test-git-network.ps1
links:
  - https://www.zotero.org/support/dev/web_api/v3/start
  - https://www.zotero.org/support/zotero_data
  - https://retorque.re/zotero-better-bibtex/exporting/
  - https://github.com/yt-dlp/yt-dlp
  - https://github.com/yt-dlp/yt-dlp/blob/master/supportedsites.md
next_actions:
  - 在真实 Zotero 任务中采集数据目录、集合、标签、Better BibTeX 状态和引用格式偏好。
  - 在真实 Bilibili 或课程视频任务中验证字幕提取、时间戳摘要和归档方式。
  - 在用户确认后再处理系统级 loopback exemption 或全局 Git 代理配置。
---

# 摘要

用户反馈指出，Codex 仍存在过度按字面执行、迎合、主动性不足、输出过长、Zotero/文献和 Bilibili 视频能力不足、GitHub 网络反复失败等问题。本轮将这些反馈写入长期画像、执行规则、成本控制、专项工作流、技能和诊断脚本。

# 关键信息

已确认偏好：用户希望 Codex 不把用户观点默认视为正确前提，而是检查真实目标、证据、伪需求和更合适路径。用户希望减少无效 token 和费用，但不接受降低判断质量、验证深度或产物质量。

能力缺口：现有科研工作流覆盖文献检索和引用核验，但缺少 Zotero、本地 PDF、BibTeX/RIS、文献库只读读取和论文证据链专项流程。现有网页流程覆盖网页资料，但缺少 Bilibili、字幕、视频元数据、时间戳摘要和下载权限边界。

GitHub 网络诊断：本仓库本地 Git 配置已经设置 `http.proxy` 和 `https.proxy` 为 `http://127.0.0.1:7897`，但 `git ls-remote --heads origin` 失败为 `Unknown error 10106 (0x277a)`。当前 Codex 子进程无法通过 `curl` 连接 `127.0.0.1:7897`，说明问题不只是未设置 Git 代理。

# 事实、推断与不确定性

事实：已新增 `docs/assistant/cost-control.md`、`docs/assistant/git-network-troubleshooting.md`、`docs/assistant/capability-gap-review.md`、`docs/assistant/skill-audit.md`、`docs/workflows/literature-zotero.md`、`docs/workflows/video.md`、`skills/literature-zotero-workflow/`、`skills/video-source-workflow/`、`scripts/audit-skills.ps1` 和 `scripts/test-git-network.ps1`。

推断：GitHub 网络失败更可能与代理端口监听、Codex 打包应用 loopback 访问或当前 shell 网络栈有关，而不是单纯缺少 Git 代理配置。

不确定性：尚未确认本机 Zotero 数据目录、Better BibTeX 是否安装、用户常用文献集合和引用格式；尚未用真实 Bilibili 链接验证字幕获取路径；尚未在普通非 Codex PowerShell 中对比代理端口可达性。

补充诊断：`clash_verge_service` 服务运行，但普通 Codex 进程无法重启服务，返回 `Access is denied`。`curl` 无法连接 `127.0.0.1:7897`，`git` 经代理报 `Unknown error 10106 (0x277a)`，不经代理报 `getaddrinfo() thread failed to start`。WSL 检测显示当前没有可用发行版，不能作为现成替代路径。

# 来源

- 当前用户反馈，2026-04-25。
- 本地命令：`git config --show-origin --get-regexp ...`、`git ls-remote --heads origin`、`curl.exe --proxy http://127.0.0.1:7897 https://github.com`、`CheckNetIsolation LoopbackExempt -s`。
- Zotero Web API 文档：https://www.zotero.org/support/dev/web_api/v3/start
- Zotero 数据目录说明：https://www.zotero.org/support/zotero_data
- Better BibTeX 导出说明：https://retorque.re/zotero-better-bibtex/exporting/
- yt-dlp 项目与支持站点：https://github.com/yt-dlp/yt-dlp

# 后续事项

在后续真实任务中验证新技能触发是否准确。若用户确认，可进一步处理系统级 loopback exemption 或全局 Git 代理配置；若用户提供 Zotero 路径或 Bilibili 链接，可执行端到端样例并补充流程。
