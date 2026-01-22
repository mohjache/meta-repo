#!/bin/bash
# Cleanup script - stops all Ralph containers and cleans up resources

echo "=========================================="
echo "Ralph Cleanup"
echo "=========================================="
echo ""

echo "Stopping Ralph containers..."
docker stop ralph-loop 2>/dev/null && echo "✓ Stopped ralph-loop" || echo "⚠ No ralph-loop container running"

echo ""
echo "Stopping any other Ralph runner containers..."
docker stop $(docker ps -q --filter ancestor=ralph-runner:latest) 2>/dev/null || echo "⚠ No other containers running"

echo ""
echo "Removing stopped containers..."
docker container prune -f

echo ""
echo "Cleaning up Docker system..."
docker system prune -f

echo ""
echo "=========================================="
echo "✓ Cleanup complete!"
echo "=========================================="
echo ""
echo "System status:"
docker ps
