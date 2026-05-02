# 视频资料工作流程

## 触发场景

适用于 Bilibili、课程、会议、访谈、公开视频、网页嵌入视频、字幕文件和音视频资料摘要。

## 执行要求

开始前读取 `docs/profile/user-model.md`、`docs/profile/preference-map.md` 和 `docs/workflows/web.md`。若摘要深度、是否需要时间戳、是否允许下载字幕或音频、是否需要截图和归档方式未知且影响结果，先少量询问；若用户暂时不想回答，默认只获取页面、元数据和字幕，不下载完整视频。

优先使用可核验资料：视频 URL、标题、作者、发布时间、简介、分 P 信息、官方字幕、用户提供的字幕文件、页面可见文本和评论中可验证线索。登录、读取会员内容、使用 cookies、下载音频或完整视频需要任务级授权或预授权。

视频摘要不得假装已观看或已转写不存在的内容。若没有字幕、音频或可靠页面信息，只能基于可见元数据给出有限摘要，并说明证据不足。

## 处理顺序

先明确用途：快速了解、课程笔记、科研资料、论文写作背景、观点核查还是知识库归档。用途决定摘要密度和是否需要逐段时间戳。

再获取证据：优先保存 URL、标题、作者、发布时间、简介、分 P 信息和字幕。Bilibili 链接默认使用用户级 `bilibili-video-evidence` skill 采集证据，先取原生字幕，输出 `sectioned.md` 和 `subtitles.json`；需要截图时再按时间点生成 `frames/*.png`。只有字幕缺失且存在任务级授权或预授权后，才进入 cookie、音频提取或 ASR 路径。

若本机存在 `yt-dlp`，可在不下载视频的前提下尝试：

```powershell
yt-dlp --skip-download --write-info-json --write-subs --write-auto-subs --sub-lang "zh.*,en.*" <url>
```

若平台或账号状态导致字幕不可得，不绕过权限；记录失败原因并改用用户提供字幕、页面信息或经任务级授权的本地音频转写。

随后输出结构化摘要：核心内容、分段要点、关键时间戳、可核查说法、与用户任务的关系、待核查问题。若已有 `sectioned.md`、`subtitles.json` 和截图证据，使用用户级 `video-note-writer` skill 生成 Markdown 笔记；该阶段不得自行补造字幕、公式、图表、日期或结论。

课程讲义、长课、需要 PDF 或大量图像证据时，可参考 `lecture-to-notes` 的三方核对思路：时间戳、字幕和画面必须对应。但该流程依赖 `yt-dlp`、`ffmpeg`、LaTeX、ImageMagick 和 Whisper，不作为普通视频摘要默认路径。

科研或论文相关视频应转为知识条目，并标明视频资料的证据等级低于论文、标准和官方文档。

## 验证

检查字幕是否与视频标题和分 P 对应；抽查时间戳；保留获取命令、文件路径和 URL。若使用自动字幕，应标注可能存在识别错误。若引用视频观点进入正式文本，需再找论文、官方文档或机构资料支撑。

本机能力检查：

```powershell
.\scripts\codex.ps1 audit
```

## 参考来源

- yt-dlp 项目：https://github.com/yt-dlp/yt-dlp
- yt-dlp 支持站点列表：https://github.com/yt-dlp/yt-dlp/blob/master/supportedsites.md
