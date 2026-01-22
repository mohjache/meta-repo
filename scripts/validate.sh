#!/bin/bash
#
# Validate repository without committing
# Runs the same checks as the pre-commit hook
#

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

cd "$REPO_ROOT"

echo "🔍 Running validation checks..."
echo ""

# Source the pre-commit hook logic but don't check git staged files
# Instead, run all validations on the current state

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

ERRORS=0

# Function to print success
success() {
    echo -e "${GREEN}✓${NC} $1"
}

# Function to print error
error() {
    echo -e "${RED}✗${NC} $1"
    ERRORS=$((ERRORS + 1))
}

# Function to print warning
warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

# ============================================================================
# 1. Check for secrets/sensitive files
# ============================================================================
echo "1️⃣  Checking for secrets..."

if [ -f ".env" ] && grep -qE "sk-ant-|ANTHROPIC_API_KEY=.{20,}" .env 2>/dev/null; then
    warning ".env exists and contains API key (make sure it's in .gitignore)"
fi

if grep -r -I --exclude-dir=.git --exclude-dir=node_modules --exclude="*.example" \
   -E "(sk-ant-[a-zA-Z0-9]{40,})" . 2>/dev/null | grep -v "your_key_here" | grep -v ".sh:"; then
    error "Possible API key found in repository files"
fi

if [ $ERRORS -eq 0 ]; then
    success "No secrets detected in committed files"
fi

echo ""

# ============================================================================
# 2. Validate shell scripts
# ============================================================================
echo "2️⃣  Validating shell scripts..."

SCRIPT_ERRORS=0

# Check if shellcheck is available
if command -v shellcheck &> /dev/null; then
    for script in scripts/*.sh hooks/*.sh .devcontainer/*.sh; do
        if [ -f "$script" ]; then
            if shellcheck -x "$script" 2>&1 | grep -v "^$" > /dev/null; then
                error "ShellCheck found issues in $script"
                shellcheck -x "$script" | head -20
                SCRIPT_ERRORS=$((SCRIPT_ERRORS + 1))
            else
                success "$(basename "$script") passes shellcheck"
            fi
        fi
    done
else
    warning "shellcheck not found - skipping script linting"
    echo "    Install: sudo apt install shellcheck"
fi

# Check for bash syntax errors
for script in scripts/*.sh .devcontainer/*.sh hooks/*.sh; do
    if [ -f "$script" ]; then
        if ! bash -n "$script" 2>/dev/null; then
            error "Syntax error in $script"
            bash -n "$script"
            SCRIPT_ERRORS=$((SCRIPT_ERRORS + 1))
        fi
    fi
done

if [ $SCRIPT_ERRORS -eq 0 ]; then
    success "All scripts validated"
fi

echo ""

# ============================================================================
# 3. Validate Docker files
# ============================================================================
echo "3️⃣  Validating Docker configurations..."

DOCKER_ERRORS=0

# Check if hadolint is available for Dockerfile linting
if command -v hadolint &> /dev/null; then
    for dockerfile in Dockerfile.ralph .devcontainer/Dockerfile; do
        if [ -f "$dockerfile" ]; then
            if hadolint "$dockerfile" 2>&1 | grep -v "^$" > /dev/null; then
                warning "Hadolint suggestions for $dockerfile:"
                hadolint "$dockerfile" | head -10
            else
                success "$(basename "$dockerfile") passes hadolint"
            fi
        fi
    done
else
    warning "hadolint not found - skipping Dockerfile linting"
    echo "    Install: https://github.com/hadolint/hadolint#install"
fi

# Validate Dockerfile syntax
for dockerfile in Dockerfile.ralph .devcontainer/Dockerfile; do
    if [ -f "$dockerfile" ]; then
        if grep -E "^FROM |^RUN |^COPY |^WORKDIR " "$dockerfile" > /dev/null; then
            success "$(basename "$dockerfile") basic syntax check passed"
        else
            error "$dockerfile appears to have invalid syntax"
            DOCKER_ERRORS=$((DOCKER_ERRORS + 1))
        fi
    fi
done

# Validate docker-compose.yml
if command -v docker-compose &> /dev/null; then
    if docker-compose config > /dev/null 2>&1; then
        success "docker-compose.yml is valid"
    else
        error "docker-compose.yml has syntax errors"
        docker-compose config
        DOCKER_ERRORS=$((DOCKER_ERRORS + 1))
    fi
elif command -v docker &> /dev/null; then
    if docker compose config > /dev/null 2>&1; then
        success "docker-compose.yml is valid"
    else
        error "docker-compose.yml has syntax errors"
        docker compose config
        DOCKER_ERRORS=$((DOCKER_ERRORS + 1))
    fi
else
    warning "docker-compose not available - skipping validation"
fi

if [ $DOCKER_ERRORS -eq 0 ]; then
    success "Docker configurations validated"
fi

echo ""

# ============================================================================
# 4. Validate JSON/YAML files
# ============================================================================
echo "4️⃣  Validating configuration files..."

CONFIG_ERRORS=0

# Validate JSON files
JSON_VALIDATOR_AVAILABLE=0
if command -v jq &> /dev/null; then
    JSON_VALIDATOR_AVAILABLE=1
elif command -v python3 &> /dev/null && python3 -c "import json" 2>/dev/null; then
    JSON_VALIDATOR_AVAILABLE=1
fi

for jsonfile in .devcontainer/devcontainer.json; do
    if [ -f "$jsonfile" ]; then
        if command -v jq &> /dev/null; then
            if jq empty "$jsonfile" > /dev/null 2>&1; then
                success "$(basename "$jsonfile") is valid JSON"
            else
                error "$jsonfile has invalid JSON syntax"
                jq empty "$jsonfile"
                CONFIG_ERRORS=$((CONFIG_ERRORS + 1))
            fi
        elif command -v python3 &> /dev/null && python3 -c "import json" 2>/dev/null; then
            if python3 -m json.tool "$jsonfile" > /dev/null 2>&1; then
                success "$(basename "$jsonfile") is valid JSON"
            else
                error "$jsonfile has invalid JSON syntax"
                CONFIG_ERRORS=$((CONFIG_ERRORS + 1))
            fi
        else
            warning "$(basename "$jsonfile") - skipping validation (no validator available)"
        fi
    fi
done

if [ $JSON_VALIDATOR_AVAILABLE -eq 0 ]; then
    warning "jq/python3 not found - JSON validation skipped"
    echo "    Install: sudo apt install jq"
fi

# Validate YAML files
YAML_VALIDATOR_AVAILABLE=0
if command -v yamllint &> /dev/null; then
    YAML_VALIDATOR_AVAILABLE=1
elif command -v python3 &> /dev/null && python3 -c "import yaml" 2>/dev/null; then
    YAML_VALIDATOR_AVAILABLE=1
fi

for yamlfile in .github/workflows/*.yml docker-compose.yml; do
    if [ -f "$yamlfile" ]; then
        if command -v yamllint &> /dev/null; then
            if yamllint -d relaxed "$yamlfile" > /dev/null 2>&1; then
                success "$(basename "$yamlfile") is valid YAML"
            else
                warning "YAML linting suggestions for $(basename "$yamlfile"):"
                yamllint -d relaxed "$yamlfile" | head -10
            fi
        elif command -v python3 &> /dev/null && python3 -c "import yaml" 2>/dev/null; then
            if python3 -c "import yaml; yaml.safe_load(open('$yamlfile'))" > /dev/null 2>&1; then
                success "$(basename "$yamlfile") is valid YAML"
            else
                error "$yamlfile has invalid YAML syntax"
                CONFIG_ERRORS=$((CONFIG_ERRORS + 1))
            fi
        else
            warning "$(basename "$yamlfile") - skipping validation (no validator available)"
        fi
    fi
done

if [ $YAML_VALIDATOR_AVAILABLE -eq 0 ]; then
    warning "yamllint/python3 not found - YAML validation skipped"
    echo "    Install: sudo apt install yamllint python3-yaml"
fi

if [ $CONFIG_ERRORS -eq 0 ]; then
    success "All configuration files validated"
fi

echo ""

# ============================================================================
# 5. Check file permissions
# ============================================================================
echo "5️⃣  Checking file permissions..."

PERM_ERRORS=0

# Check that scripts are executable
for script in scripts/*.sh hooks/pre-commit; do
    if [ -f "$script" ] && [ ! -x "$script" ]; then
        error "$script is not executable"
        echo "    Fix with: chmod +x $script"
        PERM_ERRORS=$((PERM_ERRORS + 1))
    fi
done

if [ $PERM_ERRORS -eq 0 ]; then
    success "Script permissions are correct"
fi

echo ""

# ============================================================================
# Summary
# ============================================================================
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if [ $ERRORS -gt 0 ]; then
    echo -e "${RED}❌ Validation FAILED${NC}"
    echo -e "${RED}   Found $ERRORS critical error(s)${NC}"
    echo ""
    echo "Fix the errors above before committing."
    exit 1
else
    echo -e "${GREEN}✅ All validation checks passed!${NC}"
    echo ""
    echo "Repository is ready to commit and push."
    exit 0
fi
