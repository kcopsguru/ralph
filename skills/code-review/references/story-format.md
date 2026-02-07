# Story Format

Convert confirmed issues to stories in `.ralph/prd.json`.

## Rules

- **IDs**: Continue from last existing (US-010 → US-011, US-012...)
- **Prefix**: `[FIX]` for check failures and requirements deviations, `[QUALITY]` for code quality and guideline violations
- **Priority**: Critical first (1, 2...), then Major, then Minor
- **Fields**: `passes: false`, `notes: ""`

## Categories

| Category | Prefix | Use When |
|----------|--------|----------|
| Automated Check Failure | `[FIX]` | Build, lint, typecheck, or test failures |
| Requirements Deviation | `[FIX]` | Acceptance criteria not met |
| Coding Guideline Violation | `[QUALITY]` | Violates `skills/coding/` standards |
| Code Quality Issue | `[QUALITY]` | DRY violations, dead code, unclear naming |

## Template

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

## Acceptance Criteria References

- Reference existing stories: `"See US-002 AC #3"`
- Reference coding skill when relevant: `"Per coding skill: use immutable updates"`

## Coding Guideline Violation Example

```json
{
  "id": "US-012",
  "title": "[QUALITY] Fix direct state mutation in UserList component",
  "description": "As a developer, I need to use immutable updates per coding standards.",
  "acceptanceCriteria": [
    "Replace array.push() with spread operator [...array, item]",
    "Per coding skill: always create new objects instead of mutating"
  ],
  "priority": 3,
  "category": "Coding Guideline Violation",
  "severity": "Major",
  "files": ["src/components/UserList.tsx"],
  "relatedStory": null,
  "passes": false,
  "notes": ""
}
```
