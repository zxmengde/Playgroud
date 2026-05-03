# Synthesized Imported Variant Insights

This file is synthesized from full reads of disabled overlapping skills. Treat these notes as active guidance for the keeper skill, not as an archive. Read the source folders only when this synthesis is insufficient.

Keeper: aris-skills-codex-comm-lit-review

## How To Apply

- Prefer the keeper skill workflow as the default path.
- Add the trigger phrases, verification checks, output contracts, and resource pointers below when they fit the task.
- If a disabled variant contains scripts, templates, references, examples, or assets, treat them as reusable resources from this keeper skill.
- Do not resurrect a disabled variant as a separate active skill unless the keeper cannot express its behavior cleanly.

## Source: aris-comm-lit-review

Trigger/description delta: Communications-domain literature review with Claude-style knowledge-base-first retrieval. Use when the task is about communications, wireless, networking, satellite/NTN, Wi-Fi, cellular, transport protocols, congestion control, routing, scheduling, MAC/PHY, rate adaptation, channel estimation, beamforming, or communication-system research and the user wants papers, related work, a survey, or a landscape summary. Search Zotero, Obsidian, and local paper folders first when available, then search IEEE Xplore, ScienceDirect, ACM Digital Library, and broader web in that order.
Actionable imported checks:
- **PAPER_LIBRARY**: Check local PDFs in this order:
- If a source is unavailable, do not fail.
- prefer peer-reviewed journals and major conferences
- `foundational`: before 2022
- treat these as high-priority evidence because they reflect the user's existing library
- where the evidence is strong vs weak
- Never fail because Zotero or Obsidian MCP is missing.
- Prefer user-owned sources first when available, but do not let them replace external validation.
- Do not pretend a preprint is peer reviewed.
Workflow excerpt to incorporate:
```text
## Workflow
### Step 0a: Search Zotero Library
Skip this step if Zotero MCP is not configured or `zotero` is not enabled.
If available:
1. search by topic
2. capture title, authors, year, venue
3. pull user annotations, tags, or collections when present
4. treat these as high-priority evidence because they reflect the user's existing library
```
