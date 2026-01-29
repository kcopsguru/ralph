# Ralph Agent Instructions

## Overview

Ralph is an autonomous AI agent loop that runs Amp repeatedly until all PRD items are complete. Each iteration is a fresh Amp instance with clean context.

## Commands

```bash
# Run the flowchart dev server
cd flowchart && npm run dev

# Build the flowchart
cd flowchart && npm run build

# Run Ralph (from your project that has .ralph/prd.json)
./ralph.sh [OPTIONS]
#   --prompt <file>         Path to prompt file (default: prompt.md in script directory)
#   --max-iterations <n>    Maximum iterations (default: 10)
#   --tool <tool>           CLI tool to use: amp or cursor (default: amp)
#   -h, --help              Show help

# Run Ralph with Cursor CLI instead of amp
./ralph.sh --tool cursor
```

## Key Files

- `ralph.sh` - The bash loop that spawns fresh Amp instances
- `prompt.md` - Instructions given to each Amp instance
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
