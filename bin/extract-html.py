#!/usr/bin/env python3
"""extract-html.py — 本地 HTML 文件提取（会议纪要等）"""
import sys, re, os
from datetime import datetime

FILEPATH = sys.argv[1]
REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

with open(FILEPATH, "r", encoding="utf-8", errors="ignore") as f:
    html = f.read()

title_m = re.search(r"<title[^>]*>(.*?)</title>", html, re.S | re.I)
title = title_m.group(1).strip() if title_m else os.path.splitext(os.path.basename(FILEPATH))[0]
title = re.sub(r"\s+", " ", title)[:80]

for tag in ["script", "style", "nav", "footer", "header"]:
    html = re.sub(rf"<{tag}[^>]*>.*?</{tag}>", "", html, flags=re.S | re.I)

# 保留结构化标签
html = re.sub(r"<br\s*/?>", "\n", html, flags=re.I)
html = re.sub(r"<li[^>]*>", "- ", html, flags=re.I)
html = re.sub(r"<h[1-6][^>]*>(.*?)</h[1-6]>", r"\n## \1\n", html, flags=re.S | re.I)
html = re.sub(r"<p[^>]*>", "\n", html, flags=re.I)
html = re.sub(r"<tr[^>]*>", "\n", html, flags=re.I)
html = re.sub(r"<td[^>]*>(.*?)</td>", r" | \1", html, flags=re.S | re.I)

text = re.sub(r"<[^>]+>", "", html)
text = re.sub(r"\n{3,}", "\n\n", text)
text = re.sub(r"[ \t]+", " ", text).strip()

lines = [l.strip() for l in text.split("\n") if l.strip()]

safe_title = re.sub(r'[\\/:*?"<>|]', '', title)[:40]
date = datetime.now().strftime("%Y-%m-%d")
filename = f"{date} {safe_title}.md"
filepath_out = os.path.join(REPO, "wiki", "sources", filename)

body = "\n".join(lines)

content = f"""---
type: source
title: "{title}"
updated: {date}
tags:
  - document
  - meeting-notes
source_url: "local:{os.path.basename(FILEPATH)}"
status: evergreen
---

# {title}

{body[:5000]}

> [!info]- 元数据
> - **来源**: 本地文件 ({os.path.basename(FILEPATH)})
> - **录入日期**: {date}
"""

os.makedirs(os.path.dirname(filepath_out), exist_ok=True)
with open(filepath_out, "w", encoding="utf-8") as f:
    f.write(content)

# 同时保存原始 HTML 到 .raw/
raw_dir = os.path.join(REPO, ".raw")
os.makedirs(raw_dir, exist_ok=True)
import shutil
shutil.copy2(FILEPATH, os.path.join(raw_dir, os.path.basename(FILEPATH)))

print(filepath_out)
print(f"已学习: {title}")
print(f"内容: {lines[0][:100] if lines else '(空)'}")
