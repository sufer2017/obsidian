---
type: meta
title: "Hot Cache"
updated: 2026-04-08T19:00:00
tags:
  - meta
  - hot-cache
status: evergreen
related:
  - "[[index]]"
  - "[[log]]"
  - "[[Wiki Map]]"
  - "[[getting-started]]"
  - "[[claude-obsidian-v1.4-release-session]]"
---

# Recent Context

Navigation: [[index]] | [[log]] | [[overview]]

## Last Updated
2026-04-23: Ingested 企业级AI活动分享纪要.html (enterprise AI event meeting notes). 1 wiki source page created.

## Latest Ingest: 企业级AI活动分享纪要 (2026-04-23)
- 2026-04-22 活动，ThinkingAI主办，5家分享：ThinkingAI、MiniMax、飞书、网易机会、AWS
- 核心主题：企业级Agent落地
- 关键趋势：数据资产>模型能力、多Agent协作>单Agent能力、知识库是基础设施
- Agent三分类：提问型/干活型/验证型
- MCP vs A2A：互补关系，短期MCP为主
- 飞书需求洞察："不要问想怎么用AI，要问最耗时最重复的工作是什么"
- 网易TASTED人才模型：审美/洞察/标准/结构/判断/自驱
- MiniMax模型矩阵：M2.7(LLM)、Hailuo 2.3(视频)、Speech 2.8(语音)

## Plugin State
- **Version**: 1.4.1 (installed, enabled, user scope)
- **Install ID**: `claude-obsidian@claude-obsidian-marketplace`
- **Releases**: v1.1, v1.4.0, v1.4.1 on GitHub
- **Skills**: 10 (wiki, wiki-ingest, wiki-query, wiki-lint, save, autoresearch, canvas, defuddle, obsidian-bases, obsidian-markdown)
- **Hooks**: 4 (SessionStart, PostCompact, PostToolUse, Stop)
- **Multi-agent**: bootstrap files for Codex, OpenCode, Gemini, Cursor, Windsurf, GitHub Copilot

## Install Command (Correct Two-Step Flow)
```bash
claude plugin marketplace add AgriciDaniel/claude-obsidian
claude plugin install claude-obsidian@claude-obsidian-marketplace
```

There is no `claude plugin install github:owner/repo` shortcut. Both steps are required. Full session note: [[claude-obsidian-v1.4-release-session]].

## Recent Release Cycle (v1.1 → v1.4.1)
- **v1.1**: URL ingestion, vision ingestion, delta tracking manifest, 3 new skills (defuddle, obsidian-bases, obsidian-markdown), multi-depth query modes, PostToolUse auto-commit, removed invalid `allowed-tools` frontmatter field
- **v1.4.0**: Dataview to Bases migration (new `wiki/meta/dashboard.base`), Canvas JSON 1.0 spec completeness, PostCompact hook, Obsidian CLI MCP option, 6 multi-agent bootstrap files, 249 em dashes scrubbed, security git history rewrite to remove placeholder email
- **v1.4.1**: hotfix for wrong plugin install command syntax in README and install-guide.md

## Key Lessons (Recent)
1. Plugin install is always two-step: `marketplace add` then `install plugin@marketplace`
2. `allowed-tools` is NOT valid in skill frontmatter. Use only `name` and `description` (kepano convention).
3. Obsidian Bases uses `filters/views/formulas`, not Dataview `from/where`
4. Canvas edges have asymmetric defaults: `fromEnd="none"`, `toEnd="arrow"`
5. Hook-injected context does not survive compaction. PostCompact hook is required to restore hot cache.
6. `git filter-repo` needs two passes: `--replace-text` for blobs, `--replace-message` for commit messages

## Style Preferences (Saved to Memory)
- **No em dashes** (U+2014) or `--` as punctuation anywhere. Use periods, commas, colons, or parentheses. Hyphens in compound words are fine (auto-commit, multi-agent).
- Keep responses short and direct. No trailing "here's what I did" summaries.
- Parallel tool calls when independent.

## Ecosystem Research (Done 2026-04-08)
16+ Claude + Obsidian projects mapped. Full feature matrix at [[claude-obsidian-ecosystem]]. Prioritized backlog at [[cherry-picks]]. Top competitors: [[Ar9av-obsidian-wiki]] (multi-agent + delta tracking), [[rvk7895-llm-knowledge-bases]] (multi-depth query), [[ballred-obsidian-claude-pkm]] (goal cascade + auto-commit), [[kepano-obsidian-skills]] (authoritative Obsidian skills from Obsidian's own creator).

## Latest Ingest: xhs-claude-skills (2026-04-18)
- Claude Code plugin: XHS posts → structured Obsidian notes
- Creator: [[chenxiachan]]
- 4 skills: /xhs (single), /xhs-batch (bulk), /xhs-analyze (AI analysis), /xhs-cover (cover images)
- [[Xiaohongshu Content Extraction]]: cookie-based, single HTTP request, parses __INITIAL_STATE__
- [[Local Whisper Transcription]]: ffmpeg + mlx-whisper on Apple Silicon, fully local
- [[Peter Thiel Note Style]]: contrarian insight → core argument → relevance → dig-or-skip (max 6 visible lines)
- [[XHS Cover Generation]]: 6 styles (morandi/academic/dark/mint/sunset/bw), 1080x1440, Playwright

## Previous Ingest: ccstatusline (2026-04-18)
- 7.8k-star TypeScript CLI tool for customizing Claude Code's terminal status line
- Creator: [[Matthew Breedlove]] (@sirmalloc)
- Modular [[Status Line Widgets]]: model, git, tokens, environment, custom commands
- Interactive [[Terminal UI Configuration]] built with React + Ink
- [[Powerline Rendering]] with arrow separators and multi-line support
- Part of [[Claude Code CLI Ecosystem]] alongside ccusage, tweakcc, codachi
- Zero-config: `npx -y ccstatusline@latest`

## Active Threads
- v1.5.0 backlog: `/adopt` command, vault graph analysis in wiki-lint, semantic search via qmd, Marp output
- `community` remote (`avalonreset-pro/claude-obsidian`) still has pre-rewrite history. Force-push needed next time that remote is configured.

## Repo Locations
- Working: `~/Desktop/claude-obsidian/`
- Public: https://github.com/AgriciDaniel/claude-obsidian
- Community (private): https://github.com/avalonreset-pro/claude-obsidian
