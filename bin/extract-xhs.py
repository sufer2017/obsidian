#!/usr/bin/env python3
"""extract-xhs.py — 小红书帖子提取"""
import sys, re, os, json, ssl
from urllib.request import Request, urlopen
from datetime import datetime

URL = sys.argv[1]
REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
COOKIES_FILE = os.path.expanduser("~/cookies.json")

date = datetime.now().strftime("%Y-%m-%d")

if not os.path.exists(COOKIES_FILE):
    print("")
    print("需要配置 cookies。请在服务器上运行:")
    print("1. 用 Chrome 打开 xiaohongshu.com 并登录")
    print("2. DevTools Console 运行 cookies 导出脚本")
    print("3. 保存到 ~/cookies.json")
    sys.exit(1)

with open(COOKIES_FILE) as f:
    cookies = json.load(f)
cookie_str = "; ".join(f"{c['name']}={c['value']}" for c in cookies)

ctx = ssl.create_default_context()
ctx.check_hostname = False
ctx.verify_mode = ssl.CERT_NONE

req = Request(URL)
req.add_header("Cookie", cookie_str)
req.add_header("User-Agent", "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36")

try:
    resp = urlopen(req, timeout=15, context=ctx)
    html = resp.read().decode("utf-8", errors="ignore")
except Exception as e:
    print("")
    print(f"请求失败: {e}")
    sys.exit(1)

m = re.search(r"window\.__INITIAL_STATE__\s*=\s*(\{.+?\})\s*</script>", html, re.DOTALL)
if not m:
    print("")
    print("解析失败，cookies 可能已过期，请重新导出")
    sys.exit(1)

raw = m.group(1).replace("undefined", "null")
data = json.loads(raw)

note_map = data.get("note", {}).get("noteDetailMap", {})
if not note_map:
    print("")
    print("帖子数据为空")
    sys.exit(1)

note_key = list(note_map.keys())[0]
note = note_map[note_key].get("note", {})

title = note.get("title", "")[:80] or "小红书笔记"
desc = note.get("desc", "")
note_type = note.get("type", "normal")
user = note.get("user", {}).get("nickname", "未知")
interact = note.get("interactInfo", {})
likes = interact.get("likedCount", 0)
collects = interact.get("collectedCount", 0)
comments = interact.get("commentCount", 0)

# 图片
images = note.get("imageList", [])
img_md = "\n".join([f"![图{i+1}]({img.get('urlDefault', '')})" for i, img in enumerate(images[:5])])

# 清理标签
desc_clean = re.sub(r"#\w+\[话题\]#", "", desc).strip()
tags_m = re.findall(r"#(\w+)\[话题\]#", desc)

safe_title = re.sub(r'[\\/:*?"<>|]', '', title)[:40]
filename = f"{date} {safe_title}.md"
filepath = os.path.join(REPO, "wiki", "sources", filename)

tag_yaml = "\n".join([f"  - {t}" for t in tags_m[:5]]) if tags_m else "  - xiaohongshu"

content = f"""---
type: source
title: "{title}"
updated: {date}
tags:
  - xhs
{tag_yaml}
source_url: "{URL}"
status: evergreen
---

# {title}

{desc_clean[:300]}

> [!tip]- 详情
> {desc_clean}
>
> {img_md}

> [!info]- 元数据
> - **来源**: 小红书 · {user}
> - **链接**: {URL}
> - **日期**: {date}
> - **类型**: {note_type}
> - **互动**: {likes}赞 / {collects}收藏 / {comments}评论
> - **标签**: {', '.join(tags_m) if tags_m else '无'}
"""

os.makedirs(os.path.dirname(filepath), exist_ok=True)
with open(filepath, "w", encoding="utf-8") as f:
    f.write(content)

print(filepath)
print(f"已学习: [{title}] by {user}")
print(f"{likes}赞 {collects}收藏")
