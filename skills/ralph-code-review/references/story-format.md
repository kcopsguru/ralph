# Story Format

Convert confirmed issues to user stories for `.ralph/prd.json`.

## Story ID Sequencing

Continue from the last existing ID:
```bash
# If last story is US-010, new issues become US-011, US-012, ...
```

Never reuse or skip IDs.

## Title Prefixes

| Issue Category | Prefix |
|---------------|--------|
| Automated Check Failure | `[FIX]` |
| Requirements Deviation | `[FIX]` |
| Code Quality Issue | `[QUALITY]` |

## Required Fields

```json
{
  "id": "US-011",
  "title": "[FIX] Add email validation to LoginForm",
  "description": "As a developer, I need to fix...",
  "acceptanceCriteria": [
    "Specific criterion (See US-002 AC #3)",
    "Another criterion"
  ],
  "priority": 1,
  "category": "Requirements Deviation",
  "severity": "Critical",
  "files": ["src/components/LoginForm.tsx"],
  "relatedStory": "US-002",
  "passes": false,
  "notes": ""
}
```

## Priority Assignment

| Severity | Priority |
|----------|----------|
| Critical (check failures) | Lowest numbers (1, 2...) |
| Critical (other) | Next lowest |
| Major | Middle |
| Minor | Highest numbers |

## Acceptance Criteria

Can reference existing criteria:
```
"Form validates email format (See US-002 AC #3)"
```

Or define new ones:
```
"Extract error handling to shared utility"
"All API functions use shared utility"
```

## Example: Automated Check Failure

```json
{
  "id": "US-011",
  "title": "[FIX] Resolve typecheck errors in parser.ts",
  "description": "As a developer, I need to fix type errors so the build passes.",
  "acceptanceCriteria": [
    "Fix: Property 'parse' does not exist on type 'undefined'",
    "npm run typecheck passes with no errors"
  ],
  "priority": 1,
  "category": "Automated Check Failure",
  "severity": "Critical",
  "files": ["src/utils/parser.ts"],
  "relatedStory": "US-005",
  "passes": false,
  "notes": ""
}
```

## Example: Code Quality Issue

```json
{
  "id": "US-013",
  "title": "[QUALITY] Extract duplicate API error handling",
  "description": "As a developer, I need to consolidate duplicate code for maintainability.",
  "acceptanceCriteria": [
    "Create shared handleApiError() utility",
    "Refactor API functions to use shared utility",
    "No duplicate try/catch blocks remain"
  ],
  "priority": 3,
  "category": "Code Quality Issue",
  "severity": "Major",
  "files": ["src/api/users.ts", "src/api/posts.ts"],
  "relatedStory": null,
  "passes": false,
  "notes": ""
}
```
