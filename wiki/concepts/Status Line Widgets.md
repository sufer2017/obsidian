---
type: concept
title: "Status Line Widgets"
updated: 2026-04-18
tags:
  - widgets
  - terminal
  - claude-code
status: evergreen
related:
  - "[[ccstatusline]]"
  - "[[Terminal UI Configuration]]"
  - "[[Powerline Rendering]]"
---

# Status Line Widgets

Modular elements that compose the [[ccstatusline]] status bar. Each widget renders a specific piece of real-time information.

## Widget Categories

### Claude & Session
- **Model** — current model name (e.g. Claude Opus 4.6)
- **Session ID** — active session identifier
- **Thinking Effort** — thinking budget indicator
- **Vim Mode** — current vim mode state
- **Skill Activity** — active skill indicator
- **Session Duration** — elapsed time
- **Cost** — session cost tracking

### Git
- **Branch** — current branch name (with optional GitHub link via `l` key)
- **Status / Staged / Unstaged** — working tree state
- **SHA** — current commit hash
- **PR** — pull request with clickable links (v2.2.8+)
- **Fork Detection / Worktree** — advanced git state
- **Remote / Upstream** — tracking info

### Tokens & Usage
- **Input / Output / Cached** — token counts
- **Throughput Speed** — tokens/sec with rolling window (0-120s configurable)
- **Context Usage** — percentage of context window used (`u` toggles used vs remaining)
- **Session / Weekly Usage** — aggregate metrics

### Environment & Custom
- **Current Directory** — cwd with fish-style paths (`f` key), home abbreviation (`h`)
- **Terminal Width** — current terminal columns
- **Memory Usage** — process memory
- **Custom Text / Symbol** — static labels or emoji markers
- **Custom Command** — execute shell commands, receive Claude Code JSON via stdin
- **Link** — OSC 8 hyperlinks with fallback

## Raw Value Mode

Any widget can strip its label: "Model: Claude 3.5 Sonnet" → "Claude 3.5 Sonnet". Toggle with `r` key.

## Block Timer Widget

Tracks 5-hour conversation block progress. Three modes: time display, full 32-char progress bar, compact 16-char bar.

## Smart Truncation

Status lines auto-truncate with ellipsis when exceeding terminal width, preserving ANSI and OSC 8 formatting integrity.
