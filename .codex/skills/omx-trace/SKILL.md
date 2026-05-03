---
name: omx-trace
description: Show agent flow trace timeline and summary
metadata:
  role: command_adapter
---

# Agent Flow Trace

[TRACE MODE ACTIVATED]

## Objective

Display the flow trace showing how hooks, keywords, skills, agents, and tools interacted during this session.

## Instructions

1. **Use `trace_timeline` MCP tool** to show the chronological event timeline
   - Call with no arguments to show the latest session
   - Use `filter` parameter to focus on specific event types (hooks, skills, agents, keywords, tools, modes)
   - Use `last` parameter to limit output

2. **Use `trace_summary` MCP tool** to show aggregate statistics
   - Hook fire counts
   - Keywords detected
   - Skills activated
   - Mode transitions
   - Tool performance and bottlenecks

## Output Format

Present the timeline first, then the summary. Highlight:
- **Mode transitions** (how execution modes changed)
- **Bottlenecks** (slow tools or agents)
- **Flow patterns** (keyword -> skill -> agent chains)

## Consolidated OMX Plugin Merge

Replaces `omx-plugin-trace`.

### Retained Rules
- Use to record workflow trace, decisions, artifacts, and state transitions.
- Keep trace factual and tied to commands/files, not narrative confidence.
- Trace should support resume and audit without replaying the conversation.
