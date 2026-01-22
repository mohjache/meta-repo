# Claude Code Workflow

## Commit & Push Standard Process

When asked to "commit and push" changes:

1. **Stage changes**: `git add .` (or specific files)

2. **Commit** with standard format:
   ```bash
   git commit -m "$(cat <<'EOF'
   <Title: what changed>

   <Why this change was made>

   Changes:
   - <bullet 1>
   - <bullet 2>

   🤖 Generated with [Claude Code](https://claude.com/claude-code)

   Co-Authored-By: Claude <noreply@anthropic.com>
   EOF
   )"
   ```

3. **If pre-commit hook fails**:
   - Fix the errors
   - Re-stage: `git add <files>`
   - Amend commit if safe (check authorship + not pushed), otherwise new commit
   - Retry until passes

4. **Push**: `git push`

5. **Report**: Confirm commit hash and push status

---

**Note**: Pre-commit hook automatically validates scripts, Docker configs, JSON/YAML, secrets, and permissions on every commit.
