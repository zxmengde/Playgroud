# Synthesized Imported Variant Insights

This file is synthesized from full reads of disabled overlapping skills. Treat these notes as active guidance for the keeper skill, not as an archive. Read the source folders only when this synthesis is insufficient.

Keeper: aris-skills-codex-paper-poster

## How To Apply

- Prefer the keeper skill workflow as the default path.
- Add the trigger phrases, verification checks, output contracts, and resource pointers below when they fit the task.
- If a disabled variant contains scripts, templates, references, examples, or assets, treat them as reusable resources from this keeper skill.
- Do not resurrect a disabled variant as a separate active skill unless the keeper cannot express its behavior cleanly.

## Source: aris-paper-poster

Trigger/description delta: Generate a conference poster (article + tcbposter LaTeX → A0/A1 PDF + editable PPTX + SVG) from a compiled paper. Use when user says \"做海报\", \"制作海报\", \"conference poster\", \"make poster\", \"生成poster\", \"poster session\", or wants to create a poster for a conference presentation.
Unique headings to preserve:
- Optional: Style reference (`— style-ref: <source>`, opt-in)
- Phase 6: Codex MCP Review
Actionable imported checks:
- **OUTPUT_DIR = `poster/`** — Output directory for all poster files.
- **REVIEWER_MODEL = `gpt-5.4`** — Model used via Codex MCP for poster review.
- **AUTO_PROCEED = false** — At each checkpoint, **always wait for explicit user confirmation**. Set `true` only if user explicitly requests fully autonomous mode.
- **Never pass `— style-ref` (or the cache contents) to the GPT-5.4 reviewer sub-agent** — the reviewer must judge the poster's clarity on its own merits.
- **Check prerequisites**:
- **Verify paper exists**:
- **Create output directory**: `mkdir -p poster/figures`
- **Check for resume**: read `poster/POSTER_STATE.json` if it exists
- **Tier 1 (must include)**: Architecture/method overview diagram, main results plot
- File not found → verify `poster/figures/` has the file (not a broken symlink)
- Claude reads the PNG and performs STRICT visual review
- Call `mcp__illustrator__run` with the specification
- Claude reviews the generated image for accuracy
- Issue 1: Title font too small (72pt → should be 84pt+)
- All critical checks pass
- **Reads content from the FINAL `main.tex`** — do NOT hardcode content separately
Workflow excerpt to incorporate:
```text
## Workflow
### Phase 0: Input Validation & Setup
1. **Check prerequisites**:
   ```bash
   which pdflatex && which latexmk
   ```
   **If LaTeX is NOT installed**, try in order:
   ```bash
   # Option 1: brew cask (requires sudo — may fail in non-interactive shells)
   brew install --cask mactex-no-gui
   # Option 2: BasicTeX (smaller, may still need sudo)
   brew install --cask basictex
   # Option 3: User-directory install (NO sudo needed — always works)
   curl -L https://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz | tar xz
   cd install-tl-*
   cat > texlive.profile << 'PROF'
   selected_scheme scheme-basic
   TEXDIR ~/texlive/YYYY
   TEXMFLOCAL ~/texlive/texmf-local
   TEXMFSYSCONFIG ~/texlive/YYYY/texmf-config
   TEXMFSYSVAR ~/texlive/YYYY/texmf-var
   TEXMFHOME ~/texmf
   binary_x86_64-darwin 1
   instopt_adjustpath 0
   instopt_adjustrepo 1
   instopt_write18_restricted 1
   tlpdbopt_autobackup 1
   tlpdbopt_install_docfiles 0
   tlpdbopt_install_srcfiles 0
   PROF
```

## Source: aris-skills-codex-gemini-review-paper-poster

Trigger/description delta: Generate a conference poster (article + tcbposter LaTeX → A0/A1 PDF + editable PPTX + SVG) from a compiled paper. Use when user says \"做海报\", \"制作海报\", \"conference poster\", \"make poster\", \"生成poster\", \"poster session\", or wants to create a poster for a conference presentation.
Unique headings to preserve:
- Phase 5: Visual Review via Gemini (Iterative Refinement)
- Phase 6: Gemini Review
Actionable imported checks:
- **OUTPUT_DIR = `poster/`** — Output directory for all poster files.
- **REVIEWER_MODEL = `gemini-review`** — Gemini reviewer invoked through the local `gemini-review` MCP bridge for poster review.
- **AUTO_PROCEED = false** — At each checkpoint, **always wait for explicit user confirmation**. Set `true` only if user explicitly requests fully autonomous mode.
- **Check prerequisites**:
- **Verify paper exists**:
- **Create output directory**: `mkdir -p poster/figures`
- **Check for resume**: read `poster/POSTER_STATE.json` if it exists
- **Tier 1 (must include)**: Architecture/method overview diagram, main results plot
- File not found → verify `poster/figures/` has the file (not a broken symlink)
- Call mcp__gemini-review__review_start with:
- Save the returned jobId and poll mcp__gemini-review__review_status until done=true
- Call `mcp__illustrator__run` with the specification
- Gemini reviews the generated image for accuracy via `mcp__gemini-review__review_start` with `imagePaths`
- Issue 1: Title font too small (72pt → should be 84pt+)
- All critical checks pass
- **Reads content from the FINAL `main.tex`** — do NOT hardcode content separately
Workflow excerpt to incorporate:
```text
## Workflow
### Phase 0: Input Validation & Setup
1. **Check prerequisites**:
   ```bash
   which pdflatex && which latexmk
   ```
   **If LaTeX is NOT installed**, try in order:
   ```bash
   # Option 1: brew cask (requires sudo — may fail in non-interactive shells)
   brew install --cask mactex-no-gui
   # Option 2: BasicTeX (smaller, may still need sudo)
   brew install --cask basictex
   # Option 3: User-directory install (NO sudo needed — always works)
   curl -L https://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz | tar xz
   cd install-tl-*
   cat > texlive.profile << 'PROF'
   selected_scheme scheme-basic
   TEXDIR ~/texlive/YYYY
   TEXMFLOCAL ~/texlive/texmf-local
   TEXMFSYSCONFIG ~/texlive/YYYY/texmf-config
   TEXMFSYSVAR ~/texlive/YYYY/texmf-var
   TEXMFHOME ~/texmf
   binary_x86_64-darwin 1
   instopt_adjustpath 0
   instopt_adjustrepo 1
   instopt_write18_restricted 1
   tlpdbopt_autobackup 1
   tlpdbopt_install_docfiles 0
   tlpdbopt_install_srcfiles 0
   PROF
```
