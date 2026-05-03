---
name: uipro-design
description: "Use for non-UI visual asset production in the UIPro suite: logo design, corporate identity program mockups, icon sets, social photos, and multi-platform visual assets. Do not trigger for general UI/UX review, shadcn/Tailwind implementation, design tokens, slides, banners, or brand voice; those have dedicated skills."
license: MIT
metadata:
  role: stage_specialist
  author: claudekit
  version: "2.1.0"
---

# Design Asset Suite

## Trigger Boundary

This skill is the keeper for visual assets that are not already owned by a
more specific UIPro skill:

- logo generation and logo design briefs;
- corporate identity program mockups and deliverables;
- SVG icon sets;
- social image/photo assets.

Use dedicated skills instead for:

- `uipro-ui-ux-pro-max`: general UI/UX design, review, and product interface
  decisions;
- `uipro-ui-styling`: shadcn/ui, Tailwind, accessible component styling;
- `uipro-design-system`: tokens, component specs, CSS variables;
- `uipro-brand`: brand voice, visual identity standards, style guides;
- `uipro-slides`: strategic HTML presentations;
- `uipro-banner-design`: banners, covers, headers, and ads.

Visual asset production skill for logo, CIP, icons, and social images. It
keeps legacy UIPro asset-generation references available while more specific
skills own UI, brand, token, slide, and banner triggers.

## When to Use

- Logo design and AI generation
- Corporate identity program (CIP) deliverables
- Social photos for Instagram, Facebook, LinkedIn, Twitter, Pinterest, TikTok
- SVG icons and icon sets

Do not use this skill for brand voice, design tokens, UI implementation,
presentations, banners, or general UI/UX review. Those routes are owned by
`uipro-brand`, `uipro-design-system`, `uipro-ui-styling`, `uipro-slides`,
`uipro-banner-design`, and `uipro-ui-ux-pro-max`.

## Sub-skill Routing

| Task | Sub-skill | Details |
|------|-----------|---------|
| Brand identity, voice, assets | `uipro-brand` | Route away from this skill |
| Tokens, specs, CSS vars | `uipro-design-system` | Route away from this skill |
| shadcn/ui, Tailwind, code | `uipro-ui-styling` | Route away from this skill |
| Logo creation, AI generation | Logo (built-in) | `references/logo-design.md` |
| CIP mockups, deliverables | CIP (built-in) | `references/cip-design.md` |
| Presentations, pitch decks | `uipro-slides` | Route away from this skill |
| Banners, covers, headers | `uipro-banner-design` | Route away from this skill |
| Social media images/photos | Social Photos (built-in) | `references/social-photos-design.md` |
| SVG icons, icon sets | Icon (built-in) | `references/icon-design.md` |

## Logo Design (Built-in)

55+ styles, 30 color palettes, 25 industry guides. Gemini Nano Banana models.

### Logo: Generate Design Brief

```bash
python .codex/skills/uipro-design/scripts/logo/search.py "tech startup modern" --design-brief -p "BrandName"
```

### Logo: Search Styles/Colors/Industries

```bash
python .codex/skills/uipro-design/scripts/logo/search.py "minimalist clean" --domain style
python .codex/skills/uipro-design/scripts/logo/search.py "tech professional" --domain color
python .codex/skills/uipro-design/scripts/logo/search.py "healthcare medical" --domain industry
```

### Logo: Generate with AI

**ALWAYS** generate output logo images with white background.

```bash
python .codex/skills/uipro-design/scripts/logo/generate.py --brand "TechFlow" --style minimalist --industry tech
python .codex/skills/uipro-design/scripts/logo/generate.py --prompt "coffee shop vintage badge" --style vintage
```

**IMPORTANT:** When scripts fail, try to fix them directly.

After generation, **ALWAYS** ask user about HTML preview via `AskUserQuestion`. If yes, invoke `/ui-ux-pro-max` for gallery.

## CIP Design (Built-in)

50+ deliverables, 20 styles, 20 industries. Gemini Nano Banana (Flash/Pro).

### CIP: Generate Brief

```bash
python .codex/skills/uipro-design/scripts/cip/search.py "tech startup" --cip-brief -b "BrandName"
```

### CIP: Search Domains

```bash
python .codex/skills/uipro-design/scripts/cip/search.py "business card letterhead" --domain deliverable
python .codex/skills/uipro-design/scripts/cip/search.py "luxury premium elegant" --domain style
python .codex/skills/uipro-design/scripts/cip/search.py "hospitality hotel" --domain industry
python .codex/skills/uipro-design/scripts/cip/search.py "office reception" --domain mockup
```

### CIP: Generate Mockups

```bash
# With logo (RECOMMENDED)
python .codex/skills/uipro-design/scripts/cip/generate.py --brand "TopGroup" --logo /path/to/logo.png --deliverable "business card" --industry "consulting"

# Full CIP set
python .codex/skills/uipro-design/scripts/cip/generate.py --brand "TopGroup" --logo /path/to/logo.png --industry "consulting" --set

# Pro model (4K text)
python .codex/skills/uipro-design/scripts/cip/generate.py --brand "TopGroup" --logo logo.png --deliverable "business card" --model pro

# Without logo
python .codex/skills/uipro-design/scripts/cip/generate.py --brand "TechFlow" --deliverable "business card" --no-logo-prompt
```

Models: `flash` (default, `gemini-2.5-flash-image`), `pro` (`gemini-3-pro-image-preview`)

### CIP: Render HTML Presentation

```bash
python .codex/skills/uipro-design/scripts/cip/render-html.py --brand "TopGroup" --industry "consulting" --images /path/to/cip-output
```

**Tip:** If no logo exists, use Logo Design section above first.

## Routes Owned by Other UIPro Skills

- Slide decks and strategic HTML presentations route to `uipro-slides`.
- Banners, covers, headers, display ads, and campaign hero visuals route to
  `uipro-banner-design`.

Do not keep those tasks in this skill. This skill owns logo, CIP, icon, and
social-photo visual asset work.

## Icon Design (Built-in)

15 styles, 12 categories. Gemini 3.1 Pro Preview generates SVG text output.

### Icon: Generate Single Icon

```bash
python .codex/skills/uipro-design/scripts/icon/generate.py --prompt "settings gear" --style outlined
python .codex/skills/uipro-design/scripts/icon/generate.py --prompt "shopping cart" --style filled --color "#6366F1"
python .codex/skills/uipro-design/scripts/icon/generate.py --name "dashboard" --category navigation --style duotone
```

### Icon: Generate Batch Variations

```bash
python .codex/skills/uipro-design/scripts/icon/generate.py --prompt "cloud upload" --batch 4 --output-dir ./icons
```

### Icon: Multi-size Export

```bash
python .codex/skills/uipro-design/scripts/icon/generate.py --prompt "user profile" --sizes "16,24,32,48" --output-dir ./icons
```

### Icon: Top Styles

| Style | Best For |
|-------|----------|
| outlined | UI interfaces, web apps |
| filled | Mobile apps, nav bars |
| duotone | Marketing, landing pages |
| rounded | Friendly apps, health |
| sharp | Tech, fintech, enterprise |
| flat | Material design, Google-style |
| gradient | Modern brands, SaaS |

**Model:** `gemini-3.1-pro-preview` — text-only output (SVG is XML text). No image generation API needed.

## Social Photos (Built-in)

Multi-platform social image design: HTML/CSS -> screenshot export. Use
`uipro-ui-ux-pro-max` for design judgement, `uipro-brand` for brand rules,
`uipro-design-system` for token constraints, and Playwright/browser screenshots
for export.

Load `references/social-photos-design.md` for sizes, templates, best practices.

### Social Photos: Workflow

1. **Orchestrate** — create a short task list for independent platform sizes.
2. **Analyze** — Parse prompt: subject, platforms, style, brand context, content elements
3. **Ideate** — 3-5 concepts and choose one unless the user asked for variants.
4. **Design** — apply `uipro-brand`, `uipro-design-system`, and
   `uipro-ui-ux-pro-max`; create HTML per idea and size.
5. **Export** — Playwright/browser screenshot at exact px, with
   `deviceScaleFactor` when high-DPI output matters.
6. **Verify** — visually inspect exported designs; fix layout/styling issues
   and re-export.
7. **Organize** — keep outputs under the user's requested folder or a clear
   project output path.

### Social Photos: Key Sizes

| Platform | Size (px) | Platform | Size (px) |
|----------|-----------|----------|-----------|
| IG Post | 1080×1080 | FB Post | 1200×630 |
| IG Story | 1080×1920 | X Post | 1200×675 |
| IG Carousel | 1080×1350 | LinkedIn | 1200×627 |
| YT Thumb | 1280×720 | Pinterest | 1000×1500 |

## Workflows

### Complete Brand Package

1. **Logo** → `scripts/logo/generate.py` → Generate logo variants
2. **CIP** → `scripts/cip/generate.py --logo ...` → Create deliverable mockups
3. **Presentation** → route to `uipro-slides` when a pitch deck is requested.

### New Design System

1. **Brand** (`uipro-brand`) → Define colors, typography, voice.
2. **Tokens** (`uipro-design-system`) → Create semantic token layers.
3. **Implement** (`uipro-ui-styling`) → Configure Tailwind and shadcn/ui.

## References

| Topic | File |
|-------|------|
| Design Routing | `references/design-routing.md` |
| Logo Design Guide | `references/logo-design.md` |
| Logo Styles | `references/logo-style-guide.md` |
| Logo Colors | `references/logo-color-psychology.md` |
| Logo Prompts | `references/logo-prompt-engineering.md` |
| CIP Design Guide | `references/cip-design.md` |
| CIP Deliverables | `references/cip-deliverable-guide.md` |
| CIP Styles | `references/cip-style-guide.md` |
| CIP Prompts | `references/cip-prompt-engineering.md` |
| Social Photos Guide | `references/social-photos-design.md` |
| Icon Design Guide | `references/icon-design.md` |

## Scripts

| Script | Purpose |
|--------|---------|
| `scripts/logo/search.py` | Search logo styles, colors, industries |
| `scripts/logo/generate.py` | Generate logos with Gemini AI |
| `scripts/logo/core.py` | BM25 search engine for logo data |
| `scripts/cip/search.py` | Search CIP deliverables, styles, industries |
| `scripts/cip/generate.py` | Generate CIP mockups with Gemini |
| `scripts/cip/render-html.py` | Render HTML presentation from CIP mockups |
| `scripts/cip/core.py` | BM25 search engine for CIP data |
| `scripts/icon/generate.py` | Generate SVG icons with Gemini 3.1 Pro |

## Setup

```bash
export GEMINI_API_KEY="your-key"  # https://aistudio.google.com/apikey
pip install google-genai pillow
```

## Integration

**Related project skills:** `uipro-brand`, `uipro-design-system`,
`uipro-ui-styling`, `uipro-ui-ux-pro-max`, `uipro-banner-design`,
`uipro-slides`, `playwright`, `playwright-interactive`
