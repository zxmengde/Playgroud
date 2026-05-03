---
name: trellis-check
description: "Validates recently written code against project-specific development guidelines from .trellis/spec/. Identifies changed files via git diff, discovers applicable spec modules, runs lint and typecheck, and reports guideline violations. Use when code is written and needs quality verification, to catch context drift during long sessions, or before committing changes."
metadata:
  role: command_adapter
---

> Compatibility: this project skill was shortened from `trellis-packages-cli-src-templates-codex-skills-check`; route old references here.


Check if the code you just wrote follows the development guidelines.

Execute these steps:

1. **Identify changed files**:
   ```bash
   git diff --name-only HEAD
   ```

2. **Determine which spec modules apply** based on the changed file paths:
   ```bash
   python3 ./.trellis/scripts/get_context.py --mode packages
   ```

3. **Read the spec index** for each relevant module:
   ```bash
   cat .trellis/spec/<package>/<layer>/index.md
   ```
   Follow the **"Quality Check"** section in the index.

4. **Read the specific guideline files** referenced in the Quality Check section (e.g., `quality-guidelines.md`, `conventions.md`). The index is NOT the goal — it points you to the actual guideline files. Read those files and review your code against them.

5. **Run lint and typecheck** for the affected package.

6. **Report any violations** and fix them if found.



## Merged Trellis Check Rules

Apply these rules for post-change verification. They are synthesized from non-Codex Trellis check variants.

- Verify changed files against applicable project specs, not just generic lint/test output.
- Include cross-layer checks when a change touches shared constants, config, API contracts, schema, UI data flow, or utility functions.
- Check for missed update sites, duplicated constants, import path drift, type mismatches, and same-layer inconsistency.
- Treat tests as evidence for behavior, not as a substitute for reading the changed code and adjacent contracts.
- Read references/imported-variants-2026-05-04/synthesized-insights.md when changes span multiple layers or when context drift is suspected.

## Consolidated Trellis Skill Merge

Replaces the platform-specific `trellis-check` duplicates.

### Retained Rules
- Start by identifying changed files and current git status.
- Re-read applicable specs for changed packages/layers before judging compliance.
- Run project lint, typecheck, tests, and relevant checks; fix failures before proceeding.
- Check test coverage for new functions, bug fixes, changed behavior, and regression paths.
- For cross-layer changes, trace read/write data flow, schemas, errors, imports, dependencies, reuse, and same-layer consistency.
- If a non-obvious lesson was learned, update `.trellis/spec/` rather than leaving it in chat.
