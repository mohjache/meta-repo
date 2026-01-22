# Ralph Loops - GitHub Codespaces

Run Claude Code in autonomous loops with **zero setup** - everything configured in code, ready to commit and share.

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new)

---

## 🚀 Quick Start (30 Seconds)

### 1. Open in Codespaces

1. Go to this repository on GitHub
2. Click **Code** → **Codespaces** → **Create codespace on main**
3. Wait 1-2 minutes for the environment to build

### 2. Configure API Key

```bash
./scripts/setup-api-key.sh
```

Or use the Makefile:
```bash
make setup
```

### 3. Run Ralph

```bash
cd ~/ralph-workspace
nano PROMPT.md  # Edit your task
../scripts/run-safe-loop.sh
```

Or simply:
```bash
make run
```

**Done!** Ralph is now running in an isolated cloud environment. ☁️

---

## 🤔 What is Ralph?

Ralph is a technique where Claude Code runs in a continuous loop, autonomously working on coding tasks:

```bash
while :; do
  cat PROMPT.md | claude
  sleep 5
done
```

Each iteration, Claude:
1. Reads your prompt
2. Checks existing files
3. Makes incremental progress
4. Updates code
5. Reports status

Over many iterations, complex projects get built autonomously.

**Origin:** [ghuntley.com/ralph](https://ghuntley.com/ralph/)

---

## 📁 Repository Structure

```
ralph-cloud-setup/
├── .devcontainer/             ← Codespaces configuration
│   ├── devcontainer.json      ← Main config
│   ├── Dockerfile             ← Dev environment
│   └── post-create.sh         ← Auto-setup script
│
├── scripts/                   ← Helper scripts
│   ├── setup-api-key.sh       ← Configure Claude API
│   ├── run-safe-loop.sh       ← Run Ralph safely
│   ├── monitor.sh             ← Monitor resources
│   └── cleanup.sh             ← Stop and cleanup
│
├── prompts/                   ← Example prompts
│   └── PROMPT.md              ← Default template
│
├── example-prompts/           ← More examples
│   ├── 01-simple-project.md
│   ├── 02-iterative-refinement.md
│   └── 03-research-and-prototype.md
│
├── Dockerfile.ralph           ← Ralph runner container
├── docker-compose.yml         ← Multi-container setup
├── Makefile                   ← Simple commands
├── .env.example               ← Environment template
├── .gitignore                 ← Git ignore rules
├── README.md                  ← This file
└── CODESPACES.md              ← Detailed guide
```

---

## 🔧 Common Commands

### Using Make (Recommended)

```bash
make help      # Show all available commands
make setup     # Configure API key
make build     # Build Docker image
make run       # Run Ralph loop
make monitor   # Monitor resources
make stop      # Stop current loop
make cleanup   # Full cleanup
make test      # Test Claude CLI
```

### Using Scripts Directly

```bash
# Setup API key
./scripts/setup-api-key.sh

# Run Ralph loop (default: 30 min timeout)
./scripts/run-safe-loop.sh

# Custom duration and resources
MAX_DURATION=1h CPU_LIMIT=1.5 MEM_LIMIT=4g ./scripts/run-safe-loop.sh

# Slower iterations (lower API costs)
SLEEP_BETWEEN=30 ./scripts/run-safe-loop.sh

# Monitor resources
./scripts/monitor.sh

# Stop and cleanup
./scripts/cleanup.sh
```

### Monitoring

```bash
# Watch logs in real-time
docker logs -f ralph-loop

# Check resource usage
docker stats ralph-loop

# Full status check
make monitor
```

---

## 🛡️ Safety Features

All scripts include built-in safety controls:

- ⏱️ **Timeout controls** (default: 30 minutes)
- 🔒 **Resource limits** (CPU: 0.8 cores, RAM: 2GB)
- ⏸️ **Rate limiting** (5-second delays between iterations)
- 📊 **Monitoring tools** (resource usage, logs)
- 🚨 **Emergency stop** (cleanup script)

Customize in your command:
```bash
MAX_DURATION=1h CPU_LIMIT=1.5 MEM_LIMIT=4g SLEEP_BETWEEN=10 make run
```

---

## 💰 Cost Breakdown

### GitHub Codespaces

| Tier | Included Free | Cost After Free Tier |
|------|---------------|---------------------|
| **Personal** | 120 core-hours/month | $0.18/hour (2-core) |
| | 15 GB storage | $0.36/hour (4-core) |
| **Example** | ~60 hours/month | $0.07/GB/month storage |

**Auto-sleep after 30 minutes of inactivity saves money!**

**To stop manually:** Codespaces menu → Stop Codespace

### Claude API

| Usage Pattern | Approximate Cost |
|---------------|------------------|
| **Light** (2-4 hours/week) | $2-5/month |
| **Moderate** (1 hour/day) | $5-10/month |
| **Heavy** (continuous) | ~$7-36/hour |

**Recommended:** Set a budget limit at https://console.anthropic.com/settings/limits

---

## 🎓 Example Use Cases

### 1. Build a Web Application

```markdown
Task: Create a Flask web app with:
- User authentication (login/logout)
- SQLite database integration
- RESTful API endpoints for CRUD operations
- Error handling and logging
- Basic HTML templates
- Unit tests

Test everything and document the API endpoints.
```

### 2. Refactor Existing Code

```markdown
Task: Review the Python codebase in /workspace/src and:
- Add type hints to all functions
- Write docstrings following Google style
- Extract duplicate code into reusable functions
- Add error handling where missing
- Write unit tests for main functions
- Create a test coverage report
```

### 3. Research and Prototype

```markdown
Task: Research image processing libraries for Python:
1. Compare PIL, OpenCV, and scikit-image
2. Create a comparison table with pros/cons
3. Build a prototype that demonstrates:
   - Loading and displaying images
   - Edge detection
   - Simple object recognition
4. Document which library is best for what use case
```

### 4. Data Analysis Pipeline

```markdown
Task: Create a data analysis pipeline that:
- Loads CSV data from /workspace/data/
- Cleans and validates the data
- Performs exploratory data analysis
- Creates visualizations (charts/graphs)
- Generates a summary report
- Exports results to JSON and PDF
```

See `example-prompts/` directory for more templates!

---

## 🔐 Security & API Keys

### Option 1: Local .env File (Quick)

```bash
# Run setup script
./scripts/setup-api-key.sh

# Or manually
cp .env.example .env
nano .env  # Add your key
export $(grep -v '^#' .env | xargs)
```

### Option 2: GitHub Codespaces Secrets (Recommended for Teams)

1. Go to GitHub → Settings → Codespaces → Secrets
2. Click **New secret**
3. Name: `ANTHROPIC_API_KEY`
4. Value: Your API key
5. Click **Add secret**

Now all your Codespaces will automatically have the API key loaded!

**Important:**
- `.env` is gitignored (never committed)
- Set spending limits at https://console.anthropic.com/settings/limits
- Get your API key at https://console.anthropic.com/settings/keys

---

## 🎯 Advanced Usage

### Multiple Concurrent Loops

Run different tasks in parallel:

```bash
# Terminal 1: Frontend work
cd ~/ralph-workspace/frontend
cat > PROMPT.md << EOF
Build a React component for user authentication with form validation
EOF
make run

# Terminal 2: Backend work
cd ~/ralph-workspace/backend
cat > PROMPT.md << EOF
Create FastAPI endpoints for user management with JWT auth
EOF
make run
```

### Using Docker Compose

For complex multi-container setups, edit `docker-compose.yml`:

```bash
# Start all services
docker-compose up

# Run in background
docker-compose up -d

# View logs
docker-compose logs -f

# Stop all
docker-compose down
```

### Persistent State Tracking

Create a state file for Ralph to track progress:

```bash
cat > ~/ralph-workspace/STATE.json << EOF
{
  "iteration": 0,
  "completed_tasks": [],
  "pending_tasks": [],
  "last_run": ""
}
EOF
```

Then reference it in your PROMPT.md:
```markdown
## State Tracking
Read STATE.json to see previous progress.
Update STATE.json at the end of each iteration.
```

### GitHub Integration

Auto-commit Ralph's work:

```bash
cd ~/ralph-workspace
git init
git remote add origin https://github.com/YOUR_USERNAME/ralph-output.git

# Create auto-commit script
cat > auto-commit.sh << 'EOF'
#!/bin/bash
while true; do
  git add -A
  if ! git diff --cached --quiet; then
    git commit -m "Ralph auto-commit $(date)"
    git push -u origin main
  fi
  sleep 300  # Every 5 minutes
done
EOF

chmod +x auto-commit.sh
./auto-commit.sh &
```

---

## 🛠️ Troubleshooting

### Codespace Won't Start

**Problem:** Codespace creation fails

**Solutions:**
1. Check GitHub Codespaces quota: Settings → Billing
2. Delete old unused Codespaces
3. Try rebuilding: Codespaces menu → Rebuild Container

### Claude CLI Not Found

**Problem:** `claude: command not found`

**Solutions:**
```bash
# Reinstall
npm install -g @anthropic-ai/claude-code

# Verify
claude --version

# Or rebuild container
# Codespaces menu → Rebuild Container
```

### Docker Permission Denied

**Problem:** `permission denied while trying to connect to Docker daemon`

**Solutions:**
```bash
# Usually auto-fixed, but if needed:
sudo usermod -aG docker $USER

# Then restart Codespace
# Codespaces menu → Restart Codespace
```

### API Key Not Working

**Problem:** `Error: ANTHROPIC_API_KEY not set`

**Solutions:**
```bash
# Check if .env exists
cat .env

# Re-run setup
make setup

# Or manually set
export ANTHROPIC_API_KEY="sk-ant-your-key-here"

# Verify
echo $ANTHROPIC_API_KEY
```

### Container Won't Stop

**Problem:** Ralph loop keeps running

**Solutions:**
```bash
# Force stop
docker stop ralph-loop

# Force kill
docker kill ralph-loop

# Nuclear option
make cleanup
```

### Out of Disk Space

**Problem:** "No space left on device"

**Solutions:**
```bash
# Clean Docker
docker system prune -a --volumes -f

# Check usage
df -h
du -sh ~/ralph-workspace/*

# Remove large files
rm -rf ~/ralph-workspace/node_modules
rm -rf ~/ralph-workspace/__pycache__
```

### High API Costs

**Problem:** Spending too much on Claude API

**Solutions:**
```bash
# Increase sleep between iterations
SLEEP_BETWEEN=30 make run  # 30 seconds instead of 5

# Reduce max duration
MAX_DURATION=15m make run  # 15 minutes instead of 30

# Use shorter, more focused prompts
# Set budget limits in Anthropic Console
```

---

## 📖 Best Practices

### 1. Start Small

✅ **Good:**
```markdown
Task: Add input validation to the login form
```

❌ **Bad:**
```markdown
Task: Build a complete social media platform
```

### 2. Be Specific

✅ **Good:**
```markdown
Task: Create a Python function that validates email addresses
using regex, handles edge cases, and returns True/False with
an error message. Include unit tests.
```

❌ **Bad:**
```markdown
Task: Make the code better
```

### 3. Use Iterations

Structure prompts to work incrementally:
```markdown
Iteration 1: Create basic structure
Iteration 2: Add core functionality
Iteration 3: Add error handling
Iteration 4: Add tests
Iteration 5: Add documentation
```

### 4. Monitor Costs

```bash
# Check iteration count
docker logs ralph-loop | grep "Iteration" | wc -l

# Calculate: iterations × $0.01-0.05 = approximate cost
```

### 5. Save Work Regularly

```bash
# Work is in ~/ralph-workspace
cd ~/ralph-workspace

# Initialize git if needed
git init
git add -A
git commit -m "Ralph progress checkpoint"

# Push to backup
git remote add origin YOUR_REPO_URL
git push -u origin main
```

### 6. Stop When Inactive

- Codespaces auto-sleep after 30 minutes (saves money)
- Manually stop: **Codespaces menu** → **Stop Codespace**
- Delete old Codespaces you're not using

---

## 🤝 Team Collaboration

### Sharing With Your Team

1. **Push this repo to GitHub**
   ```bash
   git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO.git
   git push -u origin main
   ```

2. **Team members can:**
   - Clone the repo
   - Click "Open in Codespaces"
   - Run `make setup`
   - Start coding in 30 seconds!

### Setting Up Team Secrets

**Organization level:**
1. GitHub Org → Settings → Codespaces → Secrets
2. Add `ANTHROPIC_API_KEY`
3. All team Codespaces get the key automatically

### Live Collaboration

Share your running Codespace:
1. Codespaces menu → Share
2. Copy and share the URL
3. Collaborate in real-time!

---

## 📚 Additional Documentation

- **CODESPACES.md** - Comprehensive Codespaces guide
- **example-prompts/** - Example prompt templates
- **Makefile** - All available commands

---

## 🆘 Support & Resources

- **Ralph Technique:** https://ghuntley.com/ralph/
- **Claude Code:** https://docs.claude.com/claude-code
- **GitHub Codespaces:** https://docs.github.com/codespaces
- **Anthropic Console:** https://console.anthropic.com

---

## 📜 License

This setup is provided as-is for educational and development purposes.

**Services used:**
- GitHub Codespaces: [Terms](https://docs.github.com/site-policy/github-terms)
- Claude API: [Anthropic Terms](https://www.anthropic.com/legal)

---

## 🎊 Get Started Now!

1. **Push to GitHub:**
   ```bash
   git add .
   git commit -m "Initial commit - Ralph Loops setup"
   git push
   ```

2. **Open in Codespaces:**
   - Click **Code** → **Codespaces** → **Create codespace**

3. **Start building:**
   ```bash
   make setup
   make run
   ```

**Happy Ralph Looping!** 🚀

---

<p align="center">
  <i>Everything you need is in code. No manual setup. Ever.</i>
</p>
