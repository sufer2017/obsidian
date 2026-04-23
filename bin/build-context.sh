#!/bin/bash
# build-context.sh — 构建知识库上下文缓存
# 每小时由 cron 自动运行，ask.sh 直接读缓存，秒回
# 用法: bash bin/build-context.sh

set -euo pipefail
REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO_DIR"

git pull --rebase --quiet 2>/dev/null || true

CACHE="$REPO_DIR/.cache/wiki-context.txt"
mkdir -p "$REPO_DIR/.cache"

{
    echo "=== 知识库上下文 ($(date '+%Y-%m-%d %H:%M')) ==="
    echo ""

    # hot cache
    echo "--- 最近动态 ---"
    if [[ -f wiki/hot.md ]]; then
        sed '/^---$/,/^---$/d' wiki/hot.md | head -40
    fi
    echo ""

    # index (all pages summary)
    echo "--- 知识索引 ---"
    if [[ -f wiki/index.md ]]; then
        sed '/^---$/,/^---$/d' wiki/index.md
    fi
    echo ""

    # all wiki pages - title + first 3 lines of content
    echo "--- 页面摘要 ---"
    find wiki -name "*.md" -not -name "index.md" -not -name "hot.md" -not -name "log.md" | sort | while read -r page; do
        name=$(basename "$page" .md)
        # skip frontmatter, get first meaningful lines
        content=$(sed '/^---$/,/^---$/d' "$page" | grep -v '^$' | head -3)
        echo "[$name]: $content"
        echo ""
    done

} > "$CACHE"

# 统计
pages=$(find wiki -name "*.md" | wc -l | tr -d ' ')
size=$(wc -c < "$CACHE" | tr -d ' ')
echo "缓存已更新: $pages 页, ${size} 字节"
