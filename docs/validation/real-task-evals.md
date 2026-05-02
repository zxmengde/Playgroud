# Real Task Evals

本文件定义真实任务回放 eval 的规格。第一版是 Markdown spec，并由 `validate-delivery-system.ps1` 检查字段完整性；不得把 sample smoke 直接写成真实任务通过。

## writing-revision-eval

task_input: 用户提供一段草稿、目标读者、用途和期望风格，要求 Codex 改成接近可交付文章。  
expected_user_outcome: 文章结构、论证、语言和事实边界都更接近提交版本，而不是机械润色。  
hidden_obligations: 明确目标读者；保留用户原意；检查事实、引用和术语；说明重要改动。  
required_artifacts: 修订稿、结构说明、句子级修改样例、事实/引用检查记录、最终差异说明。  
required_verification: 原意保留检查、风格一致性检查、引用或事实可核查性检查。  
common_failure_modes: 只改同义词；丢失用户立场；夸大事实；引用未核验；没有说明差异。  
pass_conditions: 输出可直接进入下一轮人工审阅；关键事实可追溯；风格与目标读者一致。  
fail_conditions: 只做表层润色；虚构引用；未说明事实不确定性；没有保留用户原意。  
evidence_required: 草稿片段、改后片段、引用或事实核验路径、差异说明。  
rollback_or_recovery: 保留原文；以 diff 或分段说明恢复被误改的内容。

## python-package-delivery-eval

task_input: 用户给出一个脚本或小型 Python 项目，要求推进到可安装包并修复一个回归问题。  
expected_user_outcome: 包能在干净环境安装、导入、运行 CLI，并有 README 安装路径和构建产物。  
hidden_obligations: package metadata、依赖声明、入口点、README、build artifact、uninstall/cleanup、bugfix 后回归检查。  
required_artifacts: `pyproject.toml` 或等价 metadata、源代码包、测试、README、构建产物、验证日志。  
required_verification: fresh environment install、import smoke、CLI smoke、build、uninstall/cleanup、回归测试。  
common_failure_modes: 只运行源文件；漏 package metadata；README 路径错误；CLI 未安装；修 bug 后未回归。  
pass_conditions: 新环境可安装；import 和 CLI 通过；README 命令可复现；构建产物可生成。  
fail_conditions: 只能在当前目录运行；依赖未声明；没有清理路径；修复破坏旧行为。  
evidence_required: 安装命令、import 输出、CLI 输出、build 输出、清理命令、回归测试结果。  
rollback_or_recovery: 使用 Git revert 或删除新增 package metadata；记录环境清理命令。

## ui-change-eval

task_input: 用户要求修改页面、组件、布局、交互或可视状态。  
expected_user_outcome: 真实 UI 可用且符合目标任务路径，桌面和移动端均可检查。  
hidden_obligations: screenshot、desktop/mobile、interaction、loading/error/empty states、accessibility、copy、visual consistency。  
required_artifacts: 改动 diff、桌面截图、移动端截图、交互记录、状态检查、可访问性检查、文案检查。  
required_verification: 浏览器打开真实页面；检查主要 action；检查 loading/error/empty；检查键盘或屏幕阅读基础属性。  
common_failure_modes: 只改 CSS 不看页面；移动端溢出；按钮状态缺失；错误态遮挡；文案与任务不一致。  
pass_conditions: 关键路径可完成；文本不溢出；状态齐全；截图和交互证据可追溯。  
fail_conditions: 无截图；只看 lint；忽略移动端；交互无法完成；状态缺失。  
evidence_required: 截图路径、viewport、操作步骤、问题清单、修复说明。  
rollback_or_recovery: 记录涉及组件和样式文件；可用 Git revert 恢复。

## repo-maintenance-eval

task_input: 用户要求清理仓库复杂度、修复状态漂移、吸收外部机制并保留验证。  
expected_user_outcome: 目录更清楚，能力状态更诚实，任务状态与 Git 对齐，验证能防止回退。  
hidden_obligations: 删除/合并无用文件；更新引用；验证路径；回滚方法；active task；capability evidence；final report。  
required_artifacts: diff、目录统计前后对比、adoption cards、capability map、validator、任务状态、报告。  
required_verification: 新增 validator、`scripts/codex.ps1 validate`、`scripts/codex.ps1 eval`、`git diff --check`、finish readiness。  
common_failure_modes: 只写报告；新增更多目录；缓存未清理；active task 漂移；capability 状态虚高；help 与命令不一致。  
pass_conditions: 至少一个验证门检查新机制；缓存噪声清理；状态与入口一致；报告列出回滚方法。  
fail_conditions: 无实际 diff；外部机制状态仍使用 adopted；sample smoke 写成 task_used/user_confirmed；未修复 help 或 hook 文档。
evidence_required: 修改文件清单、删除清单、统计表、验证输出、Git 状态、回滚步骤。  
rollback_or_recovery: Git revert 当前提交；若未提交，按报告中的删除和新增清单逐项恢复。
