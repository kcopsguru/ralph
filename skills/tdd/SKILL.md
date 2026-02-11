---
name: tdd
description: Enforces test-driven development with 80%+ coverage. Use when implementing new features, fixing bugs, refactoring code, or adding API endpoints. Guides through Red-Green-Refactor cycle with unit, integration, and E2E tests.
disable-model-invocation: true
---

# Test-Driven Development

This skill ensures all code development follows TDD principles with comprehensive test coverage.

## When to Use

- Implementing new features or functionality
- Fixing bugs (write test that reproduces bug first)
- Refactoring existing code
- Adding API endpoints or components
- Building critical business logic

## Core Workflow: Red-Green-Refactor

```
RED → GREEN → REFACTOR → REPEAT

RED:      Write a failing test first
GREEN:    Write minimal code to pass
REFACTOR: Improve code, keep tests passing
REPEAT:   Next feature/scenario
```

### Step 1: Write Test First (RED)

```typescript
describe('calculateLiquidityScore', () => {
  it('returns high score for liquid market', () => {
    const market = {
      totalVolume: 100000,
      bidAskSpread: 0.01,
      activeTraders: 500
    }

    const score = calculateLiquidityScore(market)

    expect(score).toBeGreaterThan(80)
    expect(score).toBeLessThanOrEqual(100)
  })

  it('handles zero volume edge case', () => {
    const market = { totalVolume: 0, bidAskSpread: 0, activeTraders: 0 }
    expect(calculateLiquidityScore(market)).toBe(0)
  })
})
```

### Step 2: Run Test - Verify FAIL

```bash
npm test
# Test should fail - implementation doesn't exist yet
```

### Step 3: Write Minimal Implementation (GREEN)

```typescript
export function calculateLiquidityScore(market: MarketData): number {
  if (market.totalVolume === 0) return 0

  const volumeScore = Math.min(market.totalVolume / 1000, 100)
  const spreadScore = Math.max(100 - (market.bidAskSpread * 1000), 0)
  const traderScore = Math.min(market.activeTraders / 10, 100)

  return (volumeScore * 0.4 + spreadScore * 0.4 + traderScore * 0.2)
}
```

### Step 4: Run Test - Verify PASS

```bash
npm test
# All tests should now pass
```

### Step 5: Refactor (IMPROVE)

Improve code quality while keeping tests green:
- Extract constants
- Improve naming
- Remove duplication
- Optimize performance

### Step 6: Verify Coverage

```bash
npm run test:coverage
# Verify 80%+ coverage achieved
```

## Coverage Requirements

**Minimum 80% coverage** across:
- Branches: 80%
- Functions: 80%
- Lines: 80%
- Statements: 80%

**100% required** for:
- Financial calculations
- Authentication logic
- Security-critical code
- Core business logic

## Test Types

### 1. Unit Tests (Required)

Test individual functions in isolation:

```typescript
import { calculateSimilarity } from './utils'

describe('calculateSimilarity', () => {
  it('returns 1.0 for identical embeddings', () => {
    const embedding = [0.1, 0.2, 0.3]
    expect(calculateSimilarity(embedding, embedding)).toBe(1.0)
  })

  it('returns 0.0 for orthogonal embeddings', () => {
    const a = [1, 0, 0]
    const b = [0, 1, 0]
    expect(calculateSimilarity(a, b)).toBe(0.0)
  })

  it('throws for null input', () => {
    expect(() => calculateSimilarity(null, [])).toThrow()
  })
})
```

### 2. Integration Tests (Required)

Test API endpoints and database operations:

```typescript
import { NextRequest } from 'next/server'
import { GET } from './route'

describe('GET /api/markets/search', () => {
  it('returns 200 with valid results', async () => {
    const request = new NextRequest('http://localhost/api/markets/search?q=test')
    const response = await GET(request, {})
    const data = await response.json()

    expect(response.status).toBe(200)
    expect(data.success).toBe(true)
  })

  it('returns 400 for missing query', async () => {
    const request = new NextRequest('http://localhost/api/markets/search')
    const response = await GET(request, {})

    expect(response.status).toBe(400)
  })
})
```

### 3. E2E Tests (For Critical Flows)

Test complete user journeys with Playwright:

```typescript
import { test, expect } from '@playwright/test'

test('user can search and view market', async ({ page }) => {
  await page.goto('/')

  await page.fill('input[placeholder="Search"]', 'election')
  await page.waitForTimeout(600) // Debounce

  const results = page.locator('[data-testid="result-card"]')
  await expect(results).toHaveCount(5, { timeout: 5000 })

  await results.first().click()
  await expect(page).toHaveURL(/\/markets\//)
})
```

## Test File Organization

```
src/
├── components/
│   └── Button/
│       ├── Button.tsx
│       └── Button.test.tsx      # Unit tests
├── app/
│   └── api/
│       └── markets/
│           ├── route.ts
│           └── route.test.ts    # Integration tests
└── e2e/
    ├── search.spec.ts           # E2E tests
    └── auth.spec.ts
```

## Mocking External Dependencies

See [PATTERNS.md](PATTERNS.md) for detailed mocking patterns including:
- Database mocks (Supabase, Prisma)
- Cache mocks (Redis)
- External API mocks (OpenAI, Stripe)
- Component mocks

## Edge Cases to Test

See [EDGE-CASES.md](EDGE-CASES.md) for comprehensive checklist including:
- Null/undefined inputs
- Empty arrays/strings
- Boundary values
- Error conditions
- Race conditions

## Anti-Patterns to Avoid

### ❌ Testing Implementation Details

```typescript
// DON'T test internal state
expect(component.state.count).toBe(5)
```

### ✅ Test User-Visible Behavior

```typescript
// DO test what users see
expect(screen.getByText('Count: 5')).toBeInTheDocument()
```

### ❌ Tests Depend on Each Other

```typescript
// DON'T rely on previous test
test('creates user', () => { /* ... */ })
test('updates same user', () => { /* needs previous test */ })
```

### ✅ Independent Tests

```typescript
// DO setup data in each test
test('updates user', () => {
  const user = createTestUser()
  // Test logic
})
```

### ❌ Brittle Selectors

```typescript
// Breaks easily
await page.click('.css-class-xyz')
```

### ✅ Semantic Selectors

```typescript
// Resilient to changes
await page.click('button:has-text("Submit")')
await page.click('[data-testid="submit-button"]')
```

## Quality Checklist

Before marking tests complete:

- [ ] All public functions have unit tests
- [ ] All API endpoints have integration tests
- [ ] Critical user flows have E2E tests
- [ ] Edge cases covered (null, empty, invalid)
- [ ] Error paths tested (not just happy path)
- [ ] Mocks used for external dependencies
- [ ] Tests are independent (no shared state)
- [ ] Tests are idempotent (same result on re-run)
- [ ] Tests have no side effects
- [ ] Tests do not read/modify user config files
- [ ] Test names describe what's being tested
- [ ] Assertions are specific and meaningful
- [ ] Coverage is 80%+ (verified with report)

## Troubleshooting Test Failures

1. **Check test isolation** - ensure tests don't share state
2. **Verify mocks are correct** - mock returns expected values
3. **Fix implementation, not tests** - unless tests are wrong
4. **Check async handling** - proper await/async usage
5. **Review error messages** - they often point to the issue

## Continuous Testing

```bash
# Watch mode during development
npm test -- --watch

# Run before commit
npm test && npm run lint

# CI/CD integration
npm test -- --coverage --ci
```

---

**Remember**: Tests are not optional. They are the safety net that enables confident refactoring, rapid development, and production reliability. No code without tests.
