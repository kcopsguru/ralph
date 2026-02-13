# Interactive Review

Present issues for user confirmation before adding to `.ralph/prd.json`.

## Present by Severity

```
## Code Review Results

### Critical Issues (2)
1. [Requirements Deviation] LoginForm missing email validation
   File: src/components/LoginForm.tsx | Related: US-002 AC #3

### Major Issues (1)
2. [Code Quality] Duplicate error handling in API functions
   Files: src/api/users.ts, src/api/posts.ts
```

## User Actions

```
Confirm: "1" or "1, 2" or "all"
Dismiss: "dismiss 3"
Modify: "modify 2" (prompts for changes)
Add context: "1, 2 - Use same regex as signup form"
```

## Many Issues

If >5 issues, recommend critical+major first:
```
Found 2 critical, 3 major, 8 minor. Process critical+major first? (y/n)
```

## Update prd.json

After confirmation:
- Append only, NEVER MODIFY EXISTING STORIES (INCLUDING NOTES)
- If the new story changes the requirements of previous stories, document this in the new story's notes
- Preserve all fields (project, branchName, description, reference)
- Report: "Stories before: 10, Adding: 3, After: 13"
