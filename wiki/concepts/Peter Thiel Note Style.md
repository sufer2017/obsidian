---
type: concept
title: "Peter Thiel Note Style"
updated: 2026-04-18
tags:
  - writing-style
  - note-taking
  - decision-making
status: evergreen
related:
  - "[[xhs-claude-skills]]"
  - "[[Compounding Knowledge]]"
---

# Peter Thiel Note Style

The opinionated note format used by [[xhs-claude-skills]]. Core principle: "笔记是决策工具，不是知识库。用户扫一眼就能决定：深挖还是跳过。"

## Structure

```markdown
# 一句话核心洞察（反直觉的判断，不是描述性标题）

核心论点，2-3句话。"大多数人觉得X，但其实Y"。
像 Thiel 在董事会上说话。

**与我的关联：** 一句话（reads user memory for personalization）

**值得深挖吗：** 是/否。一句话理由。

> [!tip]- 详情
> （折叠：结构化内容、图片、转录）

> [!info]- 笔记属性
> （折叠：来源、ID、链接、日期、类型、互动、标签）
```

## Design Rules

1. **Visible content outside collapsibles: max 6 lines**
2. Title must be an insight/judgment, never "Summary of XX post"
3. Contrarian framing: what most people think vs. reality
4. Relevance section reads `~/.claude/projects/*/memory/` for personalization
5. Binary decision: dig deeper or skip

## Why This Works

Optimized for scanning, not reading. Every note is a decision gate. The detailed content exists but is hidden until deliberately opened. Reduces cognitive load from content hoarding.
