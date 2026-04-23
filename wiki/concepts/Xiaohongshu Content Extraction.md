---
type: concept
title: "Xiaohongshu Content Extraction"
updated: 2026-04-18
tags:
  - web-scraping
  - xiaohongshu
  - content-extraction
status: evergreen
related:
  - "[[xhs-claude-skills]]"
  - "[[Local Whisper Transcription]]"
  - "[[Peter Thiel Note Style]]"
---

# Xiaohongshu Content Extraction

The technique used by [[xhs-claude-skills]] to pull posts from 小红书 without headless browsers or external APIs.

## Architecture

Single HTTP request → parse `window.__INITIAL_STATE__` from HTML. No MCP server, no backend, no browser automation.

## Authentication: Cookie-Based

30-second setup:
1. Login to xiaohongshu.com in Chrome
2. Open DevTools Console, run a JS snippet to copy cookies as JSON
3. Save to `~/cookies.json`

The plugin auto-detects cookie expiration and re-prompts.

## Data Flow

```
URL → extract post ID (24-hex) + xsec_token
    → HTTP GET with cookies + UA header
    → parse __INITIAL_STATE__ JSON from <script> tag
    → extract: title, desc, type, time, user, imageList, video, interactInfo, ipLocation
```

## Extracted Fields

| Field | Source |
|-------|--------|
| Title + description | `note.title`, `note.desc` |
| Images | `note.imageList[].urlDefault` |
| Video stream | `note.video.media.stream` (h264 > h265 > av1 priority) |
| Author | `note.user` |
| Engagement | `note.interactInfo` (likes, saves, comments) |
| Location | `note.ipLocation` |
| Tags | Parsed from `#tag[topic]#` markers in desc |

## Anti-Detection

- Batch mode uses 3-second intervals between requests
- Standard Chrome User-Agent header
- SSL verification disabled for compatibility
