#!/bin/bash
# Safe Ralph Loop Runner for Codespaces
# Runs with resource limits and timeout

set -e

# Configuration
MAX_DURATION="${MAX_DURATION:-30m}"  # Maximum loop duration
CPU_LIMIT="${CPU_LIMIT:-0.8}"        # CPU cores limit
MEM_LIMIT="${MEM_LIMIT:-2g}"         # Memory limit
SLEEP_BETWEEN="${SLEEP_BETWEEN:-5}"  # Seconds between iterations
WORKSPACE_DIR="${WORKSPACE_DIR:-$HOME/ralph-workspace}"

echo "=========================================="
echo "Ralph Safe Loop Runner"
echo "=========================================="
echo ""

# Load .env if exists
if [ -f .env ]; then
    export $(grep -v '^#' .env | xargs)
fi

# Check API key
if [ -z "$ANTHROPIC_API_KEY" ]; then
    echo "Error: ANTHROPIC_API_KEY not set"
    echo "Run: ./scripts/setup-api-key.sh"
    exit 1
fi

# Check PROMPT.md exists
cd "$WORKSPACE_DIR"
if [ ! -f "PROMPT.md" ]; then
    echo "Error: PROMPT.md not found in $WORKSPACE_DIR"
    echo "Create a PROMPT.md file with your task description"
    exit 1
fi

# Build Ralph runner image if not exists
if ! docker images | grep -q ralph-runner; then
    echo "Building Ralph runner image..."
    docker build -f ../Dockerfile.ralph -t ralph-runner:latest ..
fi

echo "Starting Ralph loop with safety controls:"
echo "  - Max duration: $MAX_DURATION"
echo "  - CPU limit: $CPU_LIMIT cores"
echo "  - Memory limit: $MEM_LIMIT"
echo "  - Sleep between iterations: ${SLEEP_BETWEEN}s"
echo "  - Workspace: $WORKSPACE_DIR"
echo ""
echo "Press Ctrl+C to stop"
echo ""

# Run with Docker resource limits and timeout
docker run --rm \
  --name ralph-loop \
  --cpus="$CPU_LIMIT" \
  --memory="$MEM_LIMIT" \
  -v "$WORKSPACE_DIR:/workspace" \
  -w /workspace \
  -e ANTHROPIC_API_KEY="${ANTHROPIC_API_KEY}" \
  ralph-runner:latest \
  timeout "$MAX_DURATION" bash -c "
    iteration=1
    while :; do
      echo '=========================================='
      echo '=== Ralph Iteration '\$iteration' at \$(date) ==='
      echo '=========================================='
      cat PROMPT.md | claude || echo 'Error in iteration '\$iteration
      echo ''
      echo '=== Iteration '\$iteration' complete ==='
      echo ''
      iteration=\$((iteration + 1))
      sleep $SLEEP_BETWEEN
    done
  "

echo ""
echo "=========================================="
echo "Ralph loop ended"
echo "=========================================="
