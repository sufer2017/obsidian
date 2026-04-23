---
type: concept
title: "Cookie-Based Web Authentication"
updated: 2026-04-18
tags:
  - authentication
  - web-scraping
  - cookies
status: evergreen
related:
  - "[[Xiaohongshu Content Extraction]]"
  - "[[xhs-claude-skills]]"
---

# Cookie-Based Web Authentication

The authentication pattern used by [[xhs-claude-skills]] to access 小红书 content. Reuses an existing browser session instead of handling login flows.

## How It Works

1. User logs into target site in Chrome (already authenticated)
2. DevTools Console exports cookies as JSON array
3. Saved to `~/cookies.json`
4. Plugin injects cookies into HTTP requests via `Cookie` header

## Advantages Over Alternatives

| Approach | Drawback |
|----------|----------|
| Headless browser | Heavy, slow, detection-prone |
| API keys | Platform doesn't offer public API |
| OAuth | Not available for scraping use cases |
| **Cookies** | Lightweight, single HTTP request, reuses existing auth |

## Limitations

- Cookies expire (typically 30 days for XHS)
- Plugin auto-detects expiration (redirect to error page) and re-prompts
- Requires manual re-export when expired
- Tied to one account's session
