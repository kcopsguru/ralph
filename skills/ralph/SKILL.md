---
name: ralph
description: "Execute the Ralph autonomous agent workflow to complete user stories from prd.json. Use when you want to run the Ralph loop to implement features. Triggers on: run ralph, execute ralph workflow, ralph loop, start ralph."
disable-model-invocation: true
---

# Ralph Agent Workflow

You are an autonomous coding agent working on a software project.

> **Important:** All file paths (`.ralph/prd.json`, `.ralph/progress.txt`, `.ralph/.last-branch`, `.ralph/archive/`) are relative to the current working directory. Run Ralph from your project root where `.ralph/prd.json` lives.

## Setup (Run First)

Before starting work, perform these setup steps:

### 1. Read PRD and Detect Branch Change
VERY IMPORTANT: Run `git status` to check for uncommitted changes. If uncommitted changes are found, ABORT THE WORKFLOW IMMEDIATELY WITH AN ERROR MESSAGE.

Read `.ralph/prd.json` and `.ralph/.last-branch` (if it exists). Compare the PRD's `branchName` with `.ralph/.last-branch`.

If they differ (or `.ralph/.last-branch` doesn't exist), this is a new feature run:
- Reset `.ralph/progress.txt` with a fresh header:
  ```
  # Ralph Progress Log
  Started: [current date/time]
  ---
  ```

> **Note:** Archiving of previous .ralph/prd.json and .ralph/progress.txt is handled by the prd-json skill when creating a new prd.json (archived to `.ralph/archive/`), not here. This step just resets for the new run.

### 2. Track Current Branch
Write the PRD's `branchName` to `.ralph/.last-branch`

### 3. Initialize Progress File
If `.ralph/progress.txt` doesn't exist (and wasn't just reset above), create it with the same fresh header.

### 4. Git Branch
Check you're on the correct branch from PRD `branchName`. If not, check it out or create from main.

### 5. Load Development Skills (REQUIRED)
Before implementing any code, you MUST load and read these skills:
- `/coding` - Clean code principles, coding standards, quality checklist
- `/tdd` - Test-driven development workflow, coverage requirements

These skills contain the development principles you MUST follow during implementation.

## Your Task

> **CRITICAL: Work on exactly ONE story per iteration. After completing and committing one story, STOP. Do not start the next story. End your response so the next iteration can begin fresh.**

1. Read the PRD at `.ralph/prd.json`
2. Read the original PRD located in the `reference` field
3. Read the progress log at `.ralph/progress.txt` (check Codebase Patterns section first)
4. Pick the **highest priority** user story where `passes: false`
5. Review that single user story and all of its requirements
6. Implement the user story by following TDD (Red-Green-Refactor) and the principles from `/coding` and `/tdd` skills
7. Run all quality checks (e.g., typecheck, lint, test - use whatever your project requires)
8. Do a self-review on all the changes, refactor the code if necessary, keep all checks pass
9. If checks pass, commit changes for this story with message: `feat: [Story ID] - [Story Title]`
10. Update the PRD to set `passes: true` for the completed story
11. Append your progress to `.ralph/progress.txt`
12. **Check completion and STOP:**
    - If ALL stories now have `passes: true`: Reply with `<promise>COMPLETE</promise>` and end your response
    - If stories remain with `passes: false`: End your response now (do NOT start another story - next iteration will continue)

Note: `.ralph/prd.json`, `.ralph/progress.txt` are ralph state files - do not commit them.

## Progress Report Format

APPEND to .ralph/progress.txt (never replace, always append):
```
## [Date/Time] - [Story ID]
Thread: https://ampcode.com/threads/$AMP_CURRENT_THREAD_ID
- What was implemented
- Files changed
- **Learnings for future iterations:**
  - Patterns discovered (e.g., "this codebase uses X for Y")
  - Gotchas encountered (e.g., "don't forget to update Z when changing W")
  - Useful context (e.g., "the evaluation panel is in component X")
---
```

Include the thread URL so future iterations can use the `read_thread` tool to reference previous work if needed.

The learnings section is critical - it helps future iterations avoid repeating mistakes and understand the codebase better.

## Consolidate Patterns

If you discover a **reusable pattern** that future iterations should know, add it to the `## Codebase Patterns` section at the TOP of .ralph/progress.txt (create it if it doesn't exist). This section should consolidate the most important learnings:

```
## Codebase Patterns
- Example: Use `sql<number>` template for aggregations
- Example: Always use `IF NOT EXISTS` for migrations
- Example: Export types from actions.ts for UI components
```

Only add patterns that are **general and reusable**, not story-specific details.

## Quality Requirements

- ALL commits must pass your project's quality checks (typecheck, lint, test)
- Write new quality checks before the actual implemetation when applicable (i.e. adding a new feature)
- Do NOT commit broken code
- Keep changes focused and minimal
- Follow existing code patterns

## Browser Testing (Required for Frontend Stories)

For any story that changes UI, you MUST verify it works in the browser:

1. Load the `/agent-browser` skill
2. Navigate to the relevant page
3. Verify the UI changes work as expected
4. Take a screenshot if helpful for the progress log

A frontend story is NOT complete until browser verification passes.

## Stop Condition (See Step 12)

This is handled in Step 12 of Your Task. After completing a story:
- ALL stories `passes: true` → Reply with `<promise>COMPLETE</promise>`
- Stories remain with `passes: false` → End response (next iteration continues)

## Reminders

- Read the Codebase Patterns section in `.ralph/progress.txt` before starting
- MUST load `/coding` and `/tdd` skills before implementing (Setup Step 5)
- Run quality checks for validation
- Keep CI green
- **Output `<promise>COMPLETE</promise>` when ALL stories pass** (Step 12)
