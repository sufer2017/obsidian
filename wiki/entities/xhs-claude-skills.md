---
type: entity
title: "xhs-claude-skills"
updated: 2026-04-18
tags:
  - tool
  - claude-code
  - plugin
  - xiaohongshu
  - obsidian
status: evergreen
related:
  - "[[chenxiachan]]"
  - "[[Xiaohongshu Content Extraction]]"
  - "[[Local Whisper Transcription]]"
  - "[[Peter Thiel Note Style]]"
  - "[[XHS Cover Generation]]"
  - "[[Claude Code CLI Ecosystem]]"
---

# xhs-claude-skills

Claude Code plugin that converts 小红书 (Xiaohongshu / RedNote) posts into structured Obsidian notes. Supports image/text and video posts with automatic local Whisper transcription.

- **Repository:** [github.com/chenxiachan/xhs-claude-skills](https://github.com/chenxiachan/xhs-claude-skills)
- **Stars:** 118 | **Forks:** 11
- **Plugin name:** rednote-to-obsidian v1.0.0
- **License:** MIT
- **Author:** [[chenxiachan]]

## Four Skills

| Skill | Trigger | Function |
|-------|---------|----------|
| `/xhs` | `/xhs <link>` | Extract single post (text + images + video transcription) |
| `/xhs-batch` | `/xhs-batch <links>` | Bulk extraction with 3s interval |
| `/xhs-analyze` | `/xhs-analyze [keyword]` | AI analysis of saved posts |
| `/xhs-cover` | `/xhs-cover <title>` | Generate cover image (HTML → Playwright screenshot) |

## How It Works

1. **[[Xiaohongshu Content Extraction]]** via cookie-based HTTP request, parsing `__INITIAL_STATE__`
2. **[[Local Whisper Transcription]]** for video posts (ffmpeg + mlx-whisper)
3. **[[Peter Thiel Note Style]]** output: contrarian insight, core argument, relevance, dig-or-skip verdict
4. **[[XHS Cover Generation]]** with 6 preset styles via Playwright

## Installation

```bash
claude plugin marketplace add chenxiachan/xhs-claude-skills
claude plugin install rednote-to-obsidian@...
```

## Dependencies

- Required: Claude Code, Obsidian
- Video: ffmpeg, mlx-whisper (Apple Silicon optimized)
- Covers: Playwright + Chromium

## Output

Notes save to `~/Documents/Obsidian Vault/xhs/{YYYY-MM-DD} {short-title}.md`. Media in `xhs/img/` and `xhs/video/`.
