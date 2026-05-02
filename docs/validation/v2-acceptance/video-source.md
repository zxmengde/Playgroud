# 视频资料验收

## 输入

- `docs/workflows/video.md`
- 用户级 `video-source-workflow` skill

## 执行路径

视频任务应先记录 URL、标题、平台、访问日期、字幕来源和是否需要登录。若视频需要账号、验证码、付费或读取个人观看记录，应停止并确认。可公开访问的视频应优先提取字幕、时间戳和可核查片段，再形成摘要。

Bilibili 默认走两阶段路径：先用用户级 `bilibili-video-evidence` 生成 `sectioned.md`、`subtitles.json` 和可选截图；再用 `video-note-writer` 从已有证据生成 Markdown 笔记。若字幕缺失，不能直接宣称已经理解视频内容；登录 cookie、音频提取、ASR 和完整视频下载需要任务级授权或预授权。

## 产物

- `docs/workflows/video.md`
- 用户级 `video-source-workflow` skill
- `docs/capabilities/index.md` 中的视频资料能力项。
- `docs/references/assistant/bilibili-skill-evaluation.md`
- `scripts/lib/commands/audit-video-skill-readiness.ps1`

## 验证

- `scripts/lib/commands/validate-skills.ps1` 验证视频技能结构。
- `scripts/lib/commands/audit-skills.ps1` 检查视频技能具备产物和验证段落。
- `scripts/lib/commands/audit-video-skill-readiness.ps1` 检查用户级 Bilibili 技能安装和本机依赖。
- `scripts/lib/commands/validate-acceptance-records.ps1` 检查本验收记录完整。

## 复盘

视频能力容易把“能总结”误认为“能核验”。v2 中应把字幕来源、时间戳抽查和事实不确定性作为默认字段，而不是只输出概括。

## 边界

本轮未打开用户个人 Bilibili 账号，也未读取观看历史。真实视频任务需要用户提供公开 URL 或明确授权的本地字幕、音视频文件。已安装的 Bilibili 技能默认不应保存 `SESSDATA` 或完整浏览器 cookie；如必须使用，应作为单次任务输入并在结束后清理。
