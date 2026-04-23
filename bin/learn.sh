#!/bin/bash
# learn.sh — 提取 URL 内容，写入 wiki，push 到 GitHub
# 用法: bash bin/learn.sh <URL>
# Hermes 触发词: 学习/learn <URL>

set -euo pipefail
REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO_DIR"

URL="${1:?用法: bash bin/learn.sh <URL>}"

git pull --rebase --quiet 2>/dev/null || true

# 检测 URL 类型
detect_type() {
    case "$1" in
        *xiaohongshu.com*|*xhslink.com*) echo "xhs" ;;
        *bilibili.com*|*b23.tv*) echo "bilibili" ;;
        *.html|*.htm) echo "html" ;;
        *) echo "web" ;;
    esac
}

TYPE=$(detect_type "$URL")
echo "检测到类型: $TYPE"

# 如果是本地 HTML 文件路径（Hermes 传来的文件）
if [[ "$URL" == *.html ]] && [[ -f "$URL" ]]; then
    RESULT=$(python3 "$REPO_DIR/bin/extract-html.py" "$URL")
elif [[ "$TYPE" == "xhs" ]]; then
    RESULT=$(python3 "$REPO_DIR/bin/extract-xhs.py" "$URL")
elif [[ "$TYPE" == "bilibili" ]]; then
    RESULT=$(python3 "$REPO_DIR/bin/extract-bilibili.py" "$URL")
else
    RESULT=$(python3 "$REPO_DIR/bin/extract-web.py" "$URL")
fi

# RESULT 格式: 第一行是文件路径，后面是摘要
FILEPATH=$(echo "$RESULT" | head -1)
SUMMARY=$(echo "$RESULT" | tail -n +2)

if [[ -z "$FILEPATH" ]] || [[ ! -f "$FILEPATH" ]]; then
    echo "提取失败"
    exit 1
fi

# 更新 log
DATE=$(date '+%Y-%m-%d %H:%M:%S')
BASENAME=$(basename "$FILEPATH")
sed -i "1,/^---$/!{/^---$/a\\
## [$DATE] learn | $BASENAME\\
- Source: $URL\\
- Type: $TYPE
}" "$REPO_DIR/wiki/log.md" 2>/dev/null || \
echo -e "\n## [$DATE] learn | $BASENAME\n- Source: $URL\n- Type: $TYPE" >> "$REPO_DIR/wiki/log.md"

# commit + push
git add -A
git commit -m "learn: $BASENAME" --quiet 2>/dev/null || true
git push --quiet 2>/dev/null || true

# 重建上下文缓存
bash "$REPO_DIR/bin/build-context.sh" 2>/dev/null || true

echo "$SUMMARY"
