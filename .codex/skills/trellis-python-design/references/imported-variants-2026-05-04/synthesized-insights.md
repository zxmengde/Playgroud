# Synthesized Imported Variant Insights

This file is synthesized from full reads of disabled overlapping skills. Treat these notes as active guidance for the keeper skill, not as an archive. Read the source folders only when this synthesis is insufficient.

Keeper: trellis-python-design

## How To Apply

- Prefer the keeper skill workflow as the default path.
- Add the trigger phrases, verification checks, output contracts, and resource pointers below when they fit the task.
- If a disabled variant contains scripts, templates, references, examples, or assets, treat them as reusable resources from this keeper skill.
- Do not resurrect a disabled variant as a separate active skill unless the keeper cannot express its behavior cleanly.

## Source: trellis-.agents-skills-python-design

Trigger/description delta: Python design patterns for CLI scripts and utilities — type-first development, deep modules, complexity management, and red flags. Use when reading, writing, reviewing, or refactoring Python files, especially in .trellis/scripts/ or any CLI/scripting context. Also activate when planning module structure, deciding where to put new code, or doing code review.
Actionable imported checks:
- Code review of Python changes
- **Cognitive Load** — You must hold too much context to make a safe change
- **Implement to satisfy types** — let the type checker guide completeness
- **Validate at boundaries** — runtime checks only where data enters the system
- Returning raw `subprocess.CompletedProcess` and letting callers check `.returncode`
- Raising generic exceptions that callers must parse
- Using configuration parameters to avoid making decisions

## Source: trellis-.claude-skills-python-design

Trigger/description delta: Python design patterns for CLI scripts and utilities — type-first development, deep modules, complexity management, and red flags. Use when reading, writing, reviewing, or refactoring Python files, especially in .trellis/scripts/ or any CLI/scripting context. Also activate when planning module structure, deciding where to put new code, or doing code review.
Actionable imported checks:
- Code review of Python changes
- **Cognitive Load** — You must hold too much context to make a safe change
- **Implement to satisfy types** — let the type checker guide completeness
- **Validate at boundaries** — runtime checks only where data enters the system
- Returning raw `subprocess.CompletedProcess` and letting callers check `.returncode`
- Raising generic exceptions that callers must parse
- Using configuration parameters to avoid making decisions
