# Synthesized Imported Variant Insights

This file is synthesized from full reads of disabled overlapping skills. Treat these notes as active guidance for the keeper skill, not as an archive. Read the source folders only when this synthesis is insufficient.

Keeper: aris-skills-codex-patent-review

## How To Apply

- Prefer the keeper skill workflow as the default path.
- Add the trigger phrases, verification checks, output contracts, and resource pointers below when they fit the task.
- If a disabled variant contains scripts, templates, references, examples, or assets, treat them as reusable resources from this keeper skill.
- Do not resurrect a disabled variant as a separate active skill unless the keeper cannot express its behavior cleanly.

## Source: aris-patent-review

Trigger/description delta: Get an external patent examiner review of a patent application. Use when user says \"专利审查\", \"patent review\", \"审查意见\", \"examiner review\", or wants critical feedback on patent claims and specification.
Actionable imported checks:
- `REVIEWER_MODEL = gpt-5.4` — Model used via Codex MCP
- `REVIEW_ROUNDS = 2` — Number of review rounds
- Codex MCP Server configured:
- Do dependent claims provide meaningful fallback positions?
- Must be fixed before proceeding
- Should be fixed or argued
- Document in output for later cleanup
- The reviewer persona must be a patent examiner, not a paper reviewer or academic.
- Address CRITICAL and MAJOR issues before proceeding to the next phase.
- Document all changes in the review report for traceability.
- If the patentability score is below 5/10 after Round 2, recommend significant rework before filing.
- The review is advisory -- actual prosecution may proceed differently.
Workflow excerpt to incorporate:
```text
## Workflow
### Step 1: Gather Patent Context
Before calling the external reviewer, compile a comprehensive briefing:
1. Read all claims (independent + dependent)
2. Read specification sections (at least summary and detailed description)
3. Read prior art report for context
4. Identify: core inventive concept, claim scope, known prior art, target jurisdiction
```
