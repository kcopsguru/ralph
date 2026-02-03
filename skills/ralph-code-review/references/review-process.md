# Review Process

Manual code review after automated checks pass.

## Get Changed Files

```bash
# List changed files
git diff --name-only main...HEAD

# View full diff
git diff main...HEAD

# Check for uncommitted changes
git status --porcelain
```

If uncommitted changes exist, prompt user to commit first or acknowledge.

## Issue Categories

### 1. Automated Check Failures
Build, test, lint, or typecheck failures. Always Critical severity.

### 2. Requirements Deviations
Implementation doesn't match PRD or acceptance criteria:
- Acceptance criteria not met
- Missing functionality
- Behavior differs from spec
- Edge cases not handled

### 3. Code Quality Issues
Code works but violates standards:
- DRY violations
- Overengineering
- Dead code, unused imports
- High complexity
- Unclear naming
- Missing error handling
- Inconsistent patterns

## Severity Levels

| Severity | Description |
|----------|-------------|
| Critical | Blocks functionality, fails checks, security issue |
| Major | Significant quality issue, partial AC met |
| Minor | Improvement opportunity, not blocking |

## Document Issues

Use this format:

```
Category: [Automated Check Failure | Requirements Deviation | Code Quality Issue]
Severity: [Critical | Major | Minor]
File: path/to/file.ts
Issue: Clear description of the problem
Related Story: US-XXX, AC #N (or N/A)
```

## Examples

**Critical - Requirements Deviation:**
```
Category: Requirements Deviation
Severity: Critical
File: src/components/LoginForm.tsx
Issue: Missing email validation per AC #3 of US-002
Related Story: US-002, AC #3
```

**Major - Code Quality:**
```
Category: Code Quality Issue
Severity: Major
File: src/api/users.ts, src/api/posts.ts
Issue: Identical error handling duplicated in 5 functions
Related Story: N/A
```

**Minor - Code Quality:**
```
Category: Code Quality Issue
Severity: Minor
File: src/helpers/format.ts
Issue: Function 'doThing' has unclear naming
Related Story: N/A
```
