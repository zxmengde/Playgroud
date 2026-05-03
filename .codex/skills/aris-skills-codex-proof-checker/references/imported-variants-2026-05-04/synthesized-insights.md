# Synthesized Imported Variant Insights

This file is synthesized from full reads of disabled overlapping skills. Treat these notes as active guidance for the keeper skill, not as an archive. Read the source folders only when this synthesis is insufficient.

Keeper: aris-skills-codex-proof-checker

## How To Apply

- Prefer the keeper skill workflow as the default path.
- Add the trigger phrases, verification checks, output contracts, and resource pointers below when they fit the task.
- If a disabled variant contains scripts, templates, references, examples, or assets, treat them as reusable resources from this keeper skill.
- Do not resurrect a disabled variant as a separate active skill unless the keeper cannot express its behavior cleanly.

## Source: aris-proof-checker

Trigger/description delta: Rigorous mathematical proof verification and fixing workflow. Reads a LaTeX proof, identifies gaps via cross-model review (Codex GPT-5.4 xhigh), fixes each gap with full derivations, re-reviews, and generates an audit report. Use when user says "检查证明", "verify proof", "proof check", "审证明", "check this proof", or wants rigorous mathematical verification of a theory paper.
Unique headings to preserve:
- Phase 1 addendum — `--deep-fix` opt-in
- Phase 3.6: Theorem Restatement Regression (opt-in)
- Algorithm
- What this phase does NOT do
- Failure mode
- Deep-Fix Mode (opt-in)
- Why opt-in
- Effect when enabled
- When opt-in is appropriate
- Failure modes
- Opt-in flag discipline
- Optional: `details.deep_fix_plans` (only when `--deep-fix` is set)
- Optional: `details.restatement_drift` (only when `--restatement-check` is set)
Actionable imported checks:
- MAX_REVIEW_ROUNDS = 3
- REVIEWER_MODEL = `gpt-5.4` via Codex MCP, reasoning effort always `xhigh`
- **REVIEWER_BACKEND = `codex`** — Default: Codex MCP (xhigh). Override with `— reviewer: oracle-pro` for GPT-5.4 Pro via Oracle MCP. See `shared-references/reviewer-routing.md`.
- REPORT_TEX: `proof_audit_report.tex` (formal before/after PDF)
- STATE_FILE: `PROOF_CHECK_STATE.json` (for recovery)
- corrected_statement: the theorem/lemma statement as it should
- changed_equations: list of {before: <LaTeX>, after: <LaTeX>}
- closure_tests: 2-5 sanity checks the executor must run after
- zero_coupling_check: evaluate the expression at γ=0 (or the
- **ADD_REFERENCE**: Cite known result + verify its conditions apply
- DAG acyclicity check (no new cycles introduced)
- It does **not** fix drift automatically. The output is advisory; the executor or a follow-up `--deep-fix` run handles the rewrite.
- **Before/After logic chain**: Red (BEFORE) → Green (AFTER) comparison
- **Proof-obligation diff**: What was unverified before, what is verified now
- **Colored boxes**: BEFORE (red), AFTER (green), WHY WRONG (orange), KEY INSIGHT (blue), WARNING (yellow)
- The Phase 1 reviewer prompt is augmented with the deep-fix and algebra-sanity blocks; nothing in the original mandatory checklist or output format is removed.
- The top-level `verdict`, `reason_code`, and `summary` are **unchanged in shape and decision rule**: deep-fix output is advisory tooling for the executor, not a verdict-altering signal.
- Verifier gates and downstream skills (`paper-writing` Phase 6, `tools/verify_paper_audits.sh`) MUST treat absence of `deep_fix_plans` as the only valid default state and MUST NOT block on its presence or content.
Workflow excerpt to incorporate:
```text
## Workflow
### Phase 0: Preparation
1. **Locate the proof**: Find the main `.tex` file(s).
2. **Read the entire proof**: Extract list of all theorems/lemmas/propositions/corollaries/definitions/assumptions.
3. **Read reference materials**: Reference papers, prior results.
4. **Build a section map**: Structured list with line numbers and key claims.
5. **Identify the main theorem**: Central result, assumptions, claims.
```
