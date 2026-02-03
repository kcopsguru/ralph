# Interactive Review

Present issues to user for confirmation before converting to stories.

## Present Issues by Severity

Group by severity (critical first, then major, then minor):

```
## Code Review Results

### Critical Issues (2)

1. **[Requirements Deviation]** LoginForm missing email validation
   - File: src/components/LoginForm.tsx
   - Related: US-002 AC #3
   - Suggested: [FIX] Add email validation to LoginForm

2. **[Requirements Deviation]** Dashboard pagination not implemented
   - File: src/pages/Dashboard.tsx
   - Related: US-007 AC #2
   - Suggested: [FIX] Implement dashboard pagination

### Major Issues (1)

3. **[Code Quality]** Duplicate error handling in API functions
   - Files: src/api/users.ts, src/api/posts.ts
   - Suggested: [QUALITY] Extract duplicate API error handling

### Minor Issues (1)

4. **[Code Quality]** Unclear function name 'doThing'
   - File: src/helpers/format.ts
   - Suggested: [QUALITY] Rename unclear function
```

## User Actions

Prompt for user input:

```
Please review each issue:
- Number(s) to confirm: "1" or "1, 2, 3"
- "all" to confirm all
- "dismiss N" to remove issue
- "modify N" to adjust issue

Which issues should become stories?
```

| Action | Input | Result |
|--------|-------|--------|
| Confirm single | `1` | Issue #1 → story |
| Confirm multiple | `1, 2, 3` | Issues #1-3 → stories |
| Confirm all | `all` | All → stories |
| Dismiss | `dismiss 4` | Issue #4 removed |
| Modify | `modify 3` | Prompt for changes |

## Handling Modifications

When user types `modify N`:

```
Modifying Issue #3: Duplicate error handling

Current severity: Major
Current description: Identical try/catch blocks in 5 functions

What would you like to change?
1. Change severity to Critical
2. Change severity to Minor
3. Update description
4. Add additional context

Enter choice (or type new description):
```

## Adding User Context

User can add context with confirmation:

```
> 1, 2 - Use the same regex as the signup form

Added note to US-011 and US-012: "Use the same regex as the signup form"
```

Add context to the story's `notes` field or acceptance criteria.

## Limiting Issues Per Cycle

For many issues, recommend focusing on critical + major first:

```
Found 2 critical, 3 major, and 8 minor issues.

Recommendation: Process critical + major first (5 total).
After fixes, run /ralph-code-review again for minor issues.

Options:
1. Critical + major only (recommended)
2. Include all 13 issues
3. Select specific issues

Choose (1/2/3):
```

## Update prd.json

After user confirms, append stories to `.ralph/prd.json`:

- Never modify existing stories
- Continue ID sequence from highest existing
- Preserve all other fields (project, branchName, etc.)

Report changes:
```
Updating .ralph/prd.json:
- Stories before: 10
- Adding: 3 new stories (US-011, US-012, US-013)
- Stories after: 13

Proceed? (yes/no)
```
