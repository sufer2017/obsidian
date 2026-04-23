# xhs-claude-skills — GitHub Repository Dump

> Source: https://github.com/chenxiachan/xhs-claude-skills
> Fetched: 2026-04-18
> Type: GitHub repository (README + all SKILL.md files)

## Overview

Claude Code plugin that converts Xiaohongshu (RedNote / 小红书) posts into structured Obsidian notes. Supports image/text and video posts with automatic video transcription using local Whisper models.

- **Stars:** 118
- **Forks:** 11
- **License:** MIT
- **Author:** chenxiachan
- **Plugin name:** rednote-to-obsidian v1.0.0

## Four Skills

### /xhs <link>
Single post extraction. Flow:
1. Check ~/cookies.json (Chrome DevTools export)
2. Parse post ID (24-hex) and xsec_token from URL
3. HTTP request → parse window.__INITIAL_STATE__ from HTML
4. For video posts: download video → ffmpeg extract audio → mlx-whisper transcribe → clean text
5. Format as Peter Thiel-style Markdown and save to Obsidian vault

### /xhs-batch <links>
Bulk extraction. Same as /xhs but loops with 3-second interval between posts. Outputs summary report.

### /xhs-analyze [keyword]
AI analysis of saved posts. Reads all .md in xhs/ folder. Modes:
- Tutorial content: extract steps, cross-compare
- Knowledge content: extract key points, structure
- Overview (no keyword): topic distribution, frequent tags, recommended deep-dives

### /xhs-cover <title> [--style name]
Generate XHS cover images via HTML+CSS → Playwright screenshot. 1080x1440px (3:4).
6 styles: morandi, academic, dark, mint, sunset, bw.
Auto-selects style based on content type.

## Authentication

Cookie-based. 30-second setup:
1. Login to xiaohongshu.com in Chrome
2. DevTools Console → copy cookies as JSON
3. Save to ~/cookies.json
Auto-detects expiration and re-prompts.

## Technical Architecture

- Single HTTP request parsing __INITIAL_STATE__ (no headless browser, no MCP, no backend)
- Video pipeline: curl download → ffmpeg audio extraction → mlx-whisper local transcription
- Whisper model: mlx-community/whisper-large-v3-turbo
- Output: ~/Documents/Obsidian Vault/xhs/{YYYY-MM-DD} {short-title}.md
- Media: xhs/img/ and xhs/video/

## Note Format (Peter Thiel Style)

"笔记是决策工具，不是知识库。用户扫一眼就能决定：深挖还是跳过。"

Structure:
- H1: One-sentence contrarian insight (not descriptive title)
- Core argument: 2-3 sentences, "most people think X, but actually Y"
- 与我的关联: reads user memory for personalization
- 值得深挖吗: yes/no with one-line reason
- Collapsible: detailed content, structured from desc + transcription
- Collapsible: metadata (source, post ID, link, date, type, engagement, tags)
- Visible content outside collapsibles: max 6 lines

## Cover Generation Styles

| Style | Vibe | Use case |
|-------|------|----------|
| morandi | Warm, muted | Knowledge sharing, methodology |
| academic | Cool, professional | Paper analysis, research |
| dark | Tech, hardcore | AI/coding/open-source |
| mint | Fresh, clean | Tool reviews, productivity |
| sunset | Warm, energetic | Personal reflections, launches |
| bw | Minimal B&W | Opinions, controversy, deep thinking |

## Dependencies

- Required: Claude Code, Obsidian
- Optional (video): ffmpeg, mlx-whisper (Apple Silicon optimized)
- Optional (covers): Playwright with Chromium
