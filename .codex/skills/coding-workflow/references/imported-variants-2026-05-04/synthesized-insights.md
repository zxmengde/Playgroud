# Synthesized Imported Variant Insights

This file is synthesized from full reads of disabled overlapping skills. Treat these notes as active guidance for the keeper skill, not as an archive. Read the source folders only when this synthesis is insufficient.

Keeper: coding-workflow

## How To Apply

- Prefer the keeper skill workflow as the default path.
- Add the trigger phrases, verification checks, output contracts, and resource pointers below when they fit the task.
- If a disabled variant contains scripts, templates, references, examples, or assets, treat them as reusable resources from this keeper skill.
- Do not resurrect a disabled variant as a separate active skill unless the keeper cannot express its behavior cleanly.

## Source: claude-scholar-bug-detective

Trigger/description delta: This skill should be used when the user asks to "debug this", "fix this error", "investigate this bug", "troubleshoot this issue", "find the problem", "something is broken", "this isn't working", "why is this failing", or reports errors/exceptions/bugs. Provides systematic debugging workflow and common error patterns.
Reusable resources: examples, references
Unique headings to preserve:
- Bug Detective
- Core Philosophy
- Debugging Workflow
- Step 1: Understand the Problem
- Step 2: Analyze Error Type
- Step 3: Locate the Problem Source
- Step 4: Form and Verify Hypotheses
- Step 5: Apply Fix
- Python Common Error Patterns
- 1. Indentation Errors
- 2. Mutable Default Arguments
- 3. Closure Issues in Loops
- 4. Modifying a List While Iterating
- 5. Using `is` for String Comparison
- 6. Forgetting to Call `super().__init__()`
- JavaScript/TypeScript Common Error Patterns
- 1. `this` Binding Issues
- 2. Async Error Handling
- 3. Object Reference Comparison
- Bash/Zsh Common Error Patterns
Actionable imported checks:
- **Gather evidence** - Collect error messages, logs, stack traces
- **Form hypotheses** - Infer possible causes based on evidence
- **Verify hypotheses** - Confirm or eliminate causes through experiments
- **Resolve the issue** - Apply fixes and verify
- Comment out half the code, check if the problem persists
- [ ] Check recent code changes
- [ ] Verify hypotheses

## Source: claude-scholar-code-review-excellence

Trigger/description delta: This skill should be used when the user asks to review a diff or pull request, write review comments, audit code quality, establish review standards, or improve how a team performs code review.
Reusable resources: assets, references, scripts
Unique headings to preserve:
- Code Review Excellence
- When to Use This Skill
- Core Principles
- 1. The Review Mindset
- 2. Effective Feedback
- 3. Review Scope
- Review Process
- Phase 1: Context Gathering (2-3 minutes)
- Phase 2: High-Level Review (5-10 minutes)
- Phase 3: Line-by-Line Review (10-20 minutes)
- Phase 4: Summary & Decision (2-3 minutes)
- Review Techniques
- Technique 1: The Checklist Method
- Security Checklist
- Performance Checklist
- Testing Checklist
- Technique 2: The Question Approach
- Technique 3: Suggest, Don't Command
- Use Collaborative Language
- Technique 4: Differentiate Severity
Actionable imported checks:
- Reviewing pull requests and code changes
- Establishing code review standards for teams
- Mentoring junior developers through reviews
- Conducting architecture reviews
- Creating review checklists and guidelines
- Reducing code review cycle time
- Check PR size (>400 lines? Ask to split)
- Review CI/CD status (tests passing?)
- Null/undefined checks?
- 🔄 Request Changes (must address)
- [ ] Authentication/authorization checked
- For large features, request design doc before code
- Review design with team before implementation
- Agree on approach to avoid rework
- **Review in Stages**
- Easier to review, faster to iterate
- [ ] Is authentication required where needed?
- [ ] Are authorization checks before every action?

## Source: omx-code-review

Trigger/description delta: Run a comprehensive code review
Unique headings to preserve:
- Code Review Skill
- When to Use
- GPT-5.5 Guidance Alignment
- Agent Delegation
- External Model Consultation (Preferred)
- Protocol
- When to Consult
- When to Skip
- Tool Usage
- Output Format
- Review Checklist
- Security
- Code Quality
- Performance
- Best Practices
- Architect Lane Checklist
- Approval Criteria
- Scenario Examples
- Use with Other Skills
- Best Practices
Actionable imported checks:
- User requests "review this code", "code review"
- Before merging a pull request
- After implementing a major feature
- Default to outcome-first progress and completion reporting: state the target result, evidence, validation status, and stop condition before adding process detail.
- If correctness depends on additional inspection, retrieval, execution, or verification, keep using the relevant tools until the review is grounded; stop once enough evidence exists.
- Determine scope of review (specific files or entire PR)
- **Launch Parallel Review Lanes**
- **`code-reviewer` lane** - owns spec compliance, security, code quality, performance, and maintainability findings
- Both lanes run in parallel and produce distinct outputs before final synthesis
- **Review Categories**
- **CRITICAL** - Security vulnerability (must fix before merge)
- **HIGH** - Bug or major code smell (should fix before merge)
- **WATCH** - Non-blocking design/tradeoff concern that must appear in the final synthesis
- Combine the `code-reviewer` recommendation and the architect status into one final verdict
- Else if `code-reviewer` recommendation is **REQUEST CHANGES**, final recommendation is **REQUEST CHANGES**
- Else final recommendation follows the `code-reviewer` lane
- The final report must make architect blockers impossible to miss
- Files reviewed count
Verification/output excerpt to incorporate:
```text
## Output Format
```
CODE REVIEW REPORT
==================
Files Reviewed: 8
Total Issues: 12
Architectural Status: WATCH
CRITICAL (0)
-----
(none)
HIGH (0)
--
(none)
MEDIUM (7)
----
1. src/api/auth.ts:42
   Issue: Email normalization logic is duplicated instead of reusing the shared helper
   Risk: Validation rules can drift between authentication paths
   Fix: Route both paths through the shared normalization helper
2. src/components/UserProfile.tsx:89
   Issue: Derived permissions are recalculated on every render
   Risk: Avoidable work during profile refreshes
```

## Source: omx-plugin-code-review

Trigger/description delta: Run a comprehensive code review
Unique headings to preserve:
- Code Review Skill
- When to Use
- GPT-5.5 Guidance Alignment
- Agent Delegation
- External Model Consultation (Preferred)
- Protocol
- When to Consult
- When to Skip
- Tool Usage
- Output Format
- Review Checklist
- Security
- Code Quality
- Performance
- Best Practices
- Architect Lane Checklist
- Approval Criteria
- Scenario Examples
- Use with Other Skills
- Best Practices
Actionable imported checks:
- User requests "review this code", "code review"
- Before merging a pull request
- After implementing a major feature
- Default to outcome-first progress and completion reporting: state the target result, evidence, validation status, and stop condition before adding process detail.
- If correctness depends on additional inspection, retrieval, execution, or verification, keep using the relevant tools until the review is grounded; stop once enough evidence exists.
- Determine scope of review (specific files or entire PR)
- **Launch Parallel Review Lanes**
- **`code-reviewer` lane** - owns spec compliance, security, code quality, performance, and maintainability findings
- Both lanes run in parallel and produce distinct outputs before final synthesis
- **Review Categories**
- **CRITICAL** - Security vulnerability (must fix before merge)
- **HIGH** - Bug or major code smell (should fix before merge)
- **WATCH** - Non-blocking design/tradeoff concern that must appear in the final synthesis
- Combine the `code-reviewer` recommendation and the architect status into one final verdict
- Else if `code-reviewer` recommendation is **REQUEST CHANGES**, final recommendation is **REQUEST CHANGES**
- Else final recommendation follows the `code-reviewer` lane
- The final report must make architect blockers impossible to miss
- Files reviewed count
Verification/output excerpt to incorporate:
```text
## Output Format
```
CODE REVIEW REPORT
==================
Files Reviewed: 8
Total Issues: 12
Architectural Status: WATCH
CRITICAL (0)
-----
(none)
HIGH (0)
--
(none)
MEDIUM (7)
----
1. src/api/auth.ts:42
   Issue: Email normalization logic is duplicated instead of reusing the shared helper
   Risk: Validation rules can drift between authentication paths
   Fix: Route both paths through the shared normalization helper
2. src/components/UserProfile.tsx:89
   Issue: Derived permissions are recalculated on every render
   Risk: Avoidable work during profile refreshes
```

## Source: omx-review

Trigger/description delta: Reviewer-only pass for /plan --review and cleanup artifact review
Unique headings to preserve:
- Review (Reviewer-Only Pass)
- Usage
- Behavior
- Guardrails
Actionable imported checks:
- Treat review as a reviewer-only pass. The authoring context may write the plan or cleanup proposal, but a separate reviewer context must issue the verdict.
- Return verdict: APPROVED, REVISE (with specific feedback), or REJECT (replanning required)
- If the current context authored the artifact, hand review to Critic or another reviewer role.
- Approval must cite concrete evidence, not author claims.
Workflow excerpt to incorporate:
```text
## Usage
```
/review
/review "path/to/plan.md"
```
```
