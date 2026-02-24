# Discovering Project Checks

Before writing acceptance criteria, discover what automated checks the project uses and categorize them by execution time. This ensures fast iteration during development while maintaining full test coverage.

## Where to Look

CI config first (`.github/workflows/*.yml`), then package manager scripts (`package.json`, `Makefile`, etc.). Look for combined scripts like `check`, `ci`, `validate` that run everything.

## Categorizing Checks by Speed

| Category | Examples | When to Run |
|----------|----------|-------------|
| **Fast checks** | `lint`, `typecheck`, `build`, `test` (unit tests) | Every user story |
| **Slow checks** | `test:e2e`, `test:integration`, `cypress`, `playwright`, `e2e`, `integration` | Final story only |

### How to Identify Slow Checks

- Script names containing: `e2e`, `integration`, `cypress`, `playwright`, `selenium`, `puppeteer`
- Scripts that launch browsers or external services
- Scripts with significantly longer timeouts in CI config
- Any test that requires a running server or database setup

## Constructing Check Commands

1. **Fast check command** - Combine lint, typecheck, build, and unit tests:
   - If project has `check:fast` or similar → use that
   - Otherwise → combine: `npm run lint && npm run build && npm test` (excluding e2e)
   - For Go: `go vet ./... && go build ./... && go test ./...`
   - For Python: `ruff check . && pytest -m "not e2e"`

2. **Full check command** - Include everything (fast + slow):
   - If project has `check`, `ci`, or `validate` that runs all → use that
   - Otherwise → combine all: `npm run lint && npm run build && npm test && npm run test:e2e`

3. If nothing found → ask the user what checks should pass

## Example Classification

For a project with these scripts in package.json:

```json
{
  "scripts": {
    "lint": "eslint .",
    "build": "tsc",
    "test": "vitest",
    "test:e2e": "playwright test",
    "check": "npm run lint && npm run build && npm test && npm run test:e2e"
  }
}
```

- **Fast checks:** `npm run lint && npm run build && npm test`
- **Full checks:** `npm run check`

Use fast checks in each implementation story. Use full checks in the final verification story.
