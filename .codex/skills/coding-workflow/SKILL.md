---
name: coding-workflow
description: Use for codebase exploration, implementation, debugging, testing, refactoring, code review, project maps, dependency checks, Git-based work, and software engineering tasks in the controlled personal work system.
metadata:
  role: primary
---

# Coding Workflow

## Trigger

Use for codebase reading, implementation, debugging, tests, refactors, reviews, dependency checks, Git work, and project maps.

## Read

Read `docs/core.md`, `docs/workflows.md`, and `docs/profile.md`. For unfamiliar projects, read local `AGENTS.md`, README, manifests, test config, and relevant source files.

## Act

Build a lightweight project map when scope is broad. Follow existing style, keep changes scoped, do not revert user changes, and separate understanding, implementation, and verification.

## Daily Coding Guard

This skill absorbs the former `claude-scholar-daily-coding` checklist. For
ordinary code edits:

- read the target file before modifying it;
- understand nearby logic and the existing style first;
- keep the patch minimal and avoid unrelated features;
- preserve type safety where the language supports it;
- check obvious security risks such as path traversal, command injection, XSS,
  SQL injection, and hardcoded secrets;
- remove temporary debug output and throwaway files before reporting done.

## Output

Produce a patch, project map, review findings, test result, failure summary, or blocker.

## Verify

Run targeted tests, build, lint, direct scripts, or at minimum `git status` and a diff review. Explain any check that cannot run.




## Consolidated Coding / Debug / Review Merge

This keeper replaces `claude-scholar-bug-detective`,
`claude-scholar-code-review-excellence`, `omx-code-review`,
`omx-plugin-code-review`, and `omx-review`. Source copies stay under
`references/imported-variants-2026-05-04/` as rollback/deep reference only.

### Expanded Trigger Coverage

Use this skill for implementation, debugging, troubleshooting, PR/diff review,
architecture review, review-only critique, test repair, refactor planning, and
software quality audit.

### Debugging Workflow

1. Collect exact error text, stack trace, failing command, reproduction steps,
   expected behavior, actual behavior, environment, dependency versions, and
   recent changes.
2. Classify the failure type: syntax/import/type/null/index/network/permission,
   resource, async, shell quoting, race, state, or integration issue.
3. Form an explicit hypothesis and test it with the cheapest targeted check.
   Do not edit from pattern matching alone.
4. Locate the source by stack trace, code search, log tracing, debugger, binary
   search, or git bisect as appropriate.
5. Apply the narrowest fix, then verify the original failure, adjacent behavior,
   and regression risk. Add or update tests when the failure can recur.

### Code Review Workflow

1. Scope the review: changed files, user intent, linked issue/spec, test status,
   CI status when available, PR size, architectural boundaries, and
   security-sensitive surfaces.
2. Review in passes: high-level design and file organization first, then
   line-level correctness, security, performance, tests, and maintainability.
3. For large or high-risk changes, separate lanes conceptually: correctness and
   security; architecture/API/data flow; tests and regression. Synthesize one
   final verdict.
4. Do not spend review effort on formatting, import order, or trivial style when
   a formatter/linter should own it.
5. Every finding needs path/line evidence, concrete risk, and a repair direction.

### Review-Only Boundary

When the user asks for review, audit, critique, or plan review, default to a
review-only pass. Do not author and approve the same artifact in the same pass
unless the user explicitly asks for fixes. A review-only result must return one
of: `APPROVE`, `COMMENT`, `REVISE`, or `REQUEST CHANGES`, with evidence.

### Severity Contract

- `CRITICAL`: exploitable security issue, data loss, irreversible destructive
  operation, or production-breaking correctness failure.
- `HIGH`: reproducible bug, authorization/data-integrity risk, race condition,
  regression in a core path, or missing test for a critical path.
- `MEDIUM`: maintainability, performance, duplication, error handling, or test
  weakness that can plausibly cause future defects.
- `LOW`: non-blocking clarity, naming, documentation, or polish issue.
- `WATCH`: architectural tradeoff that is not blocking but must be visible in
  the final synthesis.

### Output Contracts

For debugging, report hypothesis, evidence, changed files, verification, and
remaining risk. For review, lead with findings ordered by severity, then open
questions, then a short summary. For fixes, report the failing evidence before
the patch and the passing evidence after the patch.
