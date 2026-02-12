# Ralph Agent Instructions

## Overview

Ralph is an autonomous AI agent loop that runs Amp repeatedly until all PRD items are complete. Each iteration is a fresh Amp instance with clean context.

## Commands

**Using the /ralph skill (recommended for single iterations):**

Within an Amp or Cursor chat session:
```
Use the /ralph skill to execute the ralph workflow exactly once
```

**Using ralph.sh (automated multi-iteration loop):**

```bash
# Run Ralph (from your project that has .ralph/prd.json)
./ralph.sh [OPTIONS]
#   --prompt <file>         Path to prompt file (optional, uses /ralph skill by default)
#   --max-iterations <n>    Maximum iterations (default: 10)
#   --tool <tool>           CLI tool to use: amp or cursor (default: amp)
#   -h, --help              Show help

# Run Ralph with Cursor CLI instead of amp
./ralph.sh --tool cursor
```

**Flowchart dev commands:**

```bash
# Run the flowchart dev server
cd flowchart && npm run dev

# Build the flowchart
cd flowchart && npm run build
```

## Key Files

- `ralph.sh` - The bash loop that spawns fresh Amp instances
- `prompt.md` - Instructions given to each Amp instance (legacy - use `/ralph` skill instead)
- `skills/ralph/SKILL.md` - The `/ralph` skill for executing the workflow within AI chat
- `prd.json.example` - Example PRD format
- `flowchart/` - Interactive React Flow diagram explaining how Ralph works

## Flowchart

The `flowchart/` directory contains an interactive visualization built with React Flow. It's designed for presentations - click through to reveal each step with animations.

To run locally:
```bash
cd flowchart
npm install
npm run dev
```

## Patterns

- Each iteration spawns a fresh Amp instance with clean context
- Memory persists via git history, `.ralph/progress.txt`, and `.ralph/prd.json`
- Stories should be small enough to complete in one context window
- Always update AGENTS.md with discovered patterns for future iterations

## Code Review Step

After Ralph completes all stories, run `/code-review` to validate the implementation:

1. **Manual review** - Reviews `git diff main...HEAD` against PRD requirements.
2. **Issue identification** - Categorizes as: Requirements Deviations or Code Quality Issues.
3. **Interactive confirmation** - User confirms, modifies, or dismisses each issue.
4. **Fix stories added** - Confirmed issues become new stories in `.ralph/prd.json` with `[FIX]` or `[QUALITY]` prefixes.

The review cycle repeats until no issues are found:
- Run `/code-review`
- If issues found → Run Ralph to fix → Review again
- If no issues → Feature is ready to merge
