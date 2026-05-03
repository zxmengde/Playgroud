# Synthesized Imported Variant Insights

This file is synthesized from full reads of disabled overlapping skills. Treat these notes as active guidance for the keeper skill, not as an archive. Read the source folders only when this synthesis is insufficient.

Keeper: aris-skills-codex-paper-plan

## How To Apply

- Prefer the keeper skill workflow as the default path.
- Add the trigger phrases, verification checks, output contracts, and resource pointers below when they fit the task.
- If a disabled variant contains scripts, templates, references, examples, or assets, treat them as reusable resources from this keeper skill.
- Do not resurrect a disabled variant as a separate active skill unless the keeper cannot express its behavior cleanly.

## Source: aris-paper-plan

Trigger/description delta: Generate a structured paper outline from review conclusions and experiment results. Use when user says \"写大纲\", \"paper outline\", \"plan the paper\", \"论文规划\", or wants to create a paper plan before writing.
Unique headings to preserve:
- Optional: Style reference (`— style-ref: <source>`, opt-in)
Actionable imported checks:
- **REVIEWER_MODEL = `gpt-5.4`** — Model used via Codex MCP for outline review. Must be an OpenAI model.
- **NARRATIVE_REPORT.md** or **STORY.md** — research narrative with claims and evidence
- **review-stage/AUTO_REVIEW.md** — auto-review loop conclusions *(fall back to `./AUTO_REVIEW.md` if not found)*
- Read `../shared-references/venue-checklists.md` before freezing the outline for a specific venue.
- Only load these references when needed; do not paste their full contents into the working draft.
- **Evidence** for each claim (which experiments, which metrics, which figures)
- **Known weaknesses** (from reviewer feedback)
- **Suggested framing** (from review conclusions)
- The paper should tell one coherent technical story.
- By the end of the Introduction, the outline should make the **What**, **Why**, and **So What** explicit.
- Front-load the most important material: title, abstract, introduction, and hero figure. Reviewers often form a judgment before reading the full method.
- **Evidence**: [what supports the claim]
- **Self-contained check**: can a reader understand this without the paper?
- **Contributions**: [2-4 numbered bullets, specific and falsifiable, matching Claims-Evidence Matrix]
- **Results preview**: [the strongest result or comparison to surface early]
- **Hero figure**: [describe what Figure 1 should show — MUST include clear comparison if applicable]
- **Front-loading check**: [would a skim reader know the main claim before reaching the method?]
- **Must NOT be just a list** — synthesize, compare, and position
Workflow excerpt to incorporate:
```text
## Workflow
### Step 1: Extract Claims and Evidence
If `CLAIMS_FROM_RESULTS.md` does not exist, extract claims from scratch:
Read all available narrative documents and extract:
1. **Core claims** (3-5 main contributions)
2. **One-sentence contribution** (the single sentence that best states what the paper contributes)
3. **Evidence** for each claim (which experiments, which metrics, which figures)
4. **Known weaknesses** (from reviewer feedback)
5. **Suggested framing** (from review conclusions)
Build a **Claims-Evidence Matrix**:
```markdown
| Claim | Evidence | Status | Section |
|-------|----------|--------|---------|
| [claim 1] | [exp A, metric B] | Supported | §3.2 |
| [claim 2] | [exp C] | Partially supported | §4.1 |
```
```

## Source: aris-skills-codex-claude-review-paper-plan

Trigger/description delta: Generate a structured paper outline from review conclusions and experiment results. Use when user says \"写大纲\", \"paper outline\", \"plan the paper\", \"论文规划\", or wants to create a paper plan before writing.
Actionable imported checks:
- **REVIEWER_MODEL = `claude-review`** — Claude reviewer invoked through the local `claude-review` MCP bridge. Set `CLAUDE_REVIEW_MODEL` if you need a specific Claude model override.
- **NARRATIVE_REPORT.md** or **STORY.md** — research narrative with claims and evidence
- **review-stage/AUTO_REVIEW.md** — auto-review loop conclusions *(fall back to `./AUTO_REVIEW.md` if not found)*
- **Evidence** for each claim (which experiments, which metrics, which figures)
- **Known weaknesses** (from reviewer feedback)
- **Suggested framing** (from review conclusions)
- **Self-contained check**: can a reader understand this without the paper?
- **Contributions**: [numbered list, matching Claims-Evidence Matrix]
- **Hero figure**: [describe what Figure 1 should show — MUST include clear comparison if applicable]
- **Must NOT be just a list** — synthesize, compare, and position
- **Limitations**: [honest assessment — reviewers value this]
- What the visual difference should demonstrate
- NEVER generate BibTeX from memory — always verify via search or existing .bib files
- Every citation must be verified: correct authors, year, venue
- Flag any citation you're unsure about with `[VERIFY]`
- Claim-evidence alignment — every claim backed?
- **Large file handling**: If the Write tool fails due to file size, immediately retry using Bash (`cat << 'EOF' > file`) to write in chunks. Do NOT ask the user for permission — just do it silently.
- **Do NOT generate author information** — leave author block as placeholder or anonymous
Workflow excerpt to incorporate:
```text
## Workflow
### Step 1: Extract Claims and Evidence
Read all available narrative documents and extract:
1. **Core claims** (3-5 main contributions)
2. **Evidence** for each claim (which experiments, which metrics, which figures)
3. **Known weaknesses** (from reviewer feedback)
4. **Suggested framing** (from review conclusions)
Build a **Claims-Evidence Matrix**:
```markdown
| Claim | Evidence | Status | Section |
|-------|----------|--------|---------|
| [claim 1] | [exp A, metric B] | Supported | §3.2 |
| [claim 2] | [exp C] | Partially supported | §4.1 |
```
```

## Source: aris-skills-codex-gemini-review-paper-plan

Trigger/description delta: Generate a structured paper outline from review conclusions and experiment results. Use when user says \"写大纲\", \"paper outline\", \"plan the paper\", \"论文规划\", or wants to create a paper plan before writing.
Actionable imported checks:
- **REVIEWER_MODEL = `gemini-review`** — Gemini reviewer invoked through the local `gemini-review` MCP bridge. Set `GEMINI_REVIEW_MODEL` if you need a specific Gemini model override.
- **NARRATIVE_REPORT.md** or **STORY.md** — research narrative with claims and evidence
- **review-stage/AUTO_REVIEW.md** — auto-review loop conclusions *(fall back to `./AUTO_REVIEW.md` if not found)*
- **Evidence** for each claim (which experiments, which metrics, which figures)
- **Known weaknesses** (from reviewer feedback)
- **Suggested framing** (from review conclusions)
- **Self-contained check**: can a reader understand this without the paper?
- **Contributions**: [numbered list, matching Claims-Evidence Matrix]
- **Hero figure**: [describe what Figure 1 should show — MUST include clear comparison if applicable]
- **Must NOT be just a list** — synthesize, compare, and position
- **Limitations**: [honest assessment — reviewers value this]
- What the visual difference should demonstrate
- NEVER generate BibTeX from memory — always verify via search or existing .bib files
- Every citation must be verified: correct authors, year, venue
- Flag any citation you're unsure about with `[VERIFY]`
- Claim-evidence alignment — every claim backed?
- **Large file handling**: If the Write tool fails due to file size, immediately retry using Bash (`cat << 'EOF' > file`) to write in chunks. Do NOT ask the user for permission — just do it silently.
- **Do NOT generate author information** — leave author block as placeholder or anonymous
Workflow excerpt to incorporate:
```text
## Workflow
### Step 1: Extract Claims and Evidence
Read all available narrative documents and extract:
1. **Core claims** (3-5 main contributions)
2. **Evidence** for each claim (which experiments, which metrics, which figures)
3. **Known weaknesses** (from reviewer feedback)
4. **Suggested framing** (from review conclusions)
Build a **Claims-Evidence Matrix**:
```markdown
| Claim | Evidence | Status | Section |
|-------|----------|--------|---------|
| [claim 1] | [exp A, metric B] | Supported | §3.2 |
| [claim 2] | [exp C] | Partially supported | §4.1 |
```
```
