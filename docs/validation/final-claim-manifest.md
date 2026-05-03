# Final Claim Manifest

branch: current_branch
commit: HEAD
pushed_to: current_upstream_if_HEAD_matches
main_changed: live_check
working_tree_clean: true
active_task_status: current_active_task
latest_attempt_id: current_latest_attempt
latest_attempt_status: terminal_required
pending_validation: false
validate_passed: true
eval_passed: true
strict_finish_passed: true
git_diff_check_passed: true
remaining_user_review_required: true

## Guard Rule

最终回复中的完成、提交、推送、工作区干净、验证通过、strict finish 通过、任务 done、等待用户 review 和可以合并等声明，必须同时由本文件字段、实时 Git 命令输出和 `check-finish-readiness.ps1 -Strict` 支持。字段值为 `current_*`、`HEAD` 或 `live_check` 时，由 strict gate 在运行时解析。

## Current Intended Claims

- 本轮不得声称 `user_confirmed`。
- 修复分支推送和 main 推送必须分开报告。
- `main_changed` 只有在当前分支为 `main` 且合并后验证通过时才可在最终回复中写成 true。
- 若 latest attempt 不是 `done`、`blocked` 或 `cancelled`，不得声称任务完成。
