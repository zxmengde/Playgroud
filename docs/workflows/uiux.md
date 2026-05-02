# UI/UX 评审工作流

适用于所有影响界面、交互、信息层次、桌面端或移动端体验的任务。默认顺序是：明确场景、检查层次与主 action、检查状态与响应式、收集截图或交互证据、给出问题和风险。

最小输入：

- 目标页面或组件
- 用户场景
- 设备范围
- 验收预期

最小输出：

- UI/UX checklist
- 桌面与移动端证据
- 问题清单
- 风险说明

真实 UI/UX review pack 至少覆盖：

- screenshot：记录截图路径、viewport 和页面状态。
- responsive：桌面与移动端至少各检查一次。
- accessibility：键盘路径、焦点、表单标签、颜色对比和可读文本。
- interaction states：hover、active、disabled、selected、modal、form validation。
- empty / loading / error states：不能只检查正常数据态。
- copywriting：按钮、错误提示、空态文案和任务路径一致。
- visual hierarchy：主 action、次级信息、密度和对齐关系清楚。
- user task path：用户从进入页面到完成主要任务的路径可执行。

只看代码、只看 lint、只跑 sample smoke 或只做主观评价都不算完成。
