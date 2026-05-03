# Synthesized Imported Variant Insights

This file is synthesized from full reads of disabled overlapping skills. Treat these notes as active guidance for the keeper skill, not as an archive. Read the source folders only when this synthesis is insufficient.

Keeper: omx-analyze

## How To Apply

- Prefer the keeper skill workflow as the default path.
- Add the trigger phrases, verification checks, output contracts, and resource pointers below when they fit the task.
- If a disabled variant contains scripts, templates, references, examples, or assets, treat them as reusable resources from this keeper skill.
- Do not resurrect a disabled variant as a separate active skill unless the keeper cannot express its behavior cleanly.

## Source: omx-plugin-analyze

Trigger/description delta: Run read-only deep repository analysis and return a ranked synthesis with explicit confidence, concrete file references, and clear evidence-vs-inference boundaries. Use when a user says 'analyze', 'investigate', 'why does', 'what's causing', or needs grounded cross-file explanation before any changes are proposed.
Actionable imported checks:
- confidence should reflect the strength of the available evidence
- the user wants to understand architecture, behavior, causality, impact, or tradeoffs before changing anything
- Do not edit files.
- Do not turn the answer into an implementation plan.
- Do not recommend fixes as the primary output.
- Do not silently switch into execution work.
- Do not overclaim certainty.
- Do not invent facts that are not supported by repository evidence.
- Do not use judgmental, normative, or speculative language that outruns the evidence.
- Scale the depth to the request: for simple or obvious questions, reduce swarm intensity and answer directly after enough reading.
- **Evidence** — directly supported by concrete repository artifacts
- **Inference** — a reasoned conclusion drawn from evidence
- **Unknown** — a question the current repository evidence does not resolve
- Keep parallel lanes bounded: each lane should answer a concrete sub-question or inspect a specific subsystem.
- Do not imply that `$team` is available in plain Codex/App sessions.
- Default to outcome-first progress and completion reporting: state the question, evidence, inference boundaries, and stop condition before adding process detail.
- Read for direct evidence first.
- Return a synthesis that clearly separates evidence from inference.
