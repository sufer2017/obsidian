---
type: concept
title: "Local Whisper Transcription"
updated: 2026-04-18
tags:
  - whisper
  - transcription
  - audio
  - apple-silicon
status: evergreen
related:
  - "[[xhs-claude-skills]]"
  - "[[Xiaohongshu Content Extraction]]"
---

# Local Whisper Transcription

The video-to-text pipeline used by [[xhs-claude-skills]] for 小红书 video posts. Runs entirely locally on Apple Silicon.

## Pipeline

```
Video URL → curl download (.mp4)
         → ffmpeg: extract audio (PCM 16-bit, 16kHz, mono, .wav)
         → mlx-whisper: transcribe (zh language)
         → clean text: remove trailing repeats, add punctuation, structure
         → delete temp files
```

## Key Components

| Tool | Role |
|------|------|
| curl | Download video with Referer header |
| ffmpeg | Extract audio: `-vn -acodec pcm_s16le -ar 16000 -ac 1` |
| mlx-whisper | Local transcription (Apple Silicon MLX framework) |

## Model

`mlx-community/whisper-large-v3-turbo` (optimized for MLX on Apple Silicon).

## Post-Processing

- Remove trailing repeated characters (background music artifacts)
- Semantic sentence breaking with punctuation
- Structure with Markdown formatting if steps/key points detected
- Clean `#tag[topic]#` markers from text

## Why Local

No external API calls. Privacy-preserving: video content never leaves the machine. Zero per-request cost.
