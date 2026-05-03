# Knowledge Promotion Ledger

## Schema

- id:
- source:
- status: raw_note | curated_note | verified_knowledge | archived | superseded
- target: repository | obsidian_ready | archive
- evidence:
- next_action:
- updated_at:

## Records

### KP-20260503-simplify-001
- id: KP-20260503-simplify-001
- source: repository cleanup request
- status: curated_note
- target: repository
- evidence: README.md; docs/workflows.md
- next_action: keep knowledge promotion repository-first
- updated_at: 2026-05-03T00:00:00

### KP-20260503-simplify-002
- id: KP-20260503-simplify-002
- source: public command parser fix
- status: verified_knowledge
- target: repository
- evidence: scripts/codex.ps1; README.md; docs/workflows.md
- next_action: use codex.ps1 as the single entry
- updated_at: 2026-05-03T18:57:25

### KP-20260503-services-001
- id: KP-20260503-services-001
- source: real external service request
- status: verified_knowledge
- target: repository
- evidence: scripts/codex.ps1; docs/services.md; README.md
- next_action: use original vibe and ARIS runtime services instead of markdown substitutes
- updated_at: 2026-05-03T23:40:35
