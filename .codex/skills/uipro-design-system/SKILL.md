---
name: uipro-design-system
description: "Use for design-token architecture, component specifications, CSS variables, primitive/semantic/component tokens, spacing and typography scales, state definitions, and design-to-code handoff. Do not trigger for slide generation; use `uipro-slides` for presentations."
license: MIT
metadata:
  role: stage_specialist
  author: claudekit
  version: "1.0.0"
---

# Design System

Token architecture, component specifications, and systematic design handoff.

## When to Use

- Design token creation
- Component state definitions
- CSS variable systems
- Spacing/typography scales
- Design-to-code handoff
- Tailwind theme configuration

Use `uipro-slides` for slide or presentation generation. This skill may provide
tokens to that workflow, but it is not the slide keeper.

## Token Architecture

Load: `references/token-architecture.md`

### Three-Layer Structure

```
Primitive (raw values)
       ↓
Semantic (purpose aliases)
       ↓
Component (component-specific)
```

**Example:**
```css
/* Primitive */
--color-blue-600: #2563EB;

/* Semantic */
--color-primary: var(--color-blue-600);

/* Component */
--button-bg: var(--color-primary);
```

## Quick Start

**Generate tokens:**
```bash
node scripts/generate-tokens.cjs --config tokens.json -o tokens.css
```

**Validate usage:**
```bash
node scripts/validate-tokens.cjs --dir src/
```

## References

| Topic | File |
|-------|------|
| Token Architecture | `references/token-architecture.md` |
| Primitive Tokens | `references/primitive-tokens.md` |
| Semantic Tokens | `references/semantic-tokens.md` |
| Component Tokens | `references/component-tokens.md` |
| Component Specs | `references/component-specs.md` |
| States & Variants | `references/states-and-variants.md` |
| Tailwind Integration | `references/tailwind-integration.md` |

## Component Spec Pattern

| Property | Default | Hover | Active | Disabled |
|----------|---------|-------|--------|----------|
| Background | primary | primary-dark | primary-darker | muted |
| Text | white | white | white | muted-fg |
| Border | none | none | none | muted-border |
| Shadow | sm | md | none | none |

## Scripts

| Script | Purpose |
|--------|---------|
| `generate-tokens.cjs` | Generate CSS from JSON token config |
| `validate-tokens.cjs` | Check for hardcoded values in code |
| `search-slides.py` | BM25 search + contextual recommendations |
| `slide-token-validator.py` | Validate slide HTML for token compliance |
| `fetch-background.py` | Fetch images from Pexels/Unsplash |

## Templates

| Template | Purpose |
|----------|---------|
| `design-tokens-starter.json` | Starter JSON with three-layer structure |

## Integration

**With `uipro-brand`:** Extract primitives from brand colors/typography.
**With `uipro-ui-styling`:** Component tokens become Tailwind config and
component classes.

**Skill Dependencies:** `uipro-brand`, `uipro-ui-styling`

## Handoff to Slides

Use `uipro-slides` when the deliverable is a deck or slide HTML. This skill
only supplies token constraints to that workflow:

- slides should import the project's design-token CSS when it exists;
- slide colors, typography, spacing, and chart styling should use token names
  instead of raw one-off values;
- token validation belongs here, while deck structure, slide copy, Chart.js
  layout, and presentation generation belong to `uipro-slides`.

### Token Compliance Example

```css
/* CORRECT - uses token */
background: var(--slide-bg);
color: var(--color-primary);
font-family: var(--typography-font-heading);

/* WRONG - hardcoded */
background: #0D0D0D;
color: #FF6B6B;
font-family: 'Space Grotesk';
```

## Best Practices

1. Never use raw hex in components - always reference tokens
2. Semantic layer enables theme switching (light/dark)
3. Component tokens enable per-component customization
4. Use HSL format for opacity control
5. Document every token's purpose
6. For slide decks, route generation to `uipro-slides` and keep this skill to
   token constraints.
