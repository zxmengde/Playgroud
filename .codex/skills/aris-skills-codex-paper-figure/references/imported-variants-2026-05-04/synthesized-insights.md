# Synthesized Imported Variant Insights

This file is synthesized from full reads of disabled overlapping skills. Treat these notes as active guidance for the keeper skill, not as an archive. Read the source folders only when this synthesis is insufficient.

Keeper: aris-skills-codex-paper-figure

## How To Apply

- Prefer the keeper skill workflow as the default path.
- Add the trigger phrases, verification checks, output contracts, and resource pointers below when they fit the task.
- If a disabled variant contains scripts, templates, references, examples, or assets, treat them as reusable resources from this keeper skill.
- Do not resurrect a disabled variant as a separate active skill unless the keeper cannot express its behavior cleanly.

## Source: aris-paper-figure

Trigger/description delta: Generate publication-quality figures and tables from experiment results. Use when user says \"画图\", \"作图\", \"generate figures\", \"paper figures\", or needs plots for a paper.
Actionable imported checks:
- **DPI = 300** — Output resolution
- **FORMAT = `pdf`** — Output format. Options: `pdf` (vector, best for LaTeX), `png` (raster fallback)
- **FIG_DIR = `figures/`** — Output directory for generated figures
- **REVIEWER_MODEL = `gpt-5.4`** — Model used via Codex MCP for figure quality review.
- This skill can generate a rough TikZ skeleton as a starting point, but **do not expect publication-quality results**
- [ ] PDF output is vector (not rasterized text)
- [ ] Colorblind-accessible (if using colorblind palette)
- **Every figure must be reproducible** — save the generation script alongside the output
- **Do NOT hardcode data** — always read from JSON/CSV files
- **Use vector format (PDF)** for all plots — PNG only as fallback
- **Colorblind-safe** — verify with https://davidmathlogic.com/colorblind/ if needed
Workflow excerpt to incorporate:
```text
## Workflow
### Step 1: Read Figure Plan
Parse the Figure Plan table from PAPER_PLAN.md:
```markdown
| ID | Type | Description | Data Source | Priority |
|----|------|-------------|-------------|----------|
| Fig 1 | Architecture | ... | manual | HIGH |
| Fig 2 | Line plot | ... | figures/exp.json | HIGH |
```
Identify:
- Which figures can be auto-generated from data
- Which need manual creation (architecture diagrams, etc.)
- Which are comparison tables (generate as LaTeX)
```

## Source: aris-skills-codex-claude-review-paper-figure

Trigger/description delta: Generate publication-quality figures and tables from experiment results. Use when user says \"画图\", \"作图\", \"generate figures\", \"paper figures\", or needs plots for a paper.
Unique headings to preserve:
- Output Protocols
Actionable imported checks:
- **DPI = 300** — Output resolution
- **FORMAT = `pdf`** — Output format. Options: `pdf` (vector, best for LaTeX), `png` (raster fallback)
- **FIG_DIR = `figures/`** — Output directory for generated figures
- **REVIEWER_MODEL = `claude-review`** — Claude reviewer invoked through the local `claude-review` MCP bridge. Set `CLAUDE_REVIEW_MODEL` if you need a specific Claude model override.
- This skill can generate a rough TikZ skeleton as a starting point, but **do not expect publication-quality results**
- [ ] PDF output is vector (not rasterized text)
- [ ] Colorblind-accessible (if using colorblind palette)
- **Every figure must be reproducible** — save the generation script alongside the output
- **Do NOT hardcode data** — always read from JSON/CSV files
- **Use vector format (PDF)** for all plots — PNG only as fallback
- **Colorblind-safe** — verify with https://davidmathlogic.com/colorblind/ if needed
Workflow excerpt to incorporate:
```text
## Workflow
### Step 1: Read Figure Plan
Parse the Figure Plan table from PAPER_PLAN.md:
```markdown
| ID | Type | Description | Data Source | Priority |
|----|------|-------------|-------------|----------|
| Fig 1 | Architecture | ... | manual | HIGH |
| Fig 2 | Line plot | ... | figures/exp.json | HIGH |
```
Identify:
- Which figures can be auto-generated from data
- Which need manual creation (architecture diagrams, etc.)
- Which are comparison tables (generate as LaTeX)
```

## Source: aris-skills-codex-gemini-review-paper-figure

Trigger/description delta: Generate publication-quality figures and tables from experiment results. Use when user says \"画图\", \"作图\", \"generate figures\", \"paper figures\", or needs plots for a paper.
Unique headings to preserve:
- Output Protocols
Actionable imported checks:
- **DPI = 300** — Output resolution
- **FORMAT = `pdf`** — Output format. Options: `pdf` (vector, best for LaTeX), `png` (raster fallback)
- **FIG_DIR = `figures/`** — Output directory for generated figures
- **REVIEWER_MODEL = `gemini-review`** — Gemini reviewer invoked through the local `gemini-review` MCP bridge. Set `GEMINI_REVIEW_MODEL` if you need a specific Gemini model override.
- This skill can generate a rough TikZ skeleton as a starting point, but **do not expect publication-quality results**
- [ ] PDF output is vector (not rasterized text)
- [ ] Colorblind-accessible (if using colorblind palette)
- **Every figure must be reproducible** — save the generation script alongside the output
- **Do NOT hardcode data** — always read from JSON/CSV files
- **Use vector format (PDF)** for all plots — PNG only as fallback
- **Colorblind-safe** — verify with https://davidmathlogic.com/colorblind/ if needed
Workflow excerpt to incorporate:
```text
## Workflow
### Step 1: Read Figure Plan
Parse the Figure Plan table from PAPER_PLAN.md:
```markdown
| ID | Type | Description | Data Source | Priority |
|----|------|-------------|-------------|----------|
| Fig 1 | Architecture | ... | manual | HIGH |
| Fig 2 | Line plot | ... | figures/exp.json | HIGH |
```
Identify:
- Which figures can be auto-generated from data
- Which need manual creation (architecture diagrams, etc.)
- Which are comparison tables (generate as LaTeX)
```
