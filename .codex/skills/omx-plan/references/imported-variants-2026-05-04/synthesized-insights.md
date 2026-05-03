# Synthesized Imported Variant Insights

This file is synthesized from full reads of disabled overlapping skills. Treat these notes as active guidance for the keeper skill, not as an archive. Read the source folders only when this synthesis is insufficient.

Keeper: omx-plan

## How To Apply

- Prefer the keeper skill workflow as the default path.
- Add the trigger phrases, verification checks, output contracts, and resource pointers below when they fit the task.
- If a disabled variant contains scripts, templates, references, examples, or assets, treat them as reusable resources from this keeper skill.
- Do not resurrect a disabled variant as a separate active skill unless the keeper cannot express its behavior cleanly.

## Source: omx-plugin-plan

Trigger/description delta: Strategic planning with optional interview workflow
Actionable imported checks:
- User wants to plan before implementing -- "plan this", "plan the", "let's plan"
- User wants an existing plan reviewed -- "review this plan", `--review`
- Task is broad or vague and needs scoping before any code is written
- Gather codebase facts via `explore` agent before asking the user about them
- Plans must meet quality standards: 80%+ claims cite file/line, 90%+ criteria are testable
- Implementation step count must be right-sized to task scope; avoid defaulting to exactly five steps when the work is clearly smaller or larger
- Consensus mode outputs the final plan by default; add `--interactive` to enable execution handoff
- **Gather codebase facts first**: Before asking "what patterns does your code use?", spawn an `explore` agent to find out, then ask informed follow-up questions
- **Review** (optional): Critic review if requested
- **Planner** creates initial plan and a compact **RALPLAN-DR summary** before any Architect review. The summary **MUST** include:
- **Proceed to review** — send to Architect and Critic for evaluation
- **Skip review** — go directly to final approval (step 7)
- **Re-review loop** (max 5 iterations): If Critic rejects or iterates, execute this closed loop:
- On Critic approval (with improvements applied): *(--interactive only)* If running with `--interactive`, use `AskUserQuestion` / the structured question UI to present the plan with these options:
- *(--interactive only)* User chooses via the structured question UI (never ask for approval in plain text when a structured surface is available)
- On user approval (--interactive only):
- Treat review as a reviewer-only pass. The context that wrote the plan, cleanup proposal, or diff MUST NOT be the context that approves it.
- For cleanup/refactor/anti-slop work, verify that the artifact includes a cleanup plan, regression tests or an explicit test gap, smell-by-smell passes, and quality gates.
