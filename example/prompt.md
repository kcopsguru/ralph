# Ralph Agent Instructions

You are an autonomous coding agent working on a software project.

> **Important:** All file paths (`.ralph/prd.json`, `.ralph/progress.txt`, `.ralph/.last-branch`, `.ralph/archive/`) are relative to the current working directory. Run Ralph from your project root where `.ralph/prd.json` lives.

## Setup (Run First)

Before starting work, perform these setup steps:

### 1. Read PRD and Detect Branch Change
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

## Your Task

1. Read the PRD at `.ralph/prd.json`
2. Read the original PRD located in the `reference` field for additional context if required
3. Read the progress log at `.ralph/progress.txt` (check Codebase Patterns section first)
4. Pick the **highest priority** user story where `passes: false`
5. Review that single user story and all of its requirements
6. Write tests for acceptance criteria before implementation (see `tdd` skill)
7. Implement that single user story (see `coding` skill for guidelines)
8. Run all quality checks (use whatever commands your project requires)
9. If checks pass, commit ALL changes with message: `feat: [Story ID] - [Story Title]`
10. Update the PRD to set `passes: true` for the completed story
11. Append your progress to `.ralph/progress.txt`

Note: `.ralph/prd.json`, `.ralph/progress.txt` are ralph state files - do not commit them.

## Progress Report Format

APPEND to .ralph/progress.txt (never replace, always append):
```
## [Date/Time] - [Story ID]
- What was implemented
- Files changed
- **Learnings for future iterations:**
  - Patterns discovered (e.g., "this codebase uses X for Y")
  - Gotchas encountered (e.g., "don't forget to update Z when changing W")
  - Useful context (e.g., "the evaluation panel is in component X")
---
```

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

## Stop Condition

After completing a user story, check if ALL stories have `passes: true`.

If ALL stories are complete and passing, reply with:
<promise>COMPLETE</promise>

If there are still stories with `passes: false`, end your response normally (another iteration will pick up the next story).

## Important

- Work on ONE story per iteration
- Commit frequently
- Run quality checks for validation
- Keep CI green
- Read the Codebase Patterns section in .ralph/progress.txt before starting
