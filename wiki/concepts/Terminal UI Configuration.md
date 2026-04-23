---
type: concept
title: "Terminal UI Configuration"
updated: 2026-04-18
tags:
  - tui
  - configuration
  - terminal
status: evergreen
related:
  - "[[ccstatusline]]"
  - "[[Status Line Widgets]]"
  - "[[Powerline Rendering]]"
---

# Terminal UI Configuration

[[ccstatusline]]'s interactive TUI for customizing the status line in real time. Built with React + Ink.

## How It Launches

- **Interactive mode**: runs when no stdin is piped (just run `npx -y ccstatusline@latest`)
- **Piped mode**: parses Claude Code status JSON from stdin

## Widget Editor Keybinds

| Key | Action |
|-----|--------|
| Arrow keys | Navigate widgets |
| Enter | Toggle move mode |
| `a` | Add widget |
| `i` | Insert widget |
| `d` | Delete widget |
| `c` | Clear line |
| `r` | Toggle raw value mode |

### Widget-Specific Keys

| Widget | Key | Action |
|--------|-----|--------|
| Git Branch | `l` | Toggle GitHub links |
| Git Root Dir | `l` | Cycle IDE links |
| Context | `u` | Toggle used vs remaining |
| Custom Command | `e` | Edit command |
| Custom Command | `w` | Set max width |
| Custom Command | `t` | Adjust timeout |
| Current Dir | `h` | Abbreviate home |
| Current Dir | `s` | Edit segments |
| Current Dir | `f` | Fish-style paths |

## Global Options

- Default padding between widgets
- Automatic separator insertion
- Color inheritance from adjacent widgets
- Bold formatting toggle
- Global Minimalist Mode (v2.2.8+)
- Foreground / background color overrides

## Terminal Width Handling

1. Full width always
2. Full width minus 40 (default)
3. Dynamic: switches based on context threshold (default 60%)

## Settings Persistence

All changes auto-save to `~/.config/ccstatusline/settings.json`. Supports `CLAUDE_CONFIG_DIR` env var for custom Claude config paths.
