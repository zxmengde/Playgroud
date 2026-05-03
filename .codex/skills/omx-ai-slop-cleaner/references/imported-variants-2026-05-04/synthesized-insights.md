# Synthesized Imported Variant Insights

This file is synthesized from full reads of disabled overlapping skills. Treat these notes as active guidance for the keeper skill, not as an archive. Read the source folders only when this synthesis is insufficient.

Keeper: omx-ai-slop-cleaner

## How To Apply

- Prefer the keeper skill workflow as the default path.
- Add the trigger phrases, verification checks, output contracts, and resource pointers below when they fit the task.
- If a disabled variant contains scripts, templates, references, examples, or assets, treat them as reusable resources from this keeper skill.
- Do not resurrect a disabled variant as a separate active skill unless the keeper cannot express its behavior cleanly.

## Source: omx-plugin-ai-slop-cleaner

Trigger/description delta: Run an anti-slop cleanup/refactor/deslop workflow
Actionable imported checks:
- A user asks to “cleanup”, “refactor”, or “deslop” AI-generated output
- Follow-up implementation left duplicate code, dead code, weak boundaries, missing tests, fallback-like code, or unnecessary wrapper layers
- Keep outputs concise and evidence-dense unless risk or the user requests more detail.
- In the **Ralph workflow**, the mandatory deslop pass should run this skill on Ralph's changed files only, in standard mode unless the caller explicitly requests otherwise.
- Identify the behavior that must not change
- Add or run targeted regression tests before editing cleanup candidates
- For fallback-like code, cover the primary path and any preserved compatibility/fail-safe fallback before cleanup
- **Create a cleanup plan before code**
- Include fallback findings, classifications, and escalation status in the plan
- Do not start coding until the cleanup plan is explicit
- **Inventory fallback-like code before editing**
- Classify each finding before changing it:
- **Masking fallback slop** — hides errors or evidence, bypasses the primary contract, suppresses tests or validation, swallows failures, silently defaults, or adds untested alternate paths
- Prefer root-cause repair, deletion, boundary repair, or explicit failure behavior before preserving fallback paths
- For broad, ambiguous, cross-layer, or architectural fallback-like code, invoke `$ralplan` for consensus resolution before edits
- Recursion guard: when already inside ralplan, ralph, team, or another OMX workflow, do not spawn a nested `$ralplan`; record the finding and attach it to the active ralplan, leader, or plan handoff instead
- **Categorize issues before editing**
- **Fallback-like code** — masking fallbacks, workaround branches, bypasses, swallowed errors, silent defaults, broad shims, alternate execution paths
Workflow excerpt to incorporate:
```text
## Procedure
1. **Lock behavior with regression tests first**
   - Identify the behavior that must not change
   - Add or run targeted regression tests before editing cleanup candidates
   - If behavior is currently untested, create the narrowest test coverage needed first
   - For fallback-like code, cover the primary path and any preserved compatibility/fail-safe fallback before cleanup
2. **Create a cleanup plan before code**
   - List the specific smells to remove
   - Bound the pass to the requested files/scope
   - If a file list scope is provided, keep the pass restricted to that changed-files list
   - Include fallback findings, classifications, and escalation status in the plan
   - Order fixes from safest/highest-signal to riskiest
   - Do not start coding until the cleanup plan is explicit
3. **Inventory fallback-like code before editing**
   - Classify each finding before changing it:
     - **Masking fallback slop** — hides errors or evidence, bypasses the primary contract, suppresses tests or validation, swallows failures, silently defaults, or adds untested alternate paths
     - **Grounded compatibility/fail-safe fallback** — is scoped to an external/version/fail-safe boundary, documents the rationale, preserves failure evidence, and has regression tests for both the primary and fallback behavior
   - Prefer root-cause repair, deletion, boundary repair, or explicit failure behavior before preserving fallback paths
   - For broad, ambiguous, cross-layer, or architectural fallback-like code, invoke `$ralplan` for consensus resolution before edits
   - Recursion guard: when already inside ralplan, ralph, team, or another OMX workflow, do not spawn a nested `$ralplan`; record the finding and attach it to the active ralplan, leader, or plan handoff instead
4. **Categorize issues before editing**
   - **Fallback-like code** — masking fallbacks, workaround branches, bypasses, swallowed errors, silent defaults, broad shims, alternate execution paths
   - **Duplication** — repeated logic, copy-paste branches, redundant helpers
   - **Dead code** — unused code, unreachable branches, stale flags, debug leftovers
   - **Needless abstraction** — pass-through wrappers, speculative indirection, single-use helper layers
   - **Boundary violations** — hidden coupling, leaky responsibilities, wrong-layer imports or side effects
   - **Missing tests** — behavior not locked, weak regression coverage, gaps around edge cases
5. **Execute passes one smell at a time**
   - **Fallback-like code resolution gate** — remove masking fallback slop, repair root causes, or escalate ambiguous cases before continuing
```
Verification/output excerpt to incorporate:
```text
## Output Format
```text
AI SLOP CLEANUP REPORT
======================
Scope: [files or feature area]
Behavior Lock: [targeted regression tests added/run]
Cleanup Plan: [bounded smells and order]
Fallback Findings: [none, or finding -> masking fallback slop / grounded compatibility/fail-safe fallback -> escalation status]
Passes Completed:
- Fallback-like code resolution gate - [root-cause repair, explicit failure behavior, preserved grounded fallback, or ralplan handoff]
1. Pass 1: Dead code deletion - [concise fix]
2. Pass 2: Duplicate removal - [concise fix]
3. Pass 3: Naming/error handling cleanup - [concise fix]
4. Pass 4: Test reinforcement - [concise fix]
Quality Gates:
- Regression tests: PASS/FAIL
- Lint: PASS/FAIL
- Typecheck: PASS/FAIL
- Tests: PASS/FAIL
- Static/security scan: PASS/FAIL or N/A
Changed Files:
- [path] - [simplification]
```
