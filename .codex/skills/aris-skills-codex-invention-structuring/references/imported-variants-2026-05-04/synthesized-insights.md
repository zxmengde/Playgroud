# Synthesized Imported Variant Insights

This file is synthesized from full reads of disabled overlapping skills. Treat these notes as active guidance for the keeper skill, not as an archive. Read the source folders only when this synthesis is insufficient.

Keeper: aris-skills-codex-invention-structuring

## How To Apply

- Prefer the keeper skill workflow as the default path.
- Add the trigger phrases, verification checks, output contracts, and resource pointers below when they fit the task.
- If a disabled variant contains scripts, templates, references, examples, or assets, treat them as reusable resources from this keeper skill.
- Do not resurrect a disabled variant as a separate active skill unless the keeper cannot express its behavior cleanly.

## Source: aris-invention-structuring

Trigger/description delta: Structure a raw invention idea into a formal invention disclosure. Use when user says \"构建发明\", \"structure invention\", \"发明构建\", \"invention disclosure\", or wants to formalize a rough idea into a patent-ready structure.
Actionable imported checks:
- `REVIEWER_MODEL = gpt-5.4` — External reviewer for invention decomposition validation
- Must be a specific, technical problem (not a commercial or social problem)
- Must be described at a level that matches the intended claim scope
- Must result from the inventive features, not just good engineering
- Is the core inventive concept correctly identified? Are there features that should be core but are listed as supporting (or vice versa)?
- The Problem must come from prior art deficiencies, not from commercial needs.
- The Solution must describe the technical mechanism, not just the result.
- The core inventive concept must be the minimum set of features for patentability.
- Supporting features should be independently valuable -- each should provide a meaningful technical benefit even if other supporting features are removed.
- Never invent embodiments that do not correspond to the actual invention or user-provided materials.
- If `mcp__codex__codex` is not available, skip cross-model validation and note it in the output.
Workflow excerpt to incorporate:
```text
## Workflow
### Step 1: Problem-Solution-Advantage Framework
Structure the invention using the universal patent framework:
**Technical Problem (要解决的技术问题)**:
- Derived from prior art deficiencies identified in NOVELTY_ASSESSMENT.md
- Must be a specific, technical problem (not a commercial or social problem)
- Statement format: "The technical problem to be solved is how to [specific technical objective] given [specific technical constraint]."
**Technical Solution (技术方案)**:
- The invention's specific technical contribution
- Focus on the mechanism, not the result
- Must be described at a level that matches the intended claim scope
- Identify which features are known vs. inventive
**Advantages (有益效果)**:
- Measurable or quantifiable improvements over prior art
- Must result from the inventive features, not just good engineering
- Include specific technical effects if known (e.g., "reduces processing time by 40%")
```
