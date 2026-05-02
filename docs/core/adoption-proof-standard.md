# Adoption Proof Standard

本标准用于判断外部机制是否真正进入本仓库的可用能力层。它不衡量外部项目本身，只衡量本地机制是否可触发、可验证、可回滚，并能阻止已发生过的错误。

## 证据等级

允许状态如下：

| status | 含义 |
| --- | --- |
| documented | 只有说明，尚未接入命令、workflow、validator 或 eval |
| command_stub | 有命令入口或对象字段，但状态转换和语义检查不足 |
| smoke_passed | 代表性 smoke 或样例路径通过 |
| partial | 已吸收部分机制，但存在明确未覆盖范围 |
| integration_tested | 有真实或 fixture-based integration proof，且 validator 会检查关键语义 |
| task_used | 已在真实仓库任务中使用并留下非自指证据 |
| user_confirmed | 用户在真实使用中确认有效 |
| deprecated | 保留历史，不再默认使用 |

旧枚举映射：

- `adopted` 不是允许状态；必须改写为 `integration_tested`、`task_used` 或 `user_confirmed`，否则降级。
- `rejected_with_substitute` 改写为 `deprecated` 或 `partial`，并说明替代机制。
- 旧 capability `declared` 映射为 `documented`。
- 旧 capability `experimental` 映射为 `partial`，除非有 integration proof。
- 旧 capability `task_proven` 映射为 `task_used`。
- 旧 capability `user_proven` 映射为 `user_confirmed`。

## integration_tested 最低标准

一个外部机制只有同时满足以下条件，才能标为 `integration_tested` 或更高等级：

1. 有本地 artifact，且路径存在或命令真实可调用。
2. 有 user-visible entry，且能在 help、workflow、skill policy、routing、eval 或 finish gate 中发现。
3. 有 trigger condition。
4. 有具体 behavior delta。
5. 有非自指 evidence。
6. 有至少一个真实或 fixture-based integration proof。
7. 有 validator 检查关键语义，而不是只检查字段存在。
8. 有 rollback。
9. 至少被 workflow、skill policy、routing、eval 或 finish gate 之一真实引用。
10. 能说明它会如何阻止过去已经发生过的错误。

字段 marker：`prevents_past_error` 必须说明该机制阻止哪类既有错误。

## 不得升级的情况

以下情况不得标为 `integration_tested`、`task_used` 或 `user_confirmed`：

- 只有文档说明。
- 只有命令入口，但命令没有真实状态转换。
- 只有 schema，没有真实记录或 fixture。
- 只有 sample smoke。
- evidence 只引用 adoption card、capability map、ledger 自身、attempts 自身或 validator 自身。
- latest task attempt 仍为 `running` 或 `review_needed`，却声称任务完成。
- active task、board、attempt、final report 或 Git 状态互相矛盾。
- validator 只能检查字段存在。
- 不能说明未来 Codex 行为如何改变。

## 自指证据边界

以下路径只能作为元数据，不得作为唯一证据：

- `docs/capabilities/external-adoptions.md`
- `docs/capabilities/capability-map.yaml`
- `docs/knowledge/promotion-ledger.md`
- `docs/tasks/attempts.md`
- `scripts/lib/commands/validate-delivery-system.ps1`

若 evidence 只包含这些路径，validator 必须失败。允许它们和非自指 artifact、fixture、命令输出、真实任务记录共同出现。

## 失败阻断

如果发现“机制存在”被误判为“能力已内化”，必须至少补一个机制层修复：

- adoption proof 标准更新；
- anti-self-reference evidence 检查；
- fixture 或真实 integration proof；
- open-attempt finish gate；
- active task / board / attempt 一致性检查；
- failure 或 harness 记录。
