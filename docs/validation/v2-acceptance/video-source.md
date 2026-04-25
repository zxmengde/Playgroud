# 视频资料验收

## 输入

- `docs/workflows/video.md`
- `skills/video-source-workflow/SKILL.md`

## 执行路径

视频任务应先记录 URL、标题、平台、访问日期、字幕来源和是否需要登录。若视频需要账号、验证码、付费或读取个人观看记录，应停止并确认。可公开访问的视频应优先提取字幕、时间戳和可核查片段，再形成摘要。

## 产物

- `docs/workflows/video.md`
- `skills/video-source-workflow/SKILL.md`
- `docs/capabilities/index.md` 中的视频资料能力项。

## 验证

- `scripts/validate-skills.ps1` 验证视频技能结构。
- `scripts/audit-skills.ps1` 检查视频技能具备产物和验证段落。
- `scripts/validate-acceptance-records.ps1` 检查本验收记录完整。

## 复盘

视频能力容易把“能总结”误认为“能核验”。v2 中应把字幕来源、时间戳抽查和事实不确定性作为默认字段，而不是只输出概括。

## 边界

本轮未打开用户个人 Bilibili 账号，也未读取观看历史。真实视频任务需要用户提供公开 URL 或明确授权的本地字幕、音视频文件。

