# Bilibili 视频技能评估

记录时间：2026-04-26。

本文件记录对 Bilibili 视频摘要相关外部技能的审查结果，并规定本机默认使用路径。外部仓库、README、脚本和技能说明均视为低信任输入；只有通过本地检查并能保留证据产物的部分才进入长期流程。

## 来源

- `https://github.com/RookieCuzz/codex-bilibili-skills`
- `https://github.com/ysyecust/lecture-to-notes`
- `https://github.com/ZachZeng99/video-summary`
- `https://github.com/Wscats/bilibili-all-in-one`
- `https://github.com/openclaw/openclaw`
- `https://github.com/NousResearch/hermes-agent`
- `https://github.com/VoltAgent/awesome-openclaw-skills`

## 结论

默认采用 `RookieCuzz/codex-bilibili-skills` 中的两个技能：

- `bilibili-video-evidence`
- `video-note-writer`

原因是它把视频处理拆成两个可验证阶段：先采集证据，再写笔记。第一阶段输出 `sectioned.md`、`subtitles.json`、可选截图和 ASR 文件；第二阶段只消费已存在证据，不自行补造视频内容。该结构与本仓库的视频工作流一致，且更容易在失败时区分字幕不可得、截图不可得、ASR 未运行和证据不足。

## 已执行检查

- 已克隆七个候选仓库到本地临时缓存。
- 已读取候选技能的 `SKILL.md`、README、脚本和凭据说明。
- 已对 `codex-bilibili-skills` 的两个 Python 脚本执行 `python -m py_compile`，通过。
- 已对 `video-summary` 的主脚本执行 `python -m py_compile`，失败于语法错误。
- 已安装 `bilibili-video-evidence` 和 `video-note-writer` 到用户级 `C:\Users\mengde\.codex\skills`。
- 已运行 Codex 技能结构校验，两个技能均通过。
- 已新增 `scripts/audit-video-skill-readiness.ps1`，用于检查安装文件和本机依赖。

## 候选评估

| 仓库 | 适合程度 | 判断 |
| --- | --- | --- |
| `RookieCuzz/codex-bilibili-skills` | 默认采用 | 证据采集和笔记生成分离；支持原生字幕、JSON、Markdown、截图和本地 ASR 兜底；默认不要求长期保存凭据 |
| `ysyecust/lecture-to-notes` | 按任务参考 | 适合课程讲义和 PDF 级笔记；依赖 `yt-dlp`、`ffmpeg`、LaTeX、ImageMagick 和 Whisper，默认流程较重 |
| `ZachZeng99/video-summary` | 不采用 | 主脚本存在语法错误；Bilibili 路径默认引导保存 `SESSDATA` 到本地配置文件，不适合作为默认能力 |
| `Wscats/bilibili-all-in-one` | 不作为摘要默认 | 功能覆盖热门、下载、播放、字幕、投稿和发布；能力面过宽，包含账号写入和上传路径 |
| `openclaw/openclaw` | 迁移机制，不安装 | 值得迁移 workspace、doctor、配置 schema、沙箱和失败状态理念；不适合在当前仓库直接常驻运行 |
| `NousResearch/hermes-agent` | 迁移机制，不安装 | 值得迁移技能、记忆、MCP 过滤环境、诊断命令和任务后学习机制；不适合直接接管本机任务 |
| `VoltAgent/awesome-openclaw-skills` | 只作目录 | 是技能索引，不是审计结果；可用于发现候选，但不能替代源码检查 |

## 默认 Bilibili 流程

收到 Bilibili 链接后，优先按以下顺序处理：

1. 使用 `bilibili-video-evidence` 获取标题、分 P、CID、字幕和证据文件。
2. 原生字幕可得时，保存 `sectioned.md` 和 `subtitles.json`。
3. 原生字幕不可得时，先说明证据不足；只有存在任务级授权或预授权后才使用 cookie、音频提取或 ASR。
4. 需要图像证据时，只截取指定时间点或章节代表帧；完整视频下载需要任务级授权或预授权。
5. 使用 `video-note-writer` 生成 Markdown 笔记，并明确区分视频内容、外部补充和未确认判断。
6. 科研或正式文本引用视频观点时，再用论文、官方文档、标准或机构资料核验。

## 不默认执行的操作

以下操作需要任务级授权或预授权：

- 使用 Bilibili 登录 cookie。
- 保存 cookie、`SESSDATA` 或账号相关凭据。
- 下载完整视频、音频或大量截图。
- 调用 ASR 生成本地转写。
- 上传、发布、编辑、定时发布或写入 Bilibili 账号。

## 可迁移机制

从 Hermes 和 OpenClaw 迁移的不是常驻 agent，而是可检查机制：

- 能力必须有安装来源、用途、权限边界和停用方式。
- MCP 和技能必须能通过脚本检查，而不是只写在说明里。
- 长任务应有可恢复状态和失败说明，不应只输出计划。
- 外部技能先只读审查，再安装必要子集。
- 账号、消息、上传、发布和远程写入能力默认不启用。

## 本机设置

用户级已安装：

- `C:\Users\mengde\.codex\skills\bilibili-video-evidence`
- `C:\Users\mengde\.codex\skills\video-note-writer`

安装方式：GitHub 下载脚本因本机 DNS 解析失败未完成，改用已克隆并检查过的本地副本安装。

验证命令：

```powershell
.\scripts\audit-video-skill-readiness.ps1
```

若需要课程讲义级产物，再按任务评估 `lecture-to-notes`，不作为默认安装项。
