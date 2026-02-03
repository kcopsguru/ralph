# Story Format

Convert confirmed issues to stories in `.ralph/prd.json`.

## Rules

- **IDs**: Continue from last existing (US-010 → US-011, US-012...)
- **Prefix**: `[FIX]` for check failures and requirements deviations, `[QUALITY]` for code quality
- **Priority**: Critical first (1, 2...), then Major, then Minor
- **Fields**: `passes: false`, `notes: ""`

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

Acceptance criteria can reference existing: `"See US-002 AC #3"`
