#!/usr/bin/env python3
"""extract-web.py — 通用网页提取"""
import sys, re, json, os
from urllib.request import Request, urlopen
from datetime import datetime

URL = sys.argv[1]
REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

req = Request(URL, headers={"User-Agent": "Mozilla/5.0 (compatible; KBBot/1.0)"})
html = urlopen(req, timeout=15).read().decode("utf-8", errors="ignore")

title_m = re.search(r"<title[^>]*>(.*?)</title>", html, re.S | re.I)
title = title_m.group(1).strip() if title_m else "Untitled"
title = re.sub(r"\s+", " ", title)[:80]

for tag in ["script", "style", "nav", "footer", "header"]:
    html = re.sub(rf"<{tag}[^>]*>.*?</{tag}>", "", html, flags=re.S | re.I)

text = re.sub(r"<[^>]+>", "\n", html)
text = re.sub(r"\n{3,}", "\n\n", text)
text = re.sub(r"[ \t]+", " ", text).strip()

paragraphs = [p.strip() for p in text.split("\n") if len(p.strip()) > 20]
body = "\n\n".join(paragraphs[:50])

safe_title = re.sub(r'[\\/:*?"<>|]', '', title)[:40]
date = datetime.now().strftime("%Y-%m-%d")
filename = f"{date} {safe_title}.md"
filepath = os.path.join(REPO, "wiki", "sources", filename)

content = f"""---
type: source
title: "{title}"
updated: {date}
tags:
  - web
source_url: "{URL}"
status: evergreen
---

# {title}

> [!tip]- 全文
> {body[:3000]}

> [!info]- 元数据
> - **来源**: {URL}
> - **抓取日期**: {date}
"""

os.makedirs(os.path.dirname(filepath), exist_ok=True)
with open(filepath, "w", encoding="utf-8") as f:
    f.write(content)

summary = f"已学习: {title}"
if paragraphs:
    summary += f"\n摘要: {paragraphs[0][:100]}"

print(filepath)
print(summary)
