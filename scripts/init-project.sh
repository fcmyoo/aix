#!/usr/bin/env bash
# aix init-project — 在现有项目中初始化 aix 工具链
set -euo pipefail

AIX_DIR="$(cd "$(dirname "$0")/.." && pwd)"
PROJECT_DIR="${1:-$(pwd)}"

echo "🔧 aix init-project"
echo " Target: $PROJECT_DIR"
echo " AIX:    $AIX_DIR"
echo ""

# ── 前置检测 ──────────────────────────────────
cd "$PROJECT_DIR"

if ! git rev-parse --show-toplevel >/dev/null 2>&1; then
  echo "❌ 错误：当前目录不在 git 仓库中"
  exit 1
fi

PROJECT_NAME="$(basename "$(git rev-parse --show-toplevel)")"

if ! command -v openspec &>/dev/null; then
  echo "❌ 错误：openspec 未安装。请先安装：npm install -g openspec"
  exit 1
fi

# ── 1. OpenSpec 初始化 ────────────────────────
echo "📦 [1/5] OpenSpec 初始化..."
if [ -f "openspec/config.yaml" ]; then
  echo "   ⏭️  openspec/ 已存在，跳过"
else
  openspec init --tools claude .
  echo "   ✅ OpenSpec 初始化完成"
fi

# ── 2. CLAUDE.md ──────────────────────────────
echo "📝 [2/5] 生成 CLAUDE.md..."
if [ -f "CLAUDE.md" ]; then
  echo "   ⏭️  CLAUDE.md 已存在，跳过（如需重新生成请删除后重跑）"
else
  TEMPLATE="$AIX_DIR/template/CLAUDE.md"
  if [ -f "$TEMPLATE" ]; then
    # 从 package.json 推断命令
    DEV_CMD=""
    BUILD_CMD=""
    TEST_CMD=""
    if [ -f "package.json" ]; then
      DEV_CMD=$(node -e "const p=require('./package.json');console.log(p.scripts?.dev||p.scripts?.['electron:dev']||p.scripts?.start||'')" 2>/dev/null || true)
      BUILD_CMD=$(node -e "const p=require('./package.json');console.log(p.scripts?.build||'')" 2>/dev/null || true)
      TEST_CMD=$(node -e "const p=require('./package.json');console.log(p.scripts?.test||p.scripts?.typecheck||'')" 2>/dev/null || true)
    fi

    # 替换模板变量
    sed "s/{{project_name}}/$PROJECT_NAME/g; \
         s|{{dev_command}}|$DEV_CMD|g; \
         s|{{build_command}}|$BUILD_CMD|g; \
         s|{{test_command}}|$TEST_CMD|g" \
      "$TEMPLATE" > "CLAUDE.md"
    echo "   ✅ CLAUDE.md 已生成"
  else
    echo "   ⚠️  模板文件不存在，跳过"
  fi
fi

# ── 3. gstack ─────────────────────────────────
echo "🔍 [3/5] gstack 注册..."
if [ -d "$HOME/.claude/skills/gstack/bin" ]; then
  if grep -q "gstack" CLAUDE.md 2>/dev/null; then
    echo "   ⏭️  CLAUDE.md 已有 gstack 章节，跳过"
  else
    cd "$HOME/.claude/skills/gstack" && ./bin/gstack-team-init optional 2>/dev/null || true
    cd "$PROJECT_DIR"
    echo "   ✅ gstack 章节已追加"
  fi
else
  echo "   ⏭️  gstack 未安装，跳过（可选功能）"
fi

# ── 4. OMX 目录 ──────────────────────────────
echo "📁 [4/5] OMX 目录（可选）..."
mkdir -p .omx/{plans,team,state,runtime,logs}
echo "   ✅ .omx/ 目录结构已创建"

# ── 5. 工具脚本 ──────────────────────────────
echo "🔧 [5/5] 工具脚本..."
mkdir -p scripts
if [ -f "$AIX_DIR/scripts/check-conflict-markers.sh" ]; then
  cp "$AIX_DIR/scripts/check-conflict-markers.sh" scripts/
  chmod +x scripts/check-conflict-markers.sh
  echo "   ✅ scripts/check-conflict-markers.sh"
fi

# 尝试追加到 package.json
if [ -f "package.json" ]; then
  if ! grep -q '"check:conflicts"' package.json 2>/dev/null; then
    node -e "
      const p = require('./package.json');
      p.scripts = p.scripts || {};
      p.scripts['check:conflicts'] = 'bash ./scripts/check-conflict-markers.sh';
      require('fs').writeFileSync('package.json', JSON.stringify(p, null, 2) + '\n');
    " 2>/dev/null && echo "   ✅ npm run check:conflicts added" || true
  fi
fi

echo ""
echo "✅ aix 工具链初始化完成！"
echo ""
echo "项目 $PROJECT_NAME 已配备："
echo "  - OpenSpec: $(ls .claude/skills/openspec-* 2>/dev/null | wc -l) skills"
echo "  - CLAUDE.md: 开发工作流"
echo "  - OMX: Codex CLI 双运行模式"
echo "  - scripts/: 工具脚本"
echo ""
echo "下一步：启动 Claude Code，输入 /aix-start 开始开发"
