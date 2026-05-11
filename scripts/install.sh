#!/usr/bin/env bash
# aix install — 安装所有 skills 到 ~/.claude/skills/
set -euo pipefail

AIX_DIR="$(cd "$(dirname "$0")/.." && pwd)"
SKILLS_SRC="$AIX_DIR/skills"
SKILLS_DST="$HOME/.claude/skills"

echo "🔧 Installing aix skills..."

# 确保目标目录存在
mkdir -p "$SKILLS_DST"

for skill_dir in "$SKILLS_SRC"/*/; do
  skill_name="$(basename "$skill_dir")"
  target="$SKILLS_DST/$skill_name"

  if [ -L "$target" ]; then
    rm -f "$target"
  elif [ -d "$target" ]; then
    # 非交互式时用环境变量 AIX_FORCE=1 跳过确认
    if [ "${AIX_FORCE:-0}" != "1" ] && [ -t 0 ]; then
      read -p "  ⚠️  Skill $skill_name 已存在，覆盖？[y/N] " confirm
      if [ "$confirm" != "y" ] && [ "$confirm" != "Y" ]; then
        echo "  ⏭️  跳过 $skill_name"
        continue
      fi
    fi
    rm -rf "$target"
  fi

  cp -r "$skill_dir" "$target"
  echo "  ✅ $skill_name"
done

echo ""
echo "✅ aix 安装完成，共 $(ls -d "$SKILLS_SRC"/*/ | wc -l) 个 skill"
echo ""
echo "可用命令："
for skill_dir in "$SKILLS_SRC"/*/; do
  skill_name="$(basename "$skill_dir")"
  echo "  /$skill_name"
done
echo ""
echo "现在启动 Claude Code 即可使用以上命令。"
