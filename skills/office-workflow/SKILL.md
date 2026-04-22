---
name: office-workflow
description: Use for Word, PowerPoint, Excel, PDF, Markdown, reports, slide decks, spreadsheets, document conversion, editable office artifacts, layout checks, rendering, and office document validation.
---

# Office Workflow

## Context

Use the specialized document skills when applicable: `doc` for DOCX, `slides` or `PowerPoint` for PPTX, `Excel` for spreadsheets, and `pdf` for PDF. Read `D:\Code\Playgroud\docs\workflows\office.md`.

## Process

Before creating or editing office artifacts, read `docs/profile/user-model.md`. If template, audience, file style, visual standard, citation format, or editability preference is missing, use `preference-intake` before producing the artifact.

Infer the user's real communication goal and identify the audience, file type, structure, tone, visual standard, editability requirement, citation needs, and validation method. Use `intent-interviewer` for reports, slide decks, formal documents, or tasks with unclear audience.

Prefer editable source files. Preserve existing formatting unless the user requests redesign. For layout-sensitive work, validate with rendering, screenshots, workbook inspection, document structure checks, or openability checks.

For PowerPoint, preserve editable shapes, charts, tables, speaker notes, master/layout consistency, and deck-wide visual coherence where possible. Validate both structure and rendered slides for layout-sensitive tasks. For Word, preserve headings, references, captions, numbering, tables, and editable text. For Excel, preserve formulas, tables, charts, and data provenance notes.

If the user does not want to answer preference questions now, use conservative academic-research defaults and record unresolved template or style unknowns in the task notes.

## Output

Report output paths, validation method, and any remaining risk.
