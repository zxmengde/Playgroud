# Synthesized Imported Variant Insights

This file is synthesized from full reads of disabled overlapping skills. Treat these notes as active guidance for the keeper skill, not as an archive. Read the source folders only when this synthesis is insufficient.

Keeper: aris-skills-codex-idea-discovery-robot

## How To Apply

- Prefer the keeper skill workflow as the default path.
- Add the trigger phrases, verification checks, output contracts, and resource pointers below when they fit the task.
- If a disabled variant contains scripts, templates, references, examples, or assets, treat them as reusable resources from this keeper skill.
- Do not resurrect a disabled variant as a separate active skill unless the keeper cannot express its behavior cleanly.

## Source: aris-idea-discovery-robot

Trigger/description delta: Workflow 1 adaptation for robotics and embodied AI. Orchestrates robotics-aware literature survey, idea generation, novelty check, and critical review to go from a broad robotics direction to benchmark-grounded, simulation-first ideas. Use when user says \"robotics idea discovery\", \"机器人找idea\", \"embodied AI idea\", \"机器人方向探索\", \"sim2real 选题\", or wants ideas for manipulation, locomotion, navigation, drones, humanoids, or general robot learning.
Actionable imported checks:
- **PILOT_MODE = `sim-first`** — Prefer simulation or offline-log pilots before any hardware execution
- **REAL_ROBOT_PILOTS = `explicit approval only`** — Never assume physical robot access or approval
- **AUTO_PROCEED = true** — If user does not respond at checkpoints, proceed with the best sim-first option
- **REVIEWER_MODEL = `gpt-5.4`** — External reviewer model via Codex MCP
- **TARGET_VENUES = CoRL, RSS, ICRA, IROS, RA-L** — Default novelty and reviewer framing
- recurring failure modes papers do not fix
- dependent on inaccessible hardware, custom sensors, or massive private datasets
- real robot execution is required but hardware access is unclear
- **analysis-only pilot** using existing benchmark outputs
- ask for explicit user confirmation before any real-robot step
- Reviewer score:
- [idea] — killed because benchmark unclear / hardware inaccessible / novelty weak / no fair evaluation
- Required baselines:
- Required metrics:
- Required failure cases:
- Whether real robot evidence is mandatory:
- [ ] Run /novelty-check on the final idea wording
- [ ] Only after approval: consider hardware validation

## Source: aris-skills-codex-gemini-review-idea-discovery-robot

Trigger/description delta: Workflow 1 adaptation for robotics and embodied AI. Orchestrates robotics-aware literature survey, idea generation, novelty check, and critical review to go from a broad robotics direction to benchmark-grounded, simulation-first ideas. Use when user says \\\"robotics idea discovery\\\", \\\"\u673a\u5668\u4eba\u627eidea\\\", \\\"embodied AI idea\\\", \\\"\u673a\u5668\u4eba\u65b9\u5411\u63a2\u7d22\\\", \\\"sim2real \u9009\u9898\\\", or wants ideas for manipulation, locomotion, navigation, drones, humanoids, or general robot learning.
Actionable imported checks:
- **PILOT_MODE = `sim-first`** — Prefer simulation or offline-log pilots before any hardware execution
- **REAL_ROBOT_PILOTS = `explicit approval only`** — Never assume physical robot access or approval
- **AUTO_PROCEED = true** — If user does not respond at checkpoints, proceed with the best sim-first option
- **REVIEWER_MODEL = `gemini-review`** — External reviewer route via the local `gemini-review` MCP bridge
- **TARGET_VENUES = CoRL, RSS, ICRA, IROS, RA-L** — Default novelty and reviewer framing
- recurring failure modes papers do not fix
- dependent on inaccessible hardware, custom sensors, or massive private datasets
- real robot execution is required but hardware access is unclear
- **analysis-only pilot** using existing benchmark outputs
- ask for explicit user confirmation before any real-robot step
- Reviewer score:
- [idea] — killed because benchmark unclear / hardware inaccessible / novelty weak / no fair evaluation
- Required baselines:
- Required metrics:
- Required failure cases:
- Whether real robot evidence is mandatory:
- [ ] Run /novelty-check on the final idea wording
- [ ] Only after approval: consider hardware validation
