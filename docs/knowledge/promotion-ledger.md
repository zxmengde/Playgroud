# Knowledge Promotion Ledger

本文件记录 knowledge promotion lifecycle 的可审计对象。它服务于 obsidian-skills 的本地化机制：先判断仓库 knowledge，再决定是否需要 Obsidian 写入准备。

## Schema

- id:
- source:
- status: raw_note | curated_note | verified_knowledge | archived | superseded
- target: repository | obsidian_ready | archive
- evidence:
- verification:
- rollback:
- next_action:
- updated_at:

## Records

已有记录如下。新增记录使用：

```powershell
.\scripts\codex.ps1 knowledge promote -Id KP-YYYYMMDD-001 -Source "source" -Status curated_note -Target repository -Evidence "path or command" -Verification "check command" -Rollback "git revert"
```

### KP-20260503-001
- id: KP-20260503-001
- source: external adoption continuation
- status: curated_note
- target: repository
- evidence: docs/capabilities/external-adoptions.md; docs/knowledge/promotion-ledger.md
- verification: scripts/codex.ps1 knowledge check
- rollback: git revert current commit
- next_action: validate promotion ledger
- updated_at: 2026-05-03T03:33:07
