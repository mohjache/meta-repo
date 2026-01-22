#!/bin/bash
# Post-creation script for GitHub Codespaces
# This runs automatically after the Codespace is created

set -e

echo "==========================================="
echo "Setting up Ralph Loops Environment..."
echo "==========================================="

# Create workspace directory if it doesn't exist
mkdir -p ~/ralph-workspace
cd ~/ralph-workspace

# Make all scripts executable
if [ -d "${WORKSPACE_DIR}/scripts" ]; then
    chmod +x ${WORKSPACE_DIR}/scripts/*.sh
    echo "✓ Made scripts executable"
fi

# Build the Ralph runner Docker image
if [ -f "${WORKSPACE_DIR}/Dockerfile.ralph" ]; then
    echo "Building Ralph runner Docker image..."
    docker build -f ${WORKSPACE_DIR}/Dockerfile.ralph -t ralph-runner:latest ${WORKSPACE_DIR}
    echo "✓ Ralph runner image built"
else
    echo "⚠ Dockerfile.ralph not found, will create it..."
fi

# Copy example files to workspace if they don't exist
if [ ! -f ~/ralph-workspace/PROMPT.md ]; then
    cp ${WORKSPACE_DIR}/prompts/PROMPT.md ~/ralph-workspace/ 2>/dev/null || echo "# Ralph Agent Prompt

You are Ralph, an autonomous coding agent.

## Your Current Task

[REPLACE THIS WITH YOUR ACTUAL TASK]

Example: Create a simple web server in Python that responds with \"Hello, Ralph!\" on port 8000.

## Guidelines

1. Execute the task step by step
2. Verify your work by running the code
3. Report any errors or issues encountered
4. Summarize what you accomplished in this iteration

## Important

- Work within /workspace directory
- All files persist between iterations
- Keep iterations focused and incremental" > ~/ralph-workspace/PROMPT.md
    echo "✓ Created default PROMPT.md"
fi

# Load .env file if it exists
if [ -f "${WORKSPACE_DIR}/.env" ]; then
    set -a
    source ${WORKSPACE_DIR}/.env
    set +a
    echo "✓ Loaded environment variables from .env"
fi

# Verify Claude CLI installation
if command -v claude &> /dev/null; then
    echo "✓ Claude Code CLI installed: $(claude --version)"
else
    echo "⚠ Claude Code CLI not found, installing..."
    npm install -g @anthropic-ai/claude-code
fi

# Verify Docker installation
if command -v docker &> /dev/null; then
    echo "✓ Docker installed: $(docker --version)"
else
    echo "⚠ Docker not available"
fi

# Check if API key is set
if [ -z "$ANTHROPIC_API_KEY" ]; then
    echo ""
    echo "⚠ ANTHROPIC_API_KEY not set!"
    echo "Run: ./scripts/setup-api-key.sh"
    echo "Or add it to GitHub Codespaces secrets"
else
    echo "✓ ANTHROPIC_API_KEY configured"
fi

echo ""
echo "==========================================="
echo "✓ Ralph Loops Environment Ready!"
echo "==========================================="
echo ""
echo "Quick Start:"
echo "  1. Set API key: ./scripts/setup-api-key.sh"
echo "  2. Edit prompt: nano ~/ralph-workspace/PROMPT.md"
echo "  3. Run loop: ./scripts/run-safe-loop.sh"
echo ""
echo "Useful Commands:"
echo "  - Monitor: ./scripts/monitor.sh"
echo "  - Cleanup: ./scripts/cleanup.sh"
echo "  - Test CLI: echo 'Hello Ralph' | claude"
echo ""
