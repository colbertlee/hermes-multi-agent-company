#!/bin/bash
# install/push-to-github.sh - 一站式推送到 GitHub
# Usage: bash install/push-to-github.sh <github-username>

set -e

USERNAME="${1:-}"
if [ -z "$USERNAME" ]; then
    echo "Usage: bash install/push-to-github.sh <github-username>"
    echo "Example: bash install/push-to-github.sh colbert"
    exit 1
fi

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REPO_NAME="hermes-multi-agent-company"

echo "🦞 Pushing $REPO_NAME to GitHub as $USERNAME..."
echo ""

# 1. 检查 gh auth
if ! gh auth status &> /dev/null; then
    echo "❌ Not logged into GitHub. Run: gh auth login"
    exit 1
fi

echo "✅ GitHub auth OK"

# 2. 创建 repo (private)
cd "$REPO_DIR"

if ! gh repo view "$USERNAME/$REPO_NAME" &> /dev/null; then
    echo ""
    echo "Creating GitHub repo (private)..."
    gh repo create "$REPO_NAME" --private \
        --description "Hermes Multi-Agent Company — 3+1 multi-agent architecture (sanitized)" \
        --source=. --remote=origin --push
else
    echo ""
    echo "Repo already exists. Setting remote..."
    git remote remove origin 2>/dev/null || true
    git remote add origin "git@github.com:$USERNAME/$REPO_NAME.git"

    echo ""
    echo "Pushing to existing repo..."
    git push -u origin main
fi

# 3. Push tag
echo ""
echo "Pushing tag v1.1.0..."
git push origin v1.1.0 || true

# 4. Create release
echo ""
echo "Creating GitHub release..."
gh release create v1.1.0 \
    --title "v1.1.0 — 3+1 Multi-Agent Architecture" \
    --notes-file RELEASE_NOTES_v1.1.0.md \
    --latest

echo ""
echo "✅ Done!"
echo ""
echo "Repo URL: https://github.com/$USERNAME/$REPO_NAME"
echo "Release: https://github.com/$USERNAME/$REPO_NAME/releases/tag/v1.1.0"