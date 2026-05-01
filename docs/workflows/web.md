# 网页工作流程

## 触发场景

适用于网页访问、资料提取、页面截图、下载前检查、网页 UI 验证和在线资料核对。

## 执行要求

开始前读取 `docs/profile/user-model.md` 和 `docs/profile/preference-map.md`。若截图、下载、命名、归档或来源可靠性偏好未知且会影响任务，先使用 `preference-intake`。若用户暂时不想回答，采用 `preference-map.md` 中的网页与知识保守默认值。

优先使用 Playwright 或浏览器工具获取页面内容、截图和链接。登录、提交表单、发送消息、购买、发布或外部写入需要任务级授权或预授权；授权不清时先完成准备和验证，停在执行前。

涉及 Bilibili、课程、会议、网页视频、字幕或转写摘要时，同时读取 `docs/workflows/video.md`，并使用 `video-source-workflow`。优先获取元数据和字幕；登录、cookies、会员内容、下载音频或完整视频需要任务级授权或预授权。

若网页任务同时影响界面、交互或响应式，按 `routing-v1.yaml` 调用 `uiux-reviewer`，并保留桌面与移动端证据，而不是只依赖 DOM 文本或 lint 结果。

## 产物

产物包括来源 URL、提取文本、截图路径、下载文件路径、时间戳和不确定性说明。
