# UIUX Review Sample

## Scenario

设置页新增一组系统状态卡片，需要同时覆盖桌面与移动端。

## Checklist

- 目标用户明确
- 信息层次明确
- 主 action 明确
- 加载态、错误态、空态明确
- 桌面端检查完成
- 移动端检查完成

## Evidence

- Desktop screenshot: `artifacts/uiux/settings-desktop.png`, viewport 1440x900
- Mobile screenshot: `artifacts/uiux/settings-mobile.png`, viewport 390x844
- Interaction notes: primary action, empty state, error state, loading state checked
- Accessibility notes: focus order and text contrast checked
- Responsive notes: card wrapping and toolbar overflow checked

## Findings

- 层次清楚，但移动端首屏略拥挤。
- 状态标签颜色对比度尚可。

## Risks

- 若卡片继续增加，移动端滚动成本会升高。
