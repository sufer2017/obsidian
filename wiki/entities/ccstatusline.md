---
type: entity
title: "ccstatusline"
updated: 2026-04-18
tags:
  - tool
  - claude-code
  - cli
  - terminal
status: evergreen
related:
  - "[[Matthew Breedlove]]"
  - "[[Claude Code CLI Ecosystem]]"
  - "[[Status Line Widgets]]"
  - "[[Terminal UI Configuration]]"
  - "[[Powerline Rendering]]"
  - "[[ccusage]]"
---

# ccstatusline

A highly customizable status line formatter for [[Claude Code CLI Ecosystem|Claude Code CLI]]. Displays real-time metrics — model info, git branch, token usage, session stats — in the terminal. Built by [[Matthew Breedlove]].

- **Repository:** [github.com/sirmalloc/ccstatusline](https://github.com/sirmalloc/ccstatusline)
- **Stars:** 7.8k | **Forks:** 331
- **Language:** TypeScript (98.5%)
- **License:** MIT
- **Latest:** v2.2.8

## Quick Start

```bash
npx -y ccstatusline@latest
```

No installation required. Zero-config sensible defaults.

## Core Capabilities

- **[[Status Line Widgets]]** — modular elements for model, git, tokens, environment
- **[[Powerline Rendering]]** — arrow separators, custom fonts, multi-line support
- **[[Terminal UI Configuration]]** — interactive TUI for real-time customization
- Smart terminal width detection with flex separators
- Cross-platform: Bun and Node.js

## Architecture

| Layer | Technology | Role |
|-------|-----------|------|
| TUI | React + Ink | Interactive configuration |
| Widgets | TypeScript modules | Individual status elements |
| Rendering | Custom engine | Widget definitions → ANSI output |
| Config | JSON | `~/.config/ccstatusline/settings.json` |

## Config Locations

- User settings: `~/.config/ccstatusline/settings.json`
- Claude integration: `~/.claude/settings.json`
- Runtime cache: `~/.cache/ccstatusline/block-cache-*.json`

## Related Tools

- [[ccusage]] — usage tracking, integrates via Custom Command widget
- tweakcc — Claude Code tweaking
- codachi — companion tool

## v2.2.8 Highlights

- Git PR widget with clickable links
- Expanded git widget suite (Status, Staged, Unstaged, SHA, fork detection, worktree)
- Claude Account Email widget
- Global Minimalist Mode
- Enhanced widget picker with substring/fuzzy matching
