# Review Process

Manual review after automated checks pass.

## Get Changes

```bash
git diff --name-only main...HEAD  # Changed files
git diff main...HEAD              # Full diff
git status --porcelain            # Uncommitted changes (prompt to commit first)
```

## File Review Checklist

For each changed file, check for:

### Security Issues (Critical)

- Hardcoded credentials, API keys, tokens
- SQL injection vulnerabilities
- XSS vulnerabilities
- Missing input validation
- Insecure dependencies
- Path traversal risks

### Code Quality (Major)

- Functions > 50 lines
- Files > 800 lines
- Nesting depth > 4 levels
- Missing error handling
- console.log statements
- TODO/FIXME comments
- Missing JSDoc for public APIs

### Best Practices (Minor)

- Mutation patterns (use immutable instead)
- Emoji usage in code/comments
- Missing tests for new code
- Accessibility issues (a11y)

## Issue Categories

| Category | Prefix | Examples |
|----------|--------|----------|
| Automated Check Failure | `[FIX]` | Build errors, test failures, lint errors |
| Requirements Deviation | `[FIX]` | AC not met, missing functionality, wrong behavior |
| Code Quality Issue | `[QUALITY]` | DRY violations, overengineering, dead code, unclear naming |

## Severity

| Severity | Priority | Description |
|----------|----------|-------------|
| Critical | 1-2 | Blocks functionality, fails checks, security issue |
| Major | 3+ | Significant quality issue, partial AC met |
| Minor | Last | Improvement opportunity |

Automated check failures are always Critical with highest priority.
