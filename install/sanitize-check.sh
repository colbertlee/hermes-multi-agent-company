#!/bin/bash
# install/sanitize-check.sh - 数据脱敏检查（push 前必须运行）
# Usage: bash install/sanitize-check.sh

set -e

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "🔒 Checking for sensitive data before push..."
echo ""

# 检查项
SENSITIVE_PATTERNS=(
    "API[_-]?KEY"
    "secret"
    "password"
    "token"
    "/home/[a-zA-Z]+"
    "/Users/[a-zA-Z]+"
    "DESKTOP-[A-Z0-9]+"  # 计算机名
    "colbert@"           # 用户名
    "金融客户"             # 实际客户描述
    "某金融"
    "210-AOWQ"            # 实际 SKU（参考用）
)

WARN_COUNT=0

for pattern in "${SENSITIVE_PATTERNS[@]}"; do
    HITS=$(grep -rnEi "$pattern" "$REPO_ROOT" \
        --include="*.md" --include="*.yaml" --include="*.py" --include="*.sh" \
        --exclude-dir=.git --exclude-dir=node_modules 2>/dev/null || true)

    if [ -n "$HITS" ]; then
        echo "⚠️  Pattern '$pattern' found:"
        echo "$HITS" | head -3
        echo ""
        WARN_COUNT=$((WARN_COUNT + 1))
    fi
done

# 检查 .env 文件（绝对不能进 git）
echo "Checking for .env files..."
ENV_FILES=$(find "$REPO_ROOT" -name ".env*" -type f 2>/dev/null | grep -v ".env.example" || true)
if [ -n "$ENV_FILES" ]; then
    echo "❌ .env files found (NEVER commit these):"
    echo "$ENV_FILES"
    WARN_COUNT=$((WARN_COUNT + 1))
else
    echo "  ✅ No .env files"
fi

echo ""

if [ $WARN_COUNT -eq 0 ]; then
    echo "✅ Sanitization check passed. Safe to push."
    exit 0
else
    echo "❌ Found $WARN_COUNT potential issue(s). Review above."
    echo ""
    echo "Common fixes:"
    echo "  - Replace /home/colbert with \$HOME or \$HERMES_HOME"
    echo "  - Replace real customer info with generic placeholders"
    echo "  - Move real configs to .env (and add .env to .gitignore)"
    echo "  - Use examples/sample-* for code samples"
    exit 1
fi