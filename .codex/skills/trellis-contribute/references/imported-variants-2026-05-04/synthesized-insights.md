# Synthesized Imported Variant Insights

This file is synthesized from full reads of disabled overlapping skills. Treat these notes as active guidance for the keeper skill, not as an archive. Read the source folders only when this synthesis is insufficient.

Keeper: trellis-contribute

## How To Apply

- Prefer the keeper skill workflow as the default path.
- Add the trigger phrases, verification checks, output contracts, and resource pointers below when they fit the task.
- If a disabled variant contains scripts, templates, references, examples, or assets, treat them as reusable resources from this keeper skill.
- Do not resurrect a disabled variant as a separate active skill unless the keeper cannot express its behavior cleanly.

## Source: trellis-.agents-skills-contribute

Trigger/description delta: Guide for contributing to Trellis documentation and marketplace. Covers adding spec templates, marketplace skills, documentation pages, and submitting PRs across both the Trellis main repo and docs repo. Use when someone wants to add a new spec template, add a new skill to the marketplace, add or update documentation pages, or submit a PR to this project.
Actionable imported checks:
- `verify-docs.py` checks docs.json and frontmatter
- Branch: `git checkout -b feat/your-contribution`
- [ ] Local preview tested (`pnpm dev`)
Verification/output excerpt to incorporate:
```text
# Verify docs structure
pnpm verify
# Format files
pnpm format
```
**Pre-commit hooks**: The project uses husky with lint-staged. On commit:
- Markdown files are auto-linted and formatted
- `verify-docs.py` checks docs.json and frontmatter
```

## Source: trellis-.claude-skills-contribute

Trigger/description delta: Guide for contributing to Trellis documentation and marketplace. Covers adding spec templates, marketplace skills, documentation pages, and submitting PRs across both the Trellis main repo and docs repo. Use when someone wants to add a new spec template, add a new skill to the marketplace, add or update documentation pages, or submit a PR to this project.
Actionable imported checks:
- `verify-docs.py` checks docs.json and frontmatter
- Branch: `git checkout -b feat/your-contribution`
- [ ] Local preview tested (`pnpm dev`)
Verification/output excerpt to incorporate:
```text
# Verify docs structure
pnpm verify
# Format files
pnpm format
```
**Pre-commit hooks**: The project uses husky with lint-staged. On commit:
- Markdown files are auto-linted and formatted
- `verify-docs.py` checks docs.json and frontmatter
```
