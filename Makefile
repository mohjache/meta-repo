# Makefile for Ralph Loops
# Makes common operations easy with simple commands

.PHONY: help setup run monitor stop cleanup test build validate install-hooks

# Default target
help:
	@echo "Ralph Loops - Available Commands:"
	@echo ""
	@echo "  make setup          - Configure API key"
	@echo "  make run            - Run Ralph loop with safe defaults"
	@echo "  make monitor        - Monitor running loop"
	@echo "  make stop           - Stop current loop"
	@echo "  make cleanup        - Stop and cleanup all containers"
	@echo "  make test           - Test Claude CLI with simple prompt"
	@echo "  make build          - Build Ralph runner Docker image"
	@echo "  make validate       - Run validation checks (pre-commit)"
	@echo "  make install-hooks  - Install git pre-commit hooks"
	@echo ""
	@echo "Configuration:"
	@echo "  Edit .env file or ~/ralph-workspace/PROMPT.md"
	@echo ""

# Setup API key
setup:
	@./scripts/setup-api-key.sh

# Install git hooks
install-hooks:
	@./scripts/install-hooks.sh

# Run validation checks
validate:
	@./scripts/validate.sh

# Build Docker image
build:
	@echo "Building Ralph runner image..."
	@docker build -f Dockerfile.ralph -t ralph-runner:latest .
	@echo "✓ Image built successfully"

# Run Ralph loop
run:
	@./scripts/run-safe-loop.sh

# Monitor resources
monitor:
	@./scripts/monitor.sh

# Stop loop
stop:
	@docker stop ralph-loop 2>/dev/null || echo "No ralph-loop container running"

# Full cleanup
cleanup:
	@./scripts/cleanup.sh

# Test Claude CLI
test:
	@if [ -z "$$ANTHROPIC_API_KEY" ]; then \
		echo "Error: ANTHROPIC_API_KEY not set. Run 'make setup' first."; \
		exit 1; \
	fi
	@echo "Testing Claude CLI..."
	@echo "Write a haiku about coding" | claude
