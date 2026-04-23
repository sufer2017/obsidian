#!/bin/bash
# server-setup.sh — 腾讯云服务器一键初始化
# 在服务器上运行: bash server-setup.sh
# 前提: git + SSH key 已配好，能 push 到 GitHub

set -euo pipefail

echo "=== 知识库服务器初始化 ==="

# 1. 安装依赖
echo "[1/5] 安装依赖..."
apt-get update -qq
apt-get install -y -qq python3 python3-pip ffmpeg curl > /dev/null 2>&1
pip3 install -q yt-dlp readability-lxml requests 2>/dev/null || \
    pip3 install -q --break-system-packages yt-dlp readability-lxml requests

# whisper (可选，用于无字幕视频转录)
pip3 install -q openai-whisper 2>/dev/null || \
    pip3 install -q --break-system-packages openai-whisper 2>/dev/null || \
    echo "whisper 安装失败（可选，跳过）"

# 2. 克隆知识库
echo "[2/5] 克隆知识库..."
REPO_DIR="$HOME/obsidian"
if [[ -d "$REPO_DIR/.git" ]]; then
    echo "知识库已存在，拉取最新..."
    cd "$REPO_DIR" && git pull
else
    git clone git@github.com:sufer2017/obsidian.git "$REPO_DIR"
fi
cd "$REPO_DIR"

# 3. Git 配置
echo "[3/5] 配置 Git..."
git config user.name "hermes-bot"
git config user.email "hermes@bot"

# 4. 设置脚本权限
echo "[4/5] 设置权限..."
chmod +x bin/*.sh

# 5. 构建初始缓存
echo "[5/5] 构建知识库缓存..."
bash bin/build-context.sh

# 6. 设置 cron: 每小时自动更新缓存
echo "[bonus] 设置定时任务..."
CRON_CMD="cd $REPO_DIR && git pull --quiet && bash bin/build-context.sh > /dev/null 2>&1"
(crontab -l 2>/dev/null | grep -v "build-context"; echo "0 * * * * $CRON_CMD") | crontab -

echo ""
echo "=== 初始化完成 ==="
echo ""
echo "Hermes 命令配置："
echo "  学习: cd ~/obsidian && bash bin/learn.sh <URL>"
echo "  问答: cd ~/obsidian && bash bin/ask.sh \"<问题>\""
echo "  最近: cd ~/obsidian && bash bin/recent.sh"
echo ""
echo "缓存每小时自动更新，问答秒回。"
