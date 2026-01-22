# Example Ralph Prompts

This directory contains example prompt templates for different Ralph loop use cases.

## How to Use These Prompts

1. **Choose a template** that matches your goal
2. **Copy it to your workspace:**
   ```bash
   cd ~/ralph-workspace
   cp example-prompts/01-simple-project.md PROMPT.md
   ```
3. **Edit PROMPT.md** to customize for your specific task
4. **Run the loop:**
   ```bash
   ./run-safe-loop.sh
   ```

## Available Templates

### 01-simple-project.md
**Use case:** Building a complete project from scratch

**Good for:**
- Creating new applications
- Building CLI tools
- Implementing complete features
- Learning new frameworks

**Example projects:**
- TODO list application
- Web scraper
- API client
- File organizer
- Data processor

**Characteristics:**
- Clear end goal
- Multiple components
- Incremental development
- Testing as you go

---

### 02-iterative-refinement.md
**Use case:** Improving and refining existing code

**Good for:**
- Code quality improvements
- Adding error handling
- Performance optimization
- Refactoring
- Adding tests

**Example tasks:**
- Polish a prototype
- Add error handling to script
- Improve code readability
- Optimize slow functions
- Add logging and monitoring

**Characteristics:**
- Start with working code
- Make one improvement per iteration
- Focus on quality over features
- Progressive enhancement

---

### 03-research-and-prototype.md
**Use case:** Exploring new ideas and technologies

**Good for:**
- Learning new frameworks
- Proof-of-concept development
- Technology evaluation
- Architecture exploration
- Rapid prototyping

**Example projects:**
- "How does GraphQL work?" → Build simple server
- "Should we use FastAPI or Flask?" → Try both
- "Can we integrate with X API?" → Build prototype
- "What's the best way to do Y?" → Research + implement

**Characteristics:**
- Research phase included
- Autonomous decision-making
- Documentation of choices
- Rapid iteration
- Learning-focused

---

## Creating Your Own Prompts

### Key Components of a Good Ralph Prompt

1. **Identity & Role**
   ```markdown
   You are Ralph, an autonomous coding agent.
   ```

2. **Clear Task Description**
   ```markdown
   ## Your Task
   Build a web scraper that extracts product prices from e-commerce sites.
   ```

3. **Context Awareness**
   ```markdown
   ## Current State
   Check /workspace for existing files. Continue from where you left off.
   ```

4. **Iteration Instructions**
   ```markdown
   ## Each Iteration
   1. Review what exists
   2. Make one incremental improvement
   3. Test your changes
   4. Document progress
   ```

5. **Output Format**
   ```markdown
   ## Report Format
   - What you did
   - What you tested
   - What's next
   ```

### Template Structure

```markdown
# Ralph Agent Prompt - [Purpose]

You are Ralph, [specific role/expertise].

## Your Task
[Clear description of end goal]

## Current State
[How to check existing progress]

## This Iteration's Goals
[What to do in each loop iteration]

## Guidelines
[Rules, constraints, best practices]

## Output Format
[How to report progress]

## Stop Condition
[When to consider task complete]
```

---

## Prompt Best Practices

### DO:
- ✓ Keep instructions concise
- ✓ Define clear tasks
- ✓ Include context checking
- ✓ Specify iteration behavior
- ✓ Request status updates
- ✓ Set quality standards
- ✓ Include testing instructions

### DON'T:
- ✗ Make prompts too long (wastes tokens = costs money)
- ✗ Be vague about the goal
- ✗ Forget to mention existing files
- ✗ Skip testing instructions
- ✗ Omit stop conditions
- ✗ Use unnecessary verbose language

---

## Cost-Optimized Prompts

For budget-conscious loops, use minimal prompts:

```markdown
# Ralph - TODO App

Build Python CLI TODO app with:
- Add/list/complete/delete tasks
- JSON storage

Work incrementally. Test each feature. Keep it simple.

Status: What you did + what's next.
```

**Why it works:**
- ~50 tokens vs 200+ tokens
- 75% cost reduction
- Still clear enough
- Focuses on essentials

---

## Prompt Variants

### Variant 1: Highly Autonomous
```markdown
You are Ralph. Build a [PROJECT]. Use your best judgment on:
- Technology choices
- Architecture
- Implementation approach

Document your decisions in DECISIONS.md.
```

**Pro:** Ralph makes all decisions
**Con:** Might choose approaches you don't want

---

### Variant 2: Highly Directed
```markdown
You are Ralph. Build [PROJECT] using:
- Python 3.11
- Flask framework
- SQLite database
- REST API structure

Follow these exact requirements:
1. [Requirement 1]
2. [Requirement 2]
...
```

**Pro:** Precise control over output
**Con:** Less flexibility, more tokens

---

### Variant 3: Balanced (Recommended)
```markdown
You are Ralph. Build [PROJECT].

Requirements:
- Use Python
- Include error handling
- Write tests

You decide:
- Specific frameworks
- File structure
- Implementation details

Document key decisions.
```

**Pro:** Good balance of control and autonomy
**Con:** None - this is the sweet spot

---

## Advanced Prompt Techniques

### State Tracking

```markdown
## State Management

Read STATE.json at start of each iteration:
{
  "completed": ["feature1", "feature2"],
  "current": "feature3",
  "next": ["feature4", "feature5"]
}

Update STATE.json at end of each iteration.
```

### Conditional Behavior

```markdown
## Conditional Actions

If tests pass:
  - Move to next feature

If tests fail:
  - Debug and fix
  - Don't proceed until passing

If all features complete:
  - Polish and document
  - Prepare for deployment
```

### Multi-Phase Prompts

```markdown
## Phases

Phase 1 (Iterations 1-3): Research and planning
Phase 2 (Iterations 4-8): Core implementation
Phase 3 (Iterations 9-10): Testing and polish

Check PHASE.txt to know current phase.
Update PHASE.txt when transitioning.
```

---

## Example Customizations

### From Template to Your Task

**Template:** `01-simple-project.md`

**Your task:** Build a weather CLI tool

**Customized prompt:**
```markdown
# Ralph Agent Prompt - Weather CLI Tool

You are Ralph, an autonomous coding agent.

## Your Task

Build a command-line weather application with:
1. Fetch weather from OpenWeather API
2. Display current conditions
3. 5-day forecast
4. Save favorite locations
5. Store API key in config file

## Current Progress

Check /workspace/weather-cli/ for existing files.

## This Iteration's Goals

1. If starting: Set up project structure and API integration
2. If continuing: Implement next unfinished feature
3. Test with real API calls
4. Update CHANGELOG.md

## Guidelines

- Use Python 3.11+
- Include error handling for API failures
- Cache results for 10 minutes
- Pretty-print output with colors
- Keep dependencies minimal

## Output Format

After each iteration:
1. What feature you implemented
2. How you tested it
3. Any issues encountered
4. Next feature to implement
```

---

## Troubleshooting Prompts

### Ralph Seems Lost?

**Problem:** Ralph doesn't know what to do next

**Solution:** Add clearer iteration instructions:
```markdown
## If Unsure What to Do Next

1. Check TODO.md for pending tasks
2. Pick the first incomplete task
3. If all complete, improve code quality
4. If code is great, add tests
5. If tests exist, improve documentation
```

### Ralph Repeating Same Actions?

**Problem:** Gets stuck in a loop

**Solution:** Add state tracking:
```markdown
## Avoid Repetition

1. Read HISTORY.md before starting
2. Log all actions to HISTORY.md
3. Don't repeat completed actions
4. Always make progress
```

### Ralph Making Too Many Changes?

**Problem:** Changes too much per iteration

**Solution:** Limit scope:
```markdown
## Iteration Limits

Each iteration: ONE feature OR ONE bugfix
Do not:
- Implement multiple features at once
- Make breaking changes
- Refactor while adding features
```

---

## Testing Your Prompts

Before running a full loop, test your prompt:

```bash
# Single iteration test
cat PROMPT.md | claude

# Review output
# Adjust prompt if needed
# Test again

# Once satisfied, run the loop
./run-safe-loop.sh
```

---

## Sharing Prompts

Got a great prompt? Share it!

Format:
```markdown
# Ralph Prompt - [Name]

**Use case:** [Brief description]
**Good for:** [Project types]
**Estimated iterations:** [Number]

[Full prompt content]
```

---

## Resources

- Ralph technique: https://ghuntley.com/ralph/
- Prompt engineering: https://docs.anthropic.com/en/docs/prompt-engineering
- Claude Code docs: https://docs.claude.com/claude-code

---

## Quick Reference

```bash
# Use a template
cp example-prompts/01-simple-project.md PROMPT.md

# Edit for your task
nano PROMPT.md

# Test single iteration
cat PROMPT.md | claude

# Run full loop
./run-safe-loop.sh

# Monitor progress
./monitor.sh
```

Happy prompting! 🎯
