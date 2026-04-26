# Office 文档验收

## 输入

- 历史 PPT 文本抽取结果，原路径为 `output/ppt_text_extract.json`，当前不再作为版本化文件保留。
- `docs/workflows/office.md`
- `skills/office-workflow/SKILL.md`

## 执行路径

使用现有 PPT 文本抽取结果进行结构检查，不覆盖原始 Office 文件。该验收关注文本项密度、可编辑结构和后续人工检查入口，而不是替代渲染检查。

## 产物

- `scripts/check-ppt-text-extract.ps1`
- `docs/validation/v2-acceptance/office-document.md`

## 验证

- `scripts/check-ppt-text-extract.ps1 -Path <抽取结果 JSON>` 可用于正式 PPT 文本结构检查。
- 检查输出提示第 12 页文本项为 37，超过默认阈值 35。
- 该警告被保留为待复核信号，不被解释为 v2 重构失败。

## 复盘

Office 能力需要结构检查与视觉检查并行。当前脚本只能发现文本项密度异常，不能判断版式是否美观或是否溢出；后续正式 PPT/Word 仍应渲染截图或页面图像。

## 边界

本轮不覆盖或重写任何用户 Office 源文件。生成结果默认写入被忽略的 `output/` 目录，不作为长期事实来源；若后续需要修改正式文档，应先明确源文件路径、输出路径和是否允许覆盖。

