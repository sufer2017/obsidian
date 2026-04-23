#!/usr/bin/env python3
"""extract-bilibili.py — B站视频提取（字幕/转录）"""
import sys, re, os, json, subprocess
from datetime import datetime

URL = sys.argv[1]
REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

date = datetime.now().strftime("%Y-%m-%d")

# yt-dlp 获取视频信息 + 字幕
info_cmd = ["yt-dlp", "--dump-json", "--no-download", URL]
try:
    info = json.loads(subprocess.check_output(info_cmd, timeout=30).decode())
except Exception as e:
    print("")
    print(f"提取失败: {e}")
    sys.exit(1)

title = info.get("title", "Untitled")[:80]
uploader = info.get("uploader", "未知")
description = info.get("description", "")[:500]
duration = info.get("duration", 0)
view_count = info.get("view_count", 0)
like_count = info.get("like_count", 0)

# 尝试获取字幕
subtitle_text = ""
sub_cmd = ["yt-dlp", "--write-subs", "--write-auto-subs", "--sub-lang", "zh-Hans,zh,en",
           "--skip-download", "--sub-format", "json3",
           "-o", f"/tmp/bili_%(id)s", URL]
try:
    subprocess.run(sub_cmd, timeout=60, capture_output=True)
    # 查找字幕文件
    vid_id = info.get("id", "unknown")
    for ext in [".zh-Hans.json3", ".zh.json3", ".en.json3"]:
        sub_file = f"/tmp/bili_{vid_id}{ext}"
        if os.path.exists(sub_file):
            with open(sub_file, "r", encoding="utf-8") as f:
                sub_data = json.load(f)
            events = sub_data.get("events", [])
            segments = []
            for e in events:
                segs = e.get("segs", [])
                text = "".join(s.get("utf8", "") for s in segs).strip()
                if text and text != "\n":
                    segments.append(text)
            subtitle_text = "\n".join(segments)
            os.remove(sub_file)
            break
except Exception:
    pass

# 如果没有字幕，尝试 whisper 转录
if not subtitle_text:
    try:
        audio_path = f"/tmp/bili_{info.get('id', 'tmp')}.wav"
        dl_cmd = ["yt-dlp", "-x", "--audio-format", "wav",
                  "-o", audio_path.replace(".wav", ".%(ext)s"), URL]
        subprocess.run(dl_cmd, timeout=120, capture_output=True)
        if os.path.exists(audio_path):
            whisper_cmd = ["whisper", audio_path, "--language", "zh", "--model", "base",
                          "--output_format", "txt", "--output_dir", "/tmp"]
            subprocess.run(whisper_cmd, timeout=300, capture_output=True)
            txt_path = audio_path.replace(".wav", ".txt")
            if os.path.exists(txt_path):
                with open(txt_path, "r") as f:
                    subtitle_text = f.read().strip()
                os.remove(txt_path)
            os.remove(audio_path)
    except Exception:
        subtitle_text = "(字幕和转录均不可用)"

# 格式化时长
mins = duration // 60
secs = duration % 60
duration_str = f"{mins}分{secs}秒"

safe_title = re.sub(r'[\\/:*?"<>|]', '', title)[:40]
filename = f"{date} {safe_title}.md"
filepath = os.path.join(REPO, "wiki", "sources", filename)

content = f"""---
type: source
title: "{title}"
updated: {date}
tags:
  - bilibili
  - video
source_url: "{URL}"
status: evergreen
related: []
---

# {title}

**UP主**: {uploader} | **时长**: {duration_str} | **播放**: {view_count} | **点赞**: {like_count}

{description[:300]}

> [!tip]- 字幕/转录全文
> {subtitle_text[:8000] if subtitle_text else "(无字幕)"}

> [!info]- 元数据
> - **来源**: B站 · {uploader}
> - **链接**: {URL}
> - **日期**: {date}
> - **时长**: {duration_str}
> - **互动**: {view_count}播放 / {like_count}赞
"""

os.makedirs(os.path.dirname(filepath), exist_ok=True)
with open(filepath, "w", encoding="utf-8") as f:
    f.write(content)

print(filepath)
print(f"已学习: [{title}] by {uploader}")
print(f"时长{duration_str}, {'有字幕' if subtitle_text and subtitle_text != '(字幕和转录均不可用)' else '无字幕'}")
