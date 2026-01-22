#!/bin/bash
# Monitor Ralph loop resources

echo "=========================================="
echo "Ralph Loop Resource Monitor"
echo "=========================================="
echo ""

# Check if container is running
if docker ps --format '{{.Names}}' | grep -q ralph-loop; then
    echo "✓ Ralph container status: RUNNING"
    echo ""

    # Show resource usage
    echo "Resource usage:"
    docker stats --no-stream ralph-loop
    echo ""

    # Show logs (last 20 lines)
    echo "Recent logs (last 20 lines):"
    echo "----------------------------------------"
    docker logs --tail 20 ralph-loop
    echo "----------------------------------------"
else
    echo "⚠ Ralph container status: NOT RUNNING"
    echo ""
    echo "No active loops detected"
    echo ""
    echo "Start a loop with: ./scripts/run-safe-loop.sh"
fi

echo ""
echo "Overall system resources:"
echo "----------------------------------------"
free -h
echo ""
df -h /
echo "----------------------------------------"
