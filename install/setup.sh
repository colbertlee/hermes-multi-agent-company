#!/bin/bash
# install/setup.sh - 一键安装 Designer Skill 工具
# Usage: bash install/setup.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DESIGNER_DIR="$SCRIPT_DIR/scripts/designer"

echo "🦞 Installing Designer Skill Kit..."

# 1. Detect Python (Hermes venv 优先)
if [ -f "$HOME/.hermes/hermes-agent/venv/bin/python" ]; then
    PY="$HOME/.hermes/hermes-agent/venv/bin/python"
    PIP="$HOME/.hermes/hermes-agent/venv/bin/pip"
    echo "Using Hermes venv Python: $PY"
elif command -v python3 &> /dev/null; then
    PY="python3"
    PIP="pip3"
    echo "Using system Python: $PY"
    echo "⚠️  If you hit 'externally-managed-environment', use Hermes venv"
else
    echo "❌ Python not found. Install Python 3.11+ first."
    exit 1
fi

# 2. Install designer dependencies
echo ""
echo "Installing dependencies..."
$PIP install reportlab python-pptx matplotlib pandas 2>&1 | tail -5

# 3. Create symlink for designer command
DESIGNER_BIN="$HOME/.local/bin/designer"
mkdir -p "$HOME/.local/bin"

if [ -f "$DESIGNER_DIR/designer" ]; then
    ln -sf "$DESIGNER_DIR/designer" "$DESIGNER_BIN"
    echo ""
    echo "✅ Designer command installed at: $DESIGNER_BIN"
    echo "   Make sure ~/.local/bin is in your PATH"
fi

# 4. Verify
echo ""
echo "Verifying installation..."
$PY -c "import reportlab, pptx, matplotlib, pandas; print('✅ All dependencies OK')" || {
    echo "❌ Some dependencies missing. Try installing manually."
    exit 1
}

echo ""
echo "🦞 Designer Skill Kit installed successfully!"
echo ""
echo "Usage:"
echo "  designer pdf  -i input.md  -o output.pdf"
echo "  designer ppt  -i outline.md -o output.pptx"
echo "  designer chart -i data.csv -o chart.png -t line -x time -y value"