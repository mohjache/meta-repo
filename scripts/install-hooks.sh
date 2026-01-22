#!/bin/bash
#
# Install git hooks for ralph-cloud-setup
#

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
HOOKS_DIR="$REPO_ROOT/hooks"
GIT_HOOKS_DIR="$REPO_ROOT/.git/hooks"

echo "🔧 Installing git hooks..."
echo ""

# Check if we're in a git repository
if [ ! -d "$REPO_ROOT/.git" ]; then
    echo "❌ Error: Not in a git repository"
    exit 1
fi

# Create .git/hooks directory if it doesn't exist
mkdir -p "$GIT_HOOKS_DIR"

# Install pre-commit hook
if [ -f "$HOOKS_DIR/pre-commit" ]; then
    cp "$HOOKS_DIR/pre-commit" "$GIT_HOOKS_DIR/pre-commit"
    chmod +x "$GIT_HOOKS_DIR/pre-commit"
    echo "✓ Installed pre-commit hook"
else
    echo "❌ Error: hooks/pre-commit not found"
    exit 1
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ Git hooks installed successfully!"
echo ""
echo "The pre-commit hook will now run automatically before every commit."
echo ""
echo "Optional tools for enhanced validation:"
echo "  • shellcheck  - Shell script linting"
echo "  • hadolint    - Dockerfile linting"
echo "  • yamllint    - YAML validation"
echo "  • jq          - JSON validation"
echo ""
echo "Install on Ubuntu/Debian:"
echo "  sudo apt install shellcheck jq yamllint"
echo ""
echo "Install hadolint:"
echo "  wget -O /usr/local/bin/hadolint https://github.com/hadolint/hadolint/releases/latest/download/hadolint-Linux-x86_64"
echo "  chmod +x /usr/local/bin/hadolint"
echo ""
echo "To test the hook manually: make validate"
echo "To bypass the hook: git commit --no-verify (not recommended)"
echo ""
