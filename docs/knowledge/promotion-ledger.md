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
- status: superseded
- target: archive
- evidence: docs/capabilities/external-adoptions.md; docs/knowledge/promotion-ledger.md
- verification: scripts/codex.ps1 knowledge check
- rollback: git revert current commit
- next_action: replaced by non-self promotion proof in KP-20260503-002 and KP-20260503-003
- updated_at: 2026-05-03T10:20:00

### KP-20260503-002
- id: KP-20260503-002
- source: docs/workflows/knowledge.md raw-note policy
- status: raw_note
- target: repository
- evidence: docs/workflows/knowledge.md; docs/core/adoption-proof-standard.md
- verification: scripts/codex.ps1 knowledge promotions
- rollback: git revert current commit
- next_action: curate into adoption proof standard and fixture
- updated_at: 2026-05-03T10:20:00

### KP-20260503-003
- id: KP-20260503-003
- source: KP-20260503-002
- status: verified_knowledge
- target: obsidian_ready
- evidence: docs/core/adoption-proof-standard.md; docs/validation/adoption-proof-fixtures.md
- verification: scripts/lib/commands/validate-delivery-system.ps1
- rollback: git revert current commit
- next_action: do not write external Obsidian vault unless user provides target and rollback path
- updated_at: 2026-05-03T10:20:00
