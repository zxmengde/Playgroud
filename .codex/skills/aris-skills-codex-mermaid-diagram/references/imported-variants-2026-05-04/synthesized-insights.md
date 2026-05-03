# Synthesized Imported Variant Insights

This file is synthesized from full reads of disabled overlapping skills. Treat these notes as active guidance for the keeper skill, not as an archive. Read the source folders only when this synthesis is insufficient.

Keeper: aris-skills-codex-mermaid-diagram

## How To Apply

- Prefer the keeper skill workflow as the default path.
- Add the trigger phrases, verification checks, output contracts, and resource pointers below when they fit the task.
- If a disabled variant contains scripts, templates, references, examples, or assets, treat them as reusable resources from this keeper skill.
- Do not resurrect a disabled variant as a separate active skill unless the keeper cannot express its behavior cleanly.

## Source: aris-mermaid-diagram

Trigger/description delta: Generate Mermaid diagrams from user requirements. Saves .mmd and .md files to figures/ directory with syntax verification. Supports flowcharts, sequence diagrams, class diagrams, ER diagrams, Gantt charts, and 18 more diagram types.
Unique headings to preserve:
- Step 5: Claude STRICT Visual Review & Scoring (MANDATORY)
- Claude's STRICT Review of <diagram-name>
Actionable imported checks:
- **OUTPUT_DIR = `figures/`** — Output directory for all generated files
- [ ] ... (check ALL arrows)
- [ ] ... (check ALL blocks)
- **Print-friendly** — Must be readable in grayscale (many reviewers print papers)
- **Consistent sizing** — Similar components should have similar sizes
- **Dark colors** — Black or dark gray (#333333); avoid colored arrows
- **Labeled** — Every arrow should indicate what data flows through it
- **No crossings** — Reorganize layout to avoid arrow crossings
- **CORRECT DIRECTION** — Arrows must point to the RIGHT target!
- **Outputs**: Orange (#EA580C / #F97316)
- **Node labels with math MUST be quoted** — use `["$$...$$"]` or `("$$...$$")`:
- The `$$` delimiters must be **inside quoted strings** — unquoted `$$` will break parsing
- **Always verify rendering** with `mmdc` — some KaTeX expressions may not render in all environments
- Avoid special characters in labels that break Mermaid parsing (wrap in quotes if needed)
- **ALWAYS save files to `figures/` directory** — Never just output code in chat
- **ALWAYS generate BOTH `.mmd` and `.md` files** — They must contain identical Mermaid code
- **ALWAYS read the reference documentation** before generating code for a diagram type
- **ALWAYS verify syntax** — Run mmdc or manually validate before accepting
Workflow excerpt to incorporate:
```text
## Workflow: MUST EXECUTE ALL STEPS
### Step 0: Pre-flight Check
```bash
```
