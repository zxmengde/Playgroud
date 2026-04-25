---
name: knowledge-capture
description: Use when durable information should be saved locally, including user preferences, research notes, project background, web sources, templates, file paths, terminology, task outcomes, and reusable context.
---

# Knowledge Capture

## Trigger

Use when information will reduce future repetition, improve task quality, preserve evidence, or clarify durable user preference.

## Read

Read `docs/core/memory-state.md`, `docs/workflows/knowledge.md`, `docs/knowledge/index.md`, and `templates/knowledge/knowledge-item.md`.

## Act

Separate stable fact, inference, uncertainty, and source. Do not store secrets, credentials, or unsupported sensitive information. Use category indexes under `docs/knowledge/` when adding durable items.

## Output

Create or update a knowledge item and update the main and category index when needed.

## Verify

Check source, status, paths or links, uncertainty notes, and index coverage. Run `scripts/validate-knowledge-index.ps1`.

