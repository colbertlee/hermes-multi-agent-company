#!/bin/bash
# install/validate.sh - 验证安装完整性
# Usage: bash install/validate.sh

set -e

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "🔍 Validating Hermes Multi-Agent Company repo..."
echo ""

ERRORS=0

# 1. 必要文件检查
echo "1. Checking required files..."
for f in README.md LICENSE .gitignore \
         architecture/COMPANY_ARCHITECTURE.md \
         architecture/ARCHITECTURE_REVIEW.md \
         architecture/A2A_COST_PROTOCOL.md \
         profiles/README.md; do
    if [ -f "$REPO_ROOT/$f" ]; then
        echo "  ✅ $f"
    else
        echo "  ❌ MISSING: $f"
        ERRORS=$((ERRORS + 1))
    fi
done

echo ""

# 2. Skill 检查
echo "2. Checking skills..."
for skill_dir in "$REPO_ROOT"/skills/*/; do
    skill_name=$(basename "$skill_dir")
    if [ -f "$skill_dir/SKILL.md" ]; then
        # Check YAML frontmatter
        if head -1 "$skill_dir/SKILL.md" | grep -q "^---$"; then
            echo "  ✅ $skill_name (with frontmatter)"
        else
            echo "  ⚠️  $skill_name (no frontmatter)"
            ERRORS=$((ERRORS + 1))
        fi
    else
        echo "  ❌ $skill_name (no SKILL.md)"
        ERRORS=$((ERRORS + 1))
    fi
done

echo ""

# 3. Designer 脚本检查
echo "3. Checking designer scripts..."
for script in md_to_pdf.py outline_to_pptx.py data_to_chart.py designer; do
    if [ -f "$REPO_ROOT/scripts/designer/$script" ]; then
        if [[ "$script" == *.py ]]; then
            # Python syntax check
            if python3 -m py_compile "$REPO_ROOT/scripts/designer/$script" 2>/dev/null; then
                echo "  ✅ $script (syntax OK)"
            else
                echo "  ❌ $script (syntax error)"
                ERRORS=$((ERRORS + 1))
            fi
        else
            # Bash script check
            if [ -x "$REPO_ROOT/scripts/designer/$script" ]; then
                echo "  ✅ $script (executable)"
            else
                echo "  ⚠️  $script (not executable, run: chmod +x)"
            fi
        fi
    else
        echo "  ❌ MISSING: $script"
        ERRORS=$((ERRORS + 1))
    fi
done

echo ""

# 4. 数据脱敏检查（关键）
echo "4. Checking for data leaks..."
LEAK_PATTERNS=(
    "/home/colbert"
    "/Users/[a-zA-Z]+/"
    "MINIMAX_API_KEY=sk-"
    "workstation"
)

for pattern in "${LEAK_PATTERNS[@]}"; do
    if grep -rE "$pattern" "$REPO_ROOT" \
        --include="*.md" --include="*.yaml" --include="*.py" --include="*.sh" \
        --exclude-dir=.git --exclude-dir=node_modules 2>/dev/null | head -1; then
        echo "  ⚠️  Found potential leak: $pattern"
        ERRORS=$((ERRORS + 1))
    fi
done

if [ $ERRORS -eq 0 ]; then
    echo "  ✅ No obvious data leaks found"
fi

echo ""

# 总结
if [ $ERRORS -eq 0 ]; then
    echo "✅ All checks passed!"
    exit 0
else
    echo "❌ $ERRORS issue(s) found. Please fix before push."
    exit 1
fi