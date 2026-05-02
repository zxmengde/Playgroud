---
name: knowledge-curator
description: "Curate durable, verified, reusable knowledge for D:\\Code\\Playgroud. Use when information should become a local knowledge item, failure lesson, architecture fact, verified conclusion, or an Obsidian note via the official CLI."
---

# Knowledge Curator

## Trigger

- 出现长期有价值且已验证的信息
- 需要把研究、失败教训、架构事实或 verified conclusion 沉淀到本地 knowledge
- 需要把已验证信息写入 Obsidian 或准备同步到 Obsidian

## When Not To Use

- 临时调试输出
- 未验证网页摘录
- 纯会话噪声

## Read

Required files:

- `docs/workflows/knowledge.md`
- `docs/tasks/active.md`
- `docs/profile/user-model.md`
- `docs/profile/preference-map.md`
- `docs/knowledge/system-improvement/routing-v1.yaml`
- `templates/knowledge/knowledge-item.md`

## Inputs

- 来源
- 结论
- 状态
- 适用范围
- 建议写入层级

## Output

- knowledge item
- failure 或 lesson 摘要更新
- Obsidian 写入说明或实际写入

## Allowed Writes

- `docs/knowledge/items/*`
- `docs/knowledge/system-improvement/harness-log.md`
- `docs/tasks/active.md`

## Forbidden Writes

- 不得覆盖 `docs/profile/user-model.md`
- 不得把未验证推断写成 verified conclusion
- 不得在未确认目标 vault 或目标路径时批量改写外部 Obsidian 内容

## Evidence Requirements

- 来源必须可追溯
- 事实、推断、状态、下一步必须分开
- 若写 Obsidian，目标 vault、目标路径和回退方式必须清楚

## Workflow

1. 判断信息属于 preference、lesson、research direction、architecture fact、verified conclusion、task state 还是 archive。
2. 选择本地 knowledge-first 位置。
3. 写清来源、状态、适用范围和下一步。
4. 仅在目标 vault 与路径明确时写入 Obsidian；否则保留为本地 knowledge-first。

## Verify

- `scripts/codex.ps1 knowledge check`
- `scripts/codex.ps1 context budget`
- knowledge 条目结构检查

## Pass Criteria

- 信息被写到正确层级
- 没有制造重复 note
- archived 或 obsolete 内容不会进入默认 active load

## Fail Criteria

- 未验证信息进入长期 memory
- preference、lesson、knowledge 层混写
- 越权写外部 vault 或敏感路径

## Example Invocation

- `Use $knowledge-curator to store a verified architecture fact and write a matching Obsidian note if needed.`

## Failure Modes

- 把任务态信息误写成长期事实
- 忽略来源和状态
- 为了“完整”而制造重复知识条目
