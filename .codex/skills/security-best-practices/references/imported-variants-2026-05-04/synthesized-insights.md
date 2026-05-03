# Synthesized Imported Variant Insights

This file is synthesized from full reads of disabled overlapping skills. Treat these notes as active guidance for the keeper skill, not as an archive. Read the source folders only when this synthesis is insufficient.

Keeper: security-best-practices

## How To Apply

- Prefer the keeper skill workflow as the default path.
- Add the trigger phrases, verification checks, output contracts, and resource pointers below when they fit the task.
- If a disabled variant contains scripts, templates, references, examples, or assets, treat them as reusable resources from this keeper skill.
- Do not resurrect a disabled variant as a separate active skill unless the keeper cannot express its behavior cleanly.

## Source: omx-plugin-security-review

Trigger/description delta: Run a comprehensive security review on code
Unique headings to preserve:
- Security Review Skill
- When to Use
- What It Does
- GPT-5.5 Guidance Alignment
- Agent Delegation
- External Model Consultation (Preferred)
- Protocol
- When to Consult
- When to Skip
- Tool Usage
- Output Format
- Security Checklist
- Authentication & Authorization
- Input Validation
- Output Encoding
- Secrets Management
- Cryptography
- Dependencies
- Severity Definitions
- Remediation Priority
Actionable imported checks:
- User requests "security review", "security audit"
- After writing code that handles user input
- After adding new API endpoints
- After modifying authentication/authorization logic
- Before deploying to production
- After adding external dependencies
- Default to outcome-first progress and completion reporting: state the target result, evidence, validation status, and stop condition before adding process detail.
- If correctness depends on additional inspection, retrieval, execution, or verification, keep using the relevant tools until the security review is grounded; stop once enough evidence exists.
- Tokens and credentials
- XSS prevention (output escaping)
- Check for outdated dependencies
- Input validation review
- Authentication/authorization review
- **Form your OWN security analysis FIRST** - Complete the review independently
- **Consult for validation** - Cross-check findings with Codex
- **Graceful fallback** - Never block if tools unavailable
- [ ] Session tokens cryptographically random
- [ ] JWT tokens properly signed and validated
Verification/output excerpt to incorporate:
```text
## Output Format
```
SECURITY REVIEW REPORT
======================
Scope: Entire codebase (42 files scanned)
Scan Date: 2026-01-24T14:30:00Z
CRITICAL (2)
------
1. src/api/auth.ts:89 - Hardcoded API Key
   Finding: AWS API key hardcoded in source code
   Impact: Credential exposure if code is public or leaked
   Remediation: Move to environment variables, rotate key immediately
   Reference: OWASP A02:2021 – Cryptographic Failures
2. src/db/query.ts:45 - SQL Injection Vulnerability
   Finding: User input concatenated directly into SQL query
   Impact: Attacker can execute arbitrary SQL commands
   Remediation: Use parameterized queries or ORM
   Reference: OWASP A03:2021 – Injection
HIGH (5)
--
3. src/auth/password.ts:22 - Weak Password Hashing
   Finding: Passwords hashed with MD5 (cryptographically broken)
   Impact: Passwords can be reversed via rainbow tables
```

## Source: omx-security-review

Trigger/description delta: Run a comprehensive security review on code
Unique headings to preserve:
- Security Review Skill
- When to Use
- What It Does
- GPT-5.5 Guidance Alignment
- Agent Delegation
- External Model Consultation (Preferred)
- Protocol
- When to Consult
- When to Skip
- Tool Usage
- Output Format
- Security Checklist
- Authentication & Authorization
- Input Validation
- Output Encoding
- Secrets Management
- Cryptography
- Dependencies
- Severity Definitions
- Remediation Priority
Actionable imported checks:
- User requests "security review", "security audit"
- After writing code that handles user input
- After adding new API endpoints
- After modifying authentication/authorization logic
- Before deploying to production
- After adding external dependencies
- Default to outcome-first progress and completion reporting: state the target result, evidence, validation status, and stop condition before adding process detail.
- If correctness depends on additional inspection, retrieval, execution, or verification, keep using the relevant tools until the security review is grounded; stop once enough evidence exists.
- Tokens and credentials
- XSS prevention (output escaping)
- Check for outdated dependencies
- Input validation review
- Authentication/authorization review
- **Form your OWN security analysis FIRST** - Complete the review independently
- **Consult for validation** - Cross-check findings with Codex
- **Graceful fallback** - Never block if tools unavailable
- [ ] Session tokens cryptographically random
- [ ] JWT tokens properly signed and validated
Verification/output excerpt to incorporate:
```text
## Output Format
```
SECURITY REVIEW REPORT
======================
Scope: Entire codebase (42 files scanned)
Scan Date: 2026-01-24T14:30:00Z
CRITICAL (2)
------
1. src/api/auth.ts:89 - Hardcoded API Key
   Finding: AWS API key hardcoded in source code
   Impact: Credential exposure if code is public or leaked
   Remediation: Move to environment variables, rotate key immediately
   Reference: OWASP A02:2021 – Cryptographic Failures
2. src/db/query.ts:45 - SQL Injection Vulnerability
   Finding: User input concatenated directly into SQL query
   Impact: Attacker can execute arbitrary SQL commands
   Remediation: Use parameterized queries or ORM
   Reference: OWASP A03:2021 – Injection
HIGH (5)
--
3. src/auth/password.ts:22 - Weak Password Hashing
   Finding: Passwords hashed with MD5 (cryptographically broken)
   Impact: Passwords can be reversed via rainbow tables
```
