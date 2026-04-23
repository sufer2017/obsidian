#!/bin/bash
# ask.sh — 基于知识库回答问题
# 输出知识库上下文 + 问题，供 Hermes/GPT 处理
# Hermes 触发词: 问/ask <问题>

set -euo pipefail
REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO_DIR"

QUESTION="${1:?用法: bash bin/ask.sh \"你的问题\"}"
CACHE="$REPO_DIR/.cache/wiki-context.txt"

# 如果缓存不存在或超过2小时，重建
if [[ ! -f "$CACHE" ]] || [[ $(find "$CACHE" -mmin +120 2>/dev/null) ]]; then
    bash "$REPO_DIR/bin/build-context.sh" >/dev/null 2>&1
fi

# 关键词搜索：找到最相关的页面，补充详细内容
KEYWORDS=$(echo "$QUESTION" | tr ' ' '\n' | grep -v '^[的了是在]$' | head -5)
EXTRA=""
for kw in $KEYWORDS; do
    matches=$(grep -ril "$kw" wiki/ 2>/dev/null | head -3)
    for match in $matches; do
        if [[ -f "$match" ]]; then
            content=$(sed '/^---$/,/^---$/d' "$match" | head -30)
            EXTRA="$EXTRA
--- $(basename "$match" .md) ---
$content
"
        fi
    done
done

# 输出给 Hermes/GPT
echo "=== 以下是我的个人知识库内容，请基于这些内容回答问题 ==="
echo ""
cat "$CACHE"
if [[ -n "$EXTRA" ]]; then
    echo ""
    echo "=== 与问题相关的详细页面 ==="
    echo "$EXTRA" | head -200
fi
echo ""
echo "=== 问题 ==="
echo "$QUESTION"
