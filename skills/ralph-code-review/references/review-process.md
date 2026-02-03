# Review Process

Manual review after automated checks pass.

## Get Changes

```bash
git diff --name-only main...HEAD  # Changed files
git diff main...HEAD              # Full diff
git status --porcelain            # Uncommitted changes (prompt to commit first)
```

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
