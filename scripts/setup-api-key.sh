#!/bin/bash
# Setup Claude API Key for Codespaces

set -e

echo "=========================================="
echo "Claude API Key Setup"
echo "=========================================="
echo ""

# Check if .env exists
if [ -f .env ]; then
    echo "Found existing .env file"
    source .env
    if [ -n "$ANTHROPIC_API_KEY" ]; then
        echo "API key already configured: ${ANTHROPIC_API_KEY:0:20}..."
        read -p "Do you want to update it? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 0
        fi
    fi
fi

echo "Get your API key from: https://console.anthropic.com/settings/keys"
echo ""
read -p "Enter your Anthropic API key: " api_key

if [ -z "$api_key" ]; then
    echo "Error: API key cannot be empty"
    exit 1
fi

# Validate format (basic check)
if [[ ! $api_key =~ ^sk-ant- ]]; then
    echo "Warning: API key doesn't match expected format (should start with 'sk-ant-')"
    read -p "Continue anyway? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# Save to .env file
echo "ANTHROPIC_API_KEY=$api_key" > .env
echo ""
echo "✓ API key saved to .env file"

# Export for current session
export ANTHROPIC_API_KEY=$api_key
echo "✓ API key exported for current session"

# Add to .bashrc for future sessions
if ! grep -q "ANTHROPIC_API_KEY" ~/.bashrc; then
    echo "" >> ~/.bashrc
    echo "# Claude API Key" >> ~/.bashrc
    echo "if [ -f \"\$(pwd)/.env\" ]; then" >> ~/.bashrc
    echo "    export \$(grep -v '^#' .env | xargs)" >> ~/.bashrc
    echo "fi" >> ~/.bashrc
    echo "✓ Added .env loading to .bashrc"
fi

echo ""
echo "=========================================="
echo "Setup Complete!"
echo "=========================================="
echo ""
echo "Test your setup with:"
echo "  echo 'Write a haiku about coding' | claude"
echo ""
