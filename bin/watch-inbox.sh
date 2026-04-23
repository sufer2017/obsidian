#!/usr/bin/env bash
# watch-inbox.sh — 监听坚果云 inbox，自动搬运到 .raw/ 并记录待 ingest 队列
# 用法: bash bin/watch-inbox.sh
# 停止: Ctrl+C 或 kill

set -euo pipefail

INBOX="$HOME/Nutstore Files/inbox"
RAW_DIR="$HOME/Desktop/claude-obsidian/.raw"
QUEUE="$HOME/Desktop/claude-obsidian/.raw/.ingest-queue"
LOG="$HOME/Desktop/claude-obsidian/.raw/.ingest-log"

mkdir -p "$INBOX" "$RAW_DIR"
touch "$QUEUE" "$LOG"

echo "[$(date '+%Y-%m-%d %H:%M:%S')] inbox watcher started"
echo "[$(date '+%Y-%m-%d %H:%M:%S')] watching: $INBOX"
echo "[$(date '+%Y-%m-%d %H:%M:%S')] target:   $RAW_DIR"
echo ""

fswatch -0 --event Created --event MovedTo --event Renamed "$INBOX" | while IFS= read -r -d '' file; do
    # skip hidden files, .DS_Store, temp files
    basename=$(basename "$file")
    if [[ "$basename" == .* ]] || [[ "$basename" == *.tmp ]] || [[ "$basename" == *~* ]]; then
        continue
    fi

    # skip directories
    if [[ -d "$file" ]]; then
        continue
    fi

    # wait for file write to finish (坚果云 sync may take a moment)
    sleep 2

    # skip if file disappeared (坚果云 temp file)
    if [[ ! -f "$file" ]]; then
        continue
    fi

    # copy to .raw/ (preserve original in inbox)
    dest="$RAW_DIR/$basename"
    if [[ -f "$dest" ]]; then
        # avoid overwrite: add timestamp
        name="${basename%.*}"
        ext="${basename##*.}"
        if [[ "$name" == "$ext" ]]; then
            dest="$RAW_DIR/${name}-$(date '+%Y%m%d%H%M%S')"
        else
            dest="$RAW_DIR/${name}-$(date '+%Y%m%d%H%M%S').${ext}"
        fi
    fi

    cp "$file" "$dest"
    echo "$dest" >> "$QUEUE"

    ts=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$ts] NEW: $basename → $(basename "$dest")"
    echo "[$ts] $basename → $(basename "$dest")" >> "$LOG"

    # desktop notification
    osascript -e "display notification \"$basename 已入库 .raw/\" with title \"知识库\" subtitle \"等待 ingest\"" 2>/dev/null || true
done
