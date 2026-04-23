# ccstatusline — GitHub Repository Dump

> Source: https://github.com/sirmalloc/ccstatusline
> Fetched: 2026-04-18
> Type: GitHub repository

## Overview

ccstatusline is a highly customizable status line formatter for Claude Code CLI. It displays real-time metrics including model information, git branch details, token usage, and session metrics in the terminal.

- **Stars:** 7.8k
- **Forks:** 331
- **Language:** TypeScript (98.5%), JavaScript (1.5%)
- **License:** MIT
- **Author:** Matthew Breedlove (@sirmalloc)

## Key Features

- Real-time metrics display with fully customizable widget configuration
- Powerline-style rendering support with arrow separators and custom fonts
- Multi-line status line support
- Interactive TUI configuration interface
- Cross-platform compatibility (Bun and Node.js)
- Smart terminal width detection with flex separators
- Zero-config sensible defaults

## Installation

```bash
npx -y ccstatusline@latest
bunx -y ccstatusline@latest
```

## Recent Updates (v2.2.8)

- Git PR widget with clickable links
- Expanded git widget suite (Status, Staged, Unstaged, SHA, etc.)
- Claude Account Email widget
- Global Minimalist Mode toggle
- Enhanced widget picker with substring/fuzzy matching
- Improved terminal width detection

## Widget Categories

### Claude & Session Widgets
Model info, session identifiers, thinking effort, vim mode, skill activity, session duration, costs.

### Git Widgets
Branch, repo changes, status indicators, remote metadata, worktree info, commit details. GitHub links and upstream tracking.

### Tokens & Usage Widgets
Input/output/cached token counts, throughput speeds (configurable rolling windows 0-120s), context usage percentages, session/weekly usage metrics.

### Environment & Custom Widgets
Current directory, terminal width, memory usage, custom text/symbols, command output, hyperlinks.

## Configuration

Settings auto-save to `~/.config/ccstatusline/settings.json`.
Supports custom Claude config via `CLAUDE_CONFIG_DIR` env var and proxy via `HTTPS_PROXY`.

### Widget Editor Keybinds
- Arrow keys: navigation
- Enter: toggle move mode
- a: add widgets, i: insert, d: delete, c: clear lines, r: toggle raw value
- Git Branch: l toggles GitHub links
- Context widgets: u toggles used vs remaining
- Custom Command: e edits command, w sets max width, t adjusts timeout
- Current Working Dir: h abbreviates home, s edits segments, f enables fish-style paths

### Terminal Width Options
1. Full width always
2. Full width minus 40 (default)
3. Dynamic switching based on context threshold (default 60%)

### Global Options
Default padding, separator insertion, color inheritance, bold formatting, minimalist mode, fg/bg color overrides.

## Architecture

- **TUI Layer**: React/Ink-based configuration interface
- **Widget System**: Modular status line elements
- **Rendering Engine**: Widget definitions → terminal output
- **Configuration Management**: JSON-based settings with Claude Code integration

### Tech Stack
- Runtime: Node.js 14+ or Bun (v1.0+)
- Language: TypeScript with strict type checking
- UI Framework: React with Ink for terminal rendering
- Note: ink@6.2.0 is patched to fix backspace handling on macOS terminals

### Config File Locations
- User settings: `~/.config/ccstatusline/settings.json`
- Claude integration: `~/.claude/settings.json`
- Runtime cache: `~/.cache/ccstatusline/block-cache-*.json`

## Related Projects
tweakcc, ccusage, codachi

## Integration: ccusage
Custom Command widget: `npx -y ccusage@latest statusline` with 5000ms timeout and color preservation.
