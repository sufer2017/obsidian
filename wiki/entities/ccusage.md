---
type: entity
title: "ccusage"
updated: 2026-04-18
tags:
  - tool
  - claude-code
  - usage-tracking
status: stub
related:
  - "[[ccstatusline]]"
  - "[[Claude Code CLI Ecosystem]]"
---

# ccusage

Usage tracking and reporting tool for Claude Code. Part of the [[Claude Code CLI Ecosystem]].

Integrates with [[ccstatusline]] via Custom Command widget:

```bash
npx -y ccusage@latest statusline
```

Configure with 5000ms timeout and color preservation enabled.
