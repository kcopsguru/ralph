# Ralph

![Ralph](ralph.webp)

Ralph is an autonomous AI agent loop that runs [Amp](https://ampcode.com) repeatedly until all PRD items are complete. Each iteration is a fresh Amp instance with clean context. Memory persists via git history, `.ralph/progress.txt`, and `.ralph/prd.json`.

Based on [Geoffrey Huntley's Ralph pattern](https://ghuntley.com/ralph/).

[Read my in-depth article on how I use Ralph](https://x.com/ryancarson/status/2008548371712135632)

## Prerequisites

- [Amp CLI](https://ampcode.com) installed and authenticated, OR [Cursor CLI](https://www.cursor.com/cli) (`agent` command)
- `jq` installed (`brew install jq` on macOS)
- A git repository for your project

## Setup

### Option 1: Copy to your project

Copy the ralph files into your project:

```bash
# From your project root
mkdir -p scripts/ralph
cp /path/to/ralph/ralph.sh scripts/ralph/
cp /path/to/ralph/prompt.md scripts/ralph/
chmod +x scripts/ralph/ralph.sh
```

### Option 2: Install skills globally

Copy the skills to your Amp config for use across all projects:

```bash
cp -r skills/prd ~/.config/amp/skills/
cp -r skills/ralph ~/.config/amp/skills/
```

### Add Ralph files to .gitignore

Add `.ralph/` to your `.gitignore` (this covers `prd.json`, `progress.txt`, `.last-branch`, and `archive/`).

### Configure Amp auto-handoff (recommended)

Add to `~/.config/amp/settings.json`:

```json
{
  "amp.experimental.autoHandoff": { "context": 90 }
}
```

This enables automatic handoff when context fills up, allowing Ralph to handle large stories that exceed a single context window.

## Workflow

### 1. Create a PRD

Use the PRD skill to generate a detailed requirements document:

```
Load the prd skill and create a PRD for [your feature description]
```

Answer the clarifying questions. The skill saves output to `tasks/prd-[feature-name].md`.

### 2. Convert PRD to Ralph format

Use the Ralph skill to convert the markdown PRD to JSON:

```
Load the ralph skill and convert tasks/prd-[feature-name].md to prd.json
```

This creates `.ralph/prd.json` with user stories structured for autonomous execution.

### 3. Run Ralph

```bash
./scripts/ralph/ralph.sh [OPTIONS]
```

**CLI Flags:**

| Flag | Description | Default |
|------|-------------|---------|
| `--prompt <file>` | Path to prompt file | `prompt.md` in script directory |
| `--max-iterations <n>` | Maximum iterations to run | `10` |
| `--tool <tool>` | CLI tool to use: `amp` or `cursor` | `amp` |
| `-h`, `--help` | Show help message | - |

**Examples:**

```bash
# Run with defaults (amp tool, prompt.md, 10 iterations)
./scripts/ralph/ralph.sh

# Use Cursor CLI instead of amp
./scripts/ralph/ralph.sh --tool cursor

# Run with custom iteration limit
./scripts/ralph/ralph.sh --max-iterations 5

# Use a custom prompt file
./scripts/ralph/ralph.sh --prompt custom-prompt.md

# Combine flags (order doesn't matter)
./scripts/ralph/ralph.sh --tool cursor --prompt /path/to/prompt.md --max-iterations 20
```

Ralph will:
1. Create a feature branch (from PRD `branchName`)
2. Ensure `.ralph/` is gitignored
3. Pick the highest priority story where `passes: false`
4. Implement that single story
5. Run quality checks (typecheck, tests)
6. Commit if checks pass
7. Update `.ralph/prd.json` to mark story as `passes: true` (not committed - gitignored)
8. Append learnings to `.ralph/progress.txt` (not committed - gitignored)
9. Repeat until all stories pass or max iterations reached

### 4. Review Code (Optional)

After Ralph completes all stories, use the code review skill to validate the implementation:

```
Load the ralph-code-review skill and review the code
```

This skill:
1. Runs automated checks (typecheck, lint, build, test)
2. Reviews code changes against PRD requirements
3. Identifies requirements deviations and code quality issues
4. Adds fix stories to `.ralph/prd.json` for any issues found

If issues are found, run Ralph again to fix them, then review again. Repeat until no issues remain.

## Key Files

| File | Purpose |
|------|---------|
| `ralph.sh` | The bash loop that spawns fresh Amp instances |
| `prompt.md` | Instructions given to each Amp instance |
| `.ralph/prd.json` | User stories with `passes` status (the task list) |
| `.ralph/progress.txt` | Append-only learnings for future iterations |
| `.ralph/.last-branch` | Tracks current feature branch |
| `.ralph/archive/` | Archives of completed feature runs |
| `prd.json.example` | Example PRD format for reference |
| `skills/prd/` | Skill for generating PRDs |
| `skills/ralph/` | Skill for converting PRDs to JSON |
| `skills/ralph-code-review/` | Skill for reviewing code against PRD requirements |
| `flowchart/` | Interactive visualization of how Ralph works |

## Flowchart

[![Ralph Flowchart](ralph-flowchart.png)](https://snarktank.github.io/ralph/)

**[View Interactive Flowchart](https://snarktank.github.io/ralph/)** - Click through to see each step with animations.

The `flowchart/` directory contains the source code. To run locally:

```bash
cd flowchart
npm install
npm run dev
```

## Critical Concepts

### Each Iteration = Fresh Context

Each iteration spawns a **new Amp instance** with clean context. The only memory between iterations is:
- Git history (commits from previous iterations)
- `.ralph/progress.txt` (learnings and context)
- `.ralph/prd.json` (which stories are done)

### Small Tasks

Each PRD item should be small enough to complete in one context window. If a task is too big, the LLM runs out of context before finishing and produces poor code.

Right-sized stories:
- Add a database column and migration
- Add a UI component to an existing page
- Update a server action with new logic
- Add a filter dropdown to a list

Too big (split these):
- "Build the entire dashboard"
- "Add authentication"
- "Refactor the API"

### AGENTS.md Updates Are Critical

After each iteration, Ralph updates the relevant `AGENTS.md` files with learnings. This is key because Amp automatically reads these files, so future iterations (and future human developers) benefit from discovered patterns, gotchas, and conventions.

Examples of what to add to AGENTS.md:
- Patterns discovered ("this codebase uses X for Y")
- Gotchas ("do not forget to update Z when changing W")
- Useful context ("the settings panel is in component X")

### Feedback Loops

Ralph only works if there are feedback loops:
- Typecheck catches type errors
- Tests verify behavior
- CI must stay green (broken code compounds across iterations)

### Browser Verification for UI Stories

Frontend stories must include "Verify in browser using dev-browser skill" in acceptance criteria. Ralph will use the dev-browser skill to navigate to the page, interact with the UI, and confirm changes work.

### Stop Condition

When all stories have `passes: true`, Ralph outputs `<promise>COMPLETE</promise>` and the loop exits.

## Debugging

Check current state:

```bash
# See which stories are done
cat .ralph/prd.json | jq '.userStories[] | {id, title, passes}'

# See learnings from previous iterations
cat .ralph/progress.txt

# Check git history
git log --oneline -10
```

## Customizing prompt.md

Edit `prompt.md` to customize Ralph's behavior for your project:
- Add project-specific quality check commands
- Include codebase conventions
- Add common gotchas for your stack

## Archiving

Ralph automatically archives previous runs when you start a new feature (different `branchName`). Archives are saved to `.ralph/archive/YYYY-MM-DD-feature-name/`.

## References

- [Geoffrey Huntley's Ralph article](https://ghuntley.com/ralph/)
- [Amp documentation](https://ampcode.com/manual)
