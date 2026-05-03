---
name: knowledge-capture
description: Use when durable information should be saved locally, including user preferences, research notes, project background, web sources, templates, file paths, terminology, task outcomes, and reusable context.
metadata:
  role: primary
---

# Knowledge Capture

## Trigger

Use when information will reduce future repetition, improve task quality, preserve evidence, or clarify durable user preference.

## Read

Read `docs/core.md`, `docs/workflows.md`, and `docs/knowledge/promotion-ledger.md`.

## Act

Separate stable fact, inference, uncertainty, and source. Do not store secrets, credentials, or unsupported sensitive information. Use category indexes under `docs/knowledge/` when adding durable items.

## Obsidian-Skills Promotion Boundary

Use the obsidian-skills pattern as a promotion lifecycle, not as automatic
external-vault writing.

- `raw_note`: unreviewed capture from a task, source, conversation, or local
  artifact. Keep it short and preserve source/evidence.
- `curated_note`: organized note with stable title, scope, source, uncertainty,
  and reason it may be reused.
- `verified_knowledge`: fact or procedure checked against non-self-referential
  evidence and linked from the relevant repository knowledge index.
- `archived`: retained for history but no longer active.
- `superseded`: replaced by a newer note; link to the replacement.

Write to the repository ledger when the knowledge affects future Codex behavior
inside this workspace, records a reusable project fact, or supports a workflow.
Write to an external Obsidian vault only when the user has provided the vault
path, authorization, and rollback expectation for that task. Do not store
one-off observations, transient command output, secrets, or unsupported claims
as long-term memory.

When promoting, record: source, evidence, status transition, target
(`repository`, `obsidian_ready`, `archived`, or `superseded`), and rollback.

## Output

Create or update a knowledge item and update the main and category index when needed.

## Verify

Check source, status, paths or links, uncertainty notes, and index coverage. Run `scripts/codex.ps1 knowledge promotions`.
