# Synthesized Imported Variant Insights

This file is synthesized from full reads of disabled overlapping skills. Treat these notes as active guidance for the keeper skill, not as an archive. Read the source folders only when this synthesis is insufficient.

Keeper: omx-trace

## How To Apply

- Prefer the keeper skill workflow as the default path.
- Add the trigger phrases, verification checks, output contracts, and resource pointers below when they fit the task.
- If a disabled variant contains scripts, templates, references, examples, or assets, treat them as reusable resources from this keeper skill.
- Do not resurrect a disabled variant as a separate active skill unless the keeper cannot express its behavior cleanly.

## Source: omx-plugin-trace

Trigger/description delta: Show agent flow trace timeline and summary
Actionable imported checks:
- **Use `trace_timeline` MCP tool** to show the chronological event timeline
- Use `last` parameter to limit output
- **Use `trace_summary` MCP tool** to show aggregate statistics
Verification/output excerpt to incorporate:
```text
## Output Format
Present the timeline first, then the summary. Highlight:
- **Mode transitions** (how execution modes changed)
- **Bottlenecks** (slow tools or agents)
- **Flow patterns** (keyword -> skill -> agent chains)
```
