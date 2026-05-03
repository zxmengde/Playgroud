# Synthesized Imported Variant Insights

This file is synthesized from full reads of disabled overlapping skills. Treat these notes as active guidance for the keeper skill, not as an archive. Read the source folders only when this synthesis is insufficient.

Keeper: aris-skills-codex-patent-pipeline

## How To Apply

- Prefer the keeper skill workflow as the default path.
- Add the trigger phrases, verification checks, output contracts, and resource pointers below when they fit the task.
- If a disabled variant contains scripts, templates, references, examples, or assets, treat them as reusable resources from this keeper skill.
- Do not resurrect a disabled variant as a separate active skill unless the keeper cannot express its behavior cleanly.

## Source: aris-patent-pipeline

Trigger/description delta: Full patent drafting pipeline from invention description to jurisdiction-formatted filing documents. Supports CN (CNIPA), US (USPTO), EP (EPO). Supports invention patents and utility models. Use when user says \"写专利\", \"patent pipeline\", \"专利申请\", \"draft patent\", \"写权利要求书\", or wants to draft a complete patent application.
Actionable imported checks:
- Go to `/experiment-bridge` → `/auto-review-loop` → `/paper-writing` (publish track)
- **REVIEWER_MODEL = `gpt-5.4`** — Model used via Codex MCP for examiner-style review.
- **MAX_REVIEW_ROUNDS = 2** — Maximum review-revision cycles.
- **AUTO_PROCEED = false** — At each checkpoint, **always wait for explicit user confirmation**. Patent applications require inventor judgment at every stage. Set `true` only if user explicitly requests autonomous mode.
- **LANGUAGE = `auto`** — Output language. Auto-detected from jurisdiction: CN->Chinese, US->English, EP->English. Override explicitly if needed.
- **OUTPUT_DIR = `patent/`** — Directory for generated patent files.
- **OUTPUT_FORMAT = `markdown`** — Draft format. `markdown` for review, `docx` for filing-ready.
- If `status: "in_progress"` and within 24h -> **resume** from saved phase (read output files to restore context)
- **Invention description** — may be structured (references INVENTION_BRIEF.md), conversational with figures, or output from IDEA_REPORT.md
- **Overrides** — language, output format, review rounds
- Check for `patent/PATENT_STATE.json` (resume from prior interrupted run)
- No figures -> note that figures will be needed and plan what drawings are required
- Reply with **adjustments** -> refine the invention scope and re-check novelty
- Examiner review score: [X]/10
- [ ] Have a patent attorney review the application
- Claims must be supported by the specification (written description requirement).
- Each jurisdiction has strict format requirements -- do not mix formats.
- The patent pipeline produces drafts for attorney review, not final filing documents.
Workflow excerpt to incorporate:
```text
## Workflow
### Phase 0: Input Parsing & Context Gathering
Parse `$ARGUMENTS` to extract:
1. **Invention description** — may be structured (references INVENTION_BRIEF.md), conversational with figures, or output from IDEA_REPORT.md
2. **Jurisdiction** — detect from keywords (e.g., "CN" or "中国" -> CN, "US" or "USPTO" -> US, "EP" or "EPO" -> EP, "ALL")
3. **Patent type** — detect from keywords (e.g., "utility model" or "实用新型" -> utility_model, default -> invention)
4. **Overrides** — language, output format, review rounds
Then gather context from the project directory:
1. Read `INVENTION_BRIEF.md` if it exists (user filled in the template)
2. Read `IDEA_REPORT.md` if it exists (from `/idea-discovery` -- can extract invention from research results)
3. Read `refine-logs/FINAL_PROPOSAL.md` if it exists
4. Read `NARRATIVE_REPORT.md` if it exists (research results that may be patentable)
5. Search for user-provided figures (PNG, JPG, SVG, PDF) in the project directory
6. Check for `patent/PATENT_STATE.json` (resume from prior interrupted run)
If insufficient context exists:
- No invention description at all -> suggest user describe the invention or fill in `INVENTION_BRIEF.md`
- Has IDEA_REPORT.md -> extract patentable aspects from the research
- Has figures -> reference them in the invention brief
- No figures -> note that figures will be needed and plan what drawings are required
**If the input is conversational** (not a structured brief), parse the description into the invention brief structure and write `patent/INVENTION_BRIEF.md` for downstream phases.
```
