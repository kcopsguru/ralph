# Review Process

Manual review after automated checks pass.

## Get Changes

```bash
git diff --name-only main...HEAD  # Changed files
git diff main...HEAD              # Full diff
git status --porcelain            # Uncommitted changes (prompt to commit first)
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
| Automated Check Failure | `[FIX]` | Build errors, test failures, lint errors |
| Requirements Deviation | `[FIX]` | AC not met, missing functionality, wrong behavior |
| Coding Guideline Violation | `[QUALITY]` | Mutation, missing error handling, any types |
| Code Quality Issue | `[QUALITY]` | DRY violations, overengineering, dead code |

## Severity

| Severity | Priority | Description |
|----------|----------|-------------|
| Critical | 1-2 | Blocks functionality, fails checks, security issue |
| Major | 3+ | Significant quality issue, coding guideline violation |
| Minor | Last | Improvement opportunity, style preference |

Automated check failures are always Critical with highest priority.
