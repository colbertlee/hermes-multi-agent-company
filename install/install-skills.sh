#!/bin/bash
# install/install-skills.sh - 安装所有 skill 到默认 Hermes 目录
# Usage: bash install/install-skills.sh [--target <hermes_home>]

set -e

# Default target
HERMES_HOME="${HERMES_HOME:-$HOME/.hermes}"
SKILLS_SOURCE="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/skills"

# Parse args
while [[ $# -gt 0 ]]; do
    case $1 in
        --target)
            HERMES_HOME="$2"
            shift 2
            ;;
        *)
            echo "Unknown arg: $1"
            exit 1
            ;;
    esac
done

echo "🦞 Installing skills to: $HERMES_HOME/skills/"
echo ""

# 创建 skills 目录
mkdir -p "$HERMES_HOME/skills"

# 复制每个 skill
for skill_dir in "$SKILLS_SOURCE"/*/; do
    skill_name=$(basename "$skill_dir")
    target="$HERMES_HOME/skills/$skill_name"

    if [ -f "$skill_dir/SKILL.md" ]; then
        mkdir -p "$target"
        cp "$skill_dir/SKILL.md" "$target/SKILL.md"
        echo "✅ Installed: $skill_name"
    else
        echo "⚠️  Skipped (no SKILL.md): $skill_name"
    fi
done

echo ""
echo "🦞 All skills installed!"
echo ""
echo "Next steps:"
echo "  1. Restart Hermes: systemctl --user restart hermes-gateway"
echo "  2. Verify: hermes skills list"
echo "  3. Test: hermes chat --skills multi-agent-routing"