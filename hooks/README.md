# Git Hooks

This directory contains git hooks for validating repository changes before committing.

## Quick Start

Install the hooks with one command:

```bash
make install-hooks
```

Or manually:

```bash
./scripts/install-hooks.sh
```

## What Gets Validated

The pre-commit hook automatically runs these checks:

### 1. Secrets Detection
- ✅ Prevents committing `.env` files with real API keys
- ✅ Scans for Anthropic API keys in code
- ✅ Blocks commits containing secrets

### 2. Shell Script Validation
- ✅ Syntax checking (bash -n)
- ✅ ShellCheck linting (if available)
- ✅ Best practices enforcement

### 3. Docker Configuration
- ✅ Dockerfile syntax validation
- ✅ Hadolint linting (if available)
- ✅ docker-compose.yml validation

### 4. Configuration Files
- ✅ JSON validation (devcontainer.json)
- ✅ YAML validation (workflows, docker-compose)
- ✅ Syntax error detection

### 5. File Permissions
- ✅ Ensures scripts are executable
- ✅ Detects permission issues

## Running Manually

Test without committing:

```bash
make validate
```

Or:

```bash
./scripts/validate.sh
```

## Bypassing the Hook

**Not recommended**, but if you need to bypass validation:

```bash
git commit --no-verify
```

## Enhanced Validation (Optional)

For the best experience, install these tools in your environment:

### On Ubuntu/Debian (Codespaces)

```bash
# Install all recommended tools
sudo apt update
sudo apt install -y shellcheck jq yamllint python3-yaml

# Install hadolint
wget -O /tmp/hadolint https://github.com/hadolint/hadolint/releases/latest/download/hadolint-Linux-x86_64
sudo mv /tmp/hadolint /usr/local/bin/hadolint
sudo chmod +x /usr/local/bin/hadolint
```

### On macOS

```bash
brew install shellcheck jq yamllint hadolint
```

### On Windows (WSL)

```bash
sudo apt update
sudo apt install -y shellcheck jq yamllint python3-yaml
```

## What Happens Without Optional Tools?

The hook is designed to work even without optional linting tools:

- **Missing shellcheck**: Basic bash syntax checking only
- **Missing hadolint**: Basic Dockerfile syntax checking only
- **Missing jq/python3**: JSON/YAML validation skipped with warning
- **Missing yamllint**: YAML validation skipped with warning

The hook will **pass** if critical syntax is valid, but **warnings** will remind you to install tools for better validation.

## Hook Behavior

### ✅ Passes (Allows Commit)
- All syntax is valid
- No secrets detected
- Permissions are correct
- Or: Validators unavailable (shows warnings)

### ❌ Fails (Blocks Commit)
- Syntax errors in scripts
- Invalid Docker/JSON/YAML (if validators available)
- Secrets detected in code
- Missing executable permissions

## Uninstalling

Remove the hooks:

```bash
rm .git/hooks/pre-commit
```

## Troubleshooting

### Hook not running?

Check if it's installed:
```bash
ls -la .git/hooks/pre-commit
```

Reinstall:
```bash
make install-hooks
```

### False positives?

Edit the hook directly:
```bash
nano .git/hooks/pre-commit
```

Or update the source and reinstall:
```bash
nano hooks/pre-commit
make install-hooks
```

### Hook fails on valid code?

1. Check the specific error message
2. Run manually: `make validate`
3. Install recommended tools for accurate checking
4. Report issues if the hook is wrong

## Files

- `pre-commit` - The actual hook script (source)
- `README.md` - This documentation

The actual active hook is at `.git/hooks/pre-commit` (symlink or copy).

## Development

To modify the hook:

1. Edit `hooks/pre-commit`
2. Test: `./hooks/pre-commit`
3. Reinstall: `make install-hooks`
4. Test commit: Make a change and try committing

## CI/CD Integration

This validation also works great in GitHub Actions:

```yaml
- name: Run pre-commit validation
  run: make validate
```

See `.github/workflows/` for examples.
