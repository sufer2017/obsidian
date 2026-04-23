#!/usr/bin/env bash
# sync-inbox.sh — 检查 iCloud inbox 中的新文件，搬运到 .raw/
# 由 launchd 每 30 秒调用一次
# 手动运行: bash bin/sync-inbox.sh

INBOX="$HOME/Library/Mobile Documents/com~apple~CloudDocs/inbox"
RAW_DIR="$HOME/Desktop/claude-obsidian/.raw"
PROCESSED="$RAW_DIR/.processed"
QUEUE="$RAW_DIR/.ingest-queue"
LOG="$RAW_DIR/.ingest-log"

mkdir -p "$INBOX" "$RAW_DIR"
touch "$PROCESSED" "$QUEUE" "$LOG"

found=0

for file in "$INBOX"/*; do
    [ -f "$file" ] || continue

    basename=$(basename "$file")

    # skip hidden, temp, DS_Store
    case "$basename" in
        .*|*.tmp|*~*) continue ;;
    esac

    # skip already processed
    grep -qxF "$basename" "$PROCESSED" 2>/dev/null && continue

    # copy to .raw/
    dest="$RAW_DIR/$basename"
    if [ -f "$dest" ]; then
        name="${basename%.*}"
        ext="${basename##*.}"
        if [ "$name" = "$ext" ]; then
            dest="$RAW_DIR/${name}-$(date '+%Y%m%d%H%M%S')"
        else
            dest="$RAW_DIR/${name}-$(date '+%Y%m%d%H%M%S').${ext}"
        fi
    fi

    cp "$file" "$dest"
    echo "$basename" >> "$PROCESSED"
    echo "$dest" >> "$QUEUE"

    ts=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$ts] $basename -> $(basename "$dest")" >> "$LOG"

    /usr/bin/osascript -e "display notification \"$basename 已入库 .raw/\" with title \"知识库\" subtitle \"等待 ingest\"" 2>/dev/null || true

    found=$((found + 1))
done

if [ "$found" -gt 0 ]; then
    echo "[$( date '+%Y-%m-%d %H:%M:%S')] synced $found file(s)"
fi
