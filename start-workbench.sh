#!/usr/bin/env bash
# macOS / Linux launcher for DeepSeek Harness Video Workbench.
# Cross-platform equivalent of start-workbench.cmd — uses the system Node.js
# (Node >= 20) and starts the standalone workbench at http://127.0.0.1:4399.
set -euo pipefail
cd "$(dirname "$0")"

echo "======================================================================"
echo "🎬 正在启动 DeepSeek Harness 双引擎视频工作台 (macOS/Linux)..."
echo "   服务就绪后将自动打开实际监听的浏览器预览地址（默认 http://127.0.0.1:4399）"
echo "======================================================================"

if ! command -v node >/dev/null 2>&1; then
  echo "❌ 未检测到 Node.js，请先安装 Node.js 20 或更高版本：brew install node"
  exit 1
fi

NODE_MAJOR="$(node -p 'process.versions.node.split(".")[0]')"
if [ "$NODE_MAJOR" -lt 20 ]; then
  echo "⚠️ 当前 Node.js 版本过低（$NODE_MAJOR），建议升级到 20+（brew install node）"
fi

# Load optional DSH_APP_ROOT from .env (for native DSH CLI integration).
if [ -f .env ]; then
  DSH_APP_ROOT_FROM_ENV="$(grep -E '^DSH_APP_ROOT=' .env | head -1 | cut -d= -f2- | tr -d '"' || true)"
  if [ -n "${DSH_APP_ROOT_FROM_ENV:-}" ]; then
    export DSH_APP_ROOT="$DSH_APP_ROOT_FROM_ENV"
  fi
fi

exec node ./scripts/dsh-runner.mjs video --keep-alive --open
