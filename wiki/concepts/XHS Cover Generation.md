---
type: concept
title: "XHS Cover Generation"
updated: 2026-04-18
tags:
  - design
  - xiaohongshu
  - cover-image
  - playwright
status: evergreen
related:
  - "[[xhs-claude-skills]]"
---

# XHS Cover Generation

The `/xhs-cover` skill in [[xhs-claude-skills]]. Generates 小红书 cover images from text via HTML+CSS rendered by Playwright.

## Specs

- **Dimensions:** 1080 x 1440px (3:4 ratio, XHS standard)
- **Text-dominant:** 70%+ of canvas is typography
- **Max 3 colors** per design (main + secondary + accent)
- **Chinese fonts:** weight 700-900 for readability

## 6 Styles

| Style | Palette | Best for |
|-------|---------|----------|
| **morandi** | Warm muted, low saturation | Knowledge sharing, methodology |
| **academic** | Cool blue, professional | Paper analysis, research |
| **dark** | Deep navy, neon accents | AI/coding/open-source |
| **mint** | Fresh green, clean | Tool reviews, productivity |
| **sunset** | Warm orange, energetic | Personal reflections, launches |
| **bw** | Minimal black & white | Opinions, deep thinking |

Auto-selects style based on content if `--style` not specified.

## Layout Elements

1. **Badge** (top-left): identity tag (e.g. "OPEN SOURCE", "论文解读")
2. **Title row**: main keyword 120-130px + secondary 110-120px
3. **Divider**: 80px gradient line
4. **Tagline**: subtitle 76-82px, letter-spacing 8px
5. **Chips**: 3 keyword tags
6. **Footer**: 3 keywords separated by `·`

## Pipeline

```
Text input → parse title/subtitle/tags
           → select style
           → generate HTML (/tmp/xhs-cover.html)
           → Playwright screenshot (1080x1440, no scrolling)
           → save to xhs/img/cover-{id}.png
```
