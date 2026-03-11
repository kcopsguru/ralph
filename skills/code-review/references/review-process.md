# Review Process

Manual review of code changes against PRD requirements.

## Get Changes

First, read `.ralph/prd.json` to get the `startingPoint` field. This is the commit/branch the feature branch was created from. Use this instead of hardcoding `main`.

```bash
# Get starting point from prd.json (default to 'main' if not set)
START=$(jq -r '.startingPoint // "main"' .ralph/prd.json)

git diff --name-only $START...HEAD  # Changed files
git diff $START...HEAD              # Full diff
git status --porcelain              # Uncommitted changes (prompt to commit first)
```

## File Review Checklist

For each changed file, check in this order:

### 1. Security Issues (Critical)

- Hardcoded credentials, API keys, tokens
- SQL injection vulnerabilities
- XSS vulnerabilities
- Insecure dependencies
- Path traversal risks

### 2. Coding Guideline Violations (Major/Minor)

Check against the development principles in the `/coding` and `/tdd` skill. Apply relevant language/framework guidelines based on files changed.

### 3. Review-Specific Issues (Minor)

- console.log statements
- TODO/FIXME comments
- Missing tests for new code
- Accessibility issues (a11y)

## Issue Categories

| Category | Prefix | Examples |
|----------|--------|----------|
| Requirements Deviation | `[FIX]` | AC not met, missing functionality, wrong behavior |
| Coding Guideline Violation | `[QUALITY]` | Mutation, missing error handling, any types |
| Code Quality Issue | `[QUALITY]` | DRY violations, overengineering, dead code |

## Severity

| Severity | Priority | Description |
|----------|----------|-------------|
| Critical | 1-2 | Blocks functionality, security issue |
| Major | 3+ | Significant quality issue, coding guideline violation |
| Minor | Last | Improvement opportunity, style preference |
