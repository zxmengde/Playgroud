# Synthesized Imported Variant Insights

This file is synthesized from full reads of disabled overlapping skills. Treat these notes as active guidance for the keeper skill, not as an archive. Read the source folders only when this synthesis is insufficient.

Keeper: aris-skills-codex-meta-optimize

## How To Apply

- Prefer the keeper skill workflow as the default path.
- Add the trigger phrases, verification checks, output contracts, and resource pointers below when they fit the task.
- If a disabled variant contains scripts, templates, references, examples, or assets, treat them as reusable resources from this keeper skill.
- Do not resurrect a disabled variant as a separate active skill unless the keeper cannot express its behavior cleanly.

## Source: aris-meta-optimize

Trigger/description delta: Analyze ARIS usage logs and propose optimizations to SKILL.md files, reviewer prompts, and workflow defaults. Outer-loop harness optimization inspired by Meta-Harness (Lee et al., 2026). Use when user says \"优化技能\", \"meta optimize\", \"improve skills\", \"分析使用记录\", or wants to optimize ARIS's own harness components based on accumulated experience.
Actionable imported checks:
- **Logging must be active.** Copy `templates/claude-hooks/meta_logging.json` into your project's `.claude/settings.json` (or merge the hooks section).
- **Sufficient data.** At least 5 complete workflow runs logged in `.aris/meta/events.jsonl`. The skill will check and warn if insufficient.
- Which review round catches the most critical issues?
Workflow excerpt to incorporate:
```text
## Workflow
### Step 0: Check Data Availability
```bash
EVENTS_FILE=".aris/meta/events.jsonl"
if [ ! -f "$EVENTS_FILE" ]; then
    echo "ERROR: No event log found at $EVENTS_FILE"
    echo "Enable logging first: copy templates/claude-hooks/meta_logging.json into .claude/settings.json"
    exit 1
fi
EVENT_COUNT=$(wc -l < "$EVENTS_FILE")
SKILL_INVOCATIONS=$(grep -c '"skill_invoke"' "$EVENTS_FILE" || echo 0)
SESSIONS=$(grep -c '"session_start"' "$EVENTS_FILE" || echo 0)
echo "📊 Event log: $EVENT_COUNT events, $SKILL_INVOCATIONS skill invocations, $SESSIONS sessions"
if [ "$SKILL_INVOCATIONS" -lt 5 ]; then
    echo "⚠️  Insufficient data (<5 skill invocations). Continue using ARIS normally and re-run later."
    exit 0
fi
```
```
