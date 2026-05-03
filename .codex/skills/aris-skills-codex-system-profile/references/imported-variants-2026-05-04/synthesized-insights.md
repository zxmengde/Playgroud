# Synthesized Imported Variant Insights

This file is synthesized from full reads of disabled overlapping skills. Treat these notes as active guidance for the keeper skill, not as an archive. Read the source folders only when this synthesis is insufficient.

Keeper: aris-skills-codex-system-profile

## How To Apply

- Prefer the keeper skill workflow as the default path.
- Add the trigger phrases, verification checks, output contracts, and resource pointers below when they fit the task.
- If a disabled variant contains scripts, templates, references, examples, or assets, treat them as reusable resources from this keeper skill.
- Do not resurrect a disabled variant as a separate active skill unless the keeper cannot express its behavior cleanly.

## Source: aris-system-profile

Trigger/description delta: Profile a target (script, process, GPU, memory, interconnect) using external tools and code instrumentation. Produces structured performance reports with actionable recommendations. Use when user says "profile", "benchmark", "bottleneck", or wants performance analysis.
Actionable imported checks:
- Check available tools and hardware topology
- Run the chosen methods, capture all output
- Save artifacts (flamegraphs, traces, logs) to `./profile_output/`
