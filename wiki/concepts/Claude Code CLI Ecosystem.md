---
type: concept
title: "Claude Code CLI Ecosystem"
updated: 2026-04-18
tags:
  - claude-code
  - cli
  - ecosystem
status: evergreen
related:
  - "[[ccstatusline]]"
  - "[[ccusage]]"
  - "[[Matthew Breedlove]]"
---

# Claude Code CLI Ecosystem

The growing set of community tools built around Claude Code's CLI interface.

## Known Tools

| Tool | Purpose | Author |
|------|---------|--------|
| [[ccstatusline]] | Customizable status line | [[Matthew Breedlove]] |
| [[ccusage]] | Usage tracking & reporting | community |
| tweakcc | Claude Code configuration tweaking | community |
| codachi | Companion tool | community |

## Integration Pattern

Tools typically integrate with Claude Code via:
- Parsing Claude Code's status JSON from stdin (piped mode)
- Reading/writing `~/.claude/settings.json`
- Custom Command widgets in [[ccstatusline]]

## ccusage Integration Example

```bash
npx -y ccusage@latest statusline
```

Used as a Custom Command widget in ccstatusline with 5000ms timeout and ANSI color preservation.
