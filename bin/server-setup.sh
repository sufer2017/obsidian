#!/bin/bash
# server-setup.sh — 腾讯云服务器一键初始化
# 在服务器上运行: bash bin/server-setup.sh
# 前提: 仓库已克隆到 ~/obsidian

set -euo pipefail

echo "=== 知识库服务器初始化 ==="

# 1. 安装依赖
echo "[1/6] 安装依赖..."
sudo apt-get update -qq
sudo apt-get install -y -qq python3 python3-pip ffmpeg curl > /dev/null 2>&1
pip3 install -q yt-dlp readability-lxml requests 2>/dev/null || \
    pip3 install -q --break-system-packages yt-dlp readability-lxml requests

# whisper (可选，用于无字幕视频转录)
pip3 install -q openai-whisper 2>/dev/null || \
    pip3 install -q --break-system-packages openai-whisper 2>/dev/null || \
    echo "whisper 安装失败（可选，跳过）"

# 2. 确认知识库存在
echo "[2/6] 检查知识库..."
REPO_DIR="$HOME/obsidian"
if [[ ! -d "$REPO_DIR/.git" ]]; then
    echo "错误: ~/obsidian 不存在，请先克隆仓库:"
    echo "  git clone https://github.com/sufer2017/obsidian.git ~/obsidian"
    exit 1
fi
cd "$REPO_DIR"
git pull --quiet 2>/dev/null || true

# 3. Git 配置
echo "[3/6] 配置 Git..."
git config user.name "hermes-bot"
git config user.email "hermes@bot"

# 4. 配置 HTTPS push (token 认证)
echo "[4/6] 配置 Git push..."
git config credential.helper store
CURRENT_REMOTE=$(git remote get-url origin 2>/dev/null || echo "")
if [[ "$CURRENT_REMOTE" == git@* ]]; then
    git remote set-url origin https://github.com/sufer2017/obsidian.git
    echo "已切换 remote 为 HTTPS"
fi

if ! git ls-remote origin &>/dev/null; then
    echo ""
    echo "⚠ Git push 需要 GitHub Personal Access Token"
    echo "请执行以下命令配置（只需一次）:"
    echo ""
    echo '  echo "https://sufer2017:<YOUR_TOKEN>@github.com" >> ~/.git-credentials'
    echo ""
    echo "Token 获取: GitHub → Settings → Developer settings → Personal access tokens → Fine-grained"
    echo "权限: 只需 Contents (Read and Write)"
    echo ""
    HAS_TOKEN=false
else
    echo "Git push 已就绪"
    HAS_TOKEN=true
fi

# 5. 设置脚本权限
echo "[5/6] 设置权限..."
chmod +x bin/*.sh

# 6. 构建初始缓存
echo "[6/6] 构建知识库缓存..."
bash bin/build-context.sh

# 7. 设置 cron: 每小时自动更新缓存
echo "[bonus] 设置定时任务..."
CRON_CMD="cd $REPO_DIR && git pull --quiet && bash bin/build-context.sh > /dev/null 2>&1"
(crontab -l 2>/dev/null | grep -v "build-context"; echo "0 * * * * $CRON_CMD") | crontab -

echo ""
echo "=== 初始化完成 ==="
echo ""
if [[ "$HAS_TOKEN" == "false" ]]; then
    echo "⚠ 还差一步: 配置 GitHub Token (见上方说明)"
    echo ""
fi
echo "Hermes 命令配置："
echo "  学习: cd ~/obsidian && bash bin/learn.sh <URL>"
echo "  问答: cd ~/obsidian && bash bin/ask.sh \"<问题>\""
echo "  最近: cd ~/obsidian && bash bin/recent.sh"
echo ""
echo "缓存每小时自动更新，问答秒回。"
