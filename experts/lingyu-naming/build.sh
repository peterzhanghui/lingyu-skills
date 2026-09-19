#!/usr/bin/env bash
# 打包 WorkBuddy 专家「灵玉」为可提审的 zip。
#
# 技能只有一份真源：仓库根目录的 skills/create-chinese-names/。
# 本脚本在打包时把它复制进专家包，避免仓库里存两份规则导致漂移。
#
# 用法：bash experts/lingyu-naming/build.sh

set -euo pipefail

EXPERT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$EXPERT_DIR/../.." && pwd)"
SKILL_SRC="$REPO_ROOT/skills/create-chinese-names"
STAGE="$EXPERT_DIR/.build/lingyu-naming"
DIST="$EXPERT_DIR/dist"

[ -d "$SKILL_SRC" ] || { echo "找不到技能真源：$SKILL_SRC" >&2; exit 1; }

VERSION="$(node -p "require('$EXPERT_DIR/.codebuddy-plugin/plugin.json').version")"

rm -rf "$EXPERT_DIR/.build"
mkdir -p "$STAGE" "$DIST"

# 专家自身文件
cp -R "$EXPERT_DIR/.codebuddy-plugin" "$STAGE/"
cp -R "$EXPERT_DIR/agents"            "$STAGE/"
cp -R "$EXPERT_DIR/avatars"           "$STAGE/"
cp    "$EXPERT_DIR/README.md"         "$STAGE/"
cp    "$REPO_ROOT/LICENSE"            "$STAGE/"

# 技能真源复制进来
mkdir -p "$STAGE/skills"
cp -R "$SKILL_SRC" "$STAGE/skills/create-chinese-names"

# 清掉复制过程中可能带入的系统文件
find "$STAGE" -name '.DS_Store' -delete

# 平台要求打包目录内容，不含外层文件夹
ZIP="$DIST/lingyu-naming-v$VERSION.zip"
rm -f "$ZIP"
( cd "$STAGE" && zip -qr "$ZIP" . -x '.DS_Store' )

rm -rf "$EXPERT_DIR/.build"

echo "已生成：$ZIP"
unzip -l "$ZIP" | tail -n +4 | head -20
