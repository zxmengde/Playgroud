# Synthesized Imported Variant Insights

This file is synthesized from full reads of disabled overlapping skills. Treat these notes as active guidance for the keeper skill, not as an archive. Read the source folders only when this synthesis is insufficient.

Keeper: aris-skills-codex-paper-compile

## How To Apply

- Prefer the keeper skill workflow as the default path.
- Add the trigger phrases, verification checks, output contracts, and resource pointers below when they fit the task.
- If a disabled variant contains scripts, templates, references, examples, or assets, treat them as reusable resources from this keeper skill.
- Do not resurrect a disabled variant as a separate active skill unless the keeper cannot express its behavior cleanly.

## Source: aris-paper-compile

Trigger/description delta: Compile LaTeX paper to PDF, fix errors, and verify output. Use when user says \"编译论文\", \"compile paper\", \"build PDF\", \"生成PDF\", or wants to compile LaTeX into a submission-ready PDF.
Actionable imported checks:
- [ ] **No supplementary mixed in**: appendix clearly after `\newpage\appendix`
- [ ] **No `[VERIFY]` markers**: search the PDF text for leftover markers
- [ ] Submit to [venue] via OpenReview / CMT / HotCRP
Workflow excerpt to incorporate:
```text
## Workflow
### Step 1: Verify Prerequisites
Check that the compilation environment is ready:
```bash
```
