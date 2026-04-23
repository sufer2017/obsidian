#!/bin/bash
# recent.sh — 显示最近学习记录
# Hermes 触发词: recent / 最近

set -euo pipefail
REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO_DIR"

git pull --rebase --quiet 2>/dev/null || true

echo "=== 最近学习记录 ==="
echo ""

# 按修改时间列出最近 10 个 wiki 页面
find wiki/sources wiki/concepts wiki/entities -name "*.md" -type f 2>/dev/null | \
    xargs ls -t 2>/dev/null | head -10 | while read -r file; do
    name=$(basename "$file" .md)
    # 提取 title 和 date from frontmatter
    title=$(grep "^title:" "$file" 2>/dev/null | head -1 | sed 's/title: *"*//;s/"$//')
    updated=$(grep "^updated:" "$file" 2>/dev/null | head -1 | sed 's/updated: *//')
    echo "- [$updated] $title"
done

echo ""
pages=$(find wiki -name "*.md" | wc -l | tr -d ' ')
echo "知识库共 $pages 个页面"
