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

Test complete user journeys - focus on **UI behavior and workflows**, not data content.

**What E2E tests SHOULD verify:**
- UI components appear/disappear correctly
- User interactions work (click, type, keyboard navigation)
- Navigation flows complete successfully
- Error states display appropriately

**What E2E tests should NOT verify:**
- Specific data values (file names, item counts, exact text content from arrays)
- Implementation details that may change
- Every item in a list - just verify the list appears

```typescript
import { test, expect } from '@playwright/test'

test('user can search and view results', async ({ page }) => {
  await page.goto('/')

  await page.fill('input[placeholder="Search"]', 'test query')
  await page.waitForTimeout(600) // Debounce

  // GOOD: Verify results appear (behavior)
  const results = page.locator('[data-testid="result-card"]')
  await expect(results.first()).toBeVisible({ timeout: 5000 })

  // GOOD: Verify interaction works
  await results.first().click()
  await expect(page).toHaveURL(/\/markets\//)
})

// BAD: Don't test specific data content
test.skip('verify specific items in list', async ({ page }) => {
  // DON'T: Test specific hardcoded values
  await expect(page.getByText('specific-file.pdf')).toBeVisible()
  await expect(page.getByText('another-item.docx')).toBeVisible()
  // This breaks when data changes and tests implementation, not behavior
})
```

## E2E Test Scope Guidelines

E2E tests are expensive (slow, flaky, hard to maintain). Focus them on **critical UI workflows**, not data verification.

| Test This (Behavior) | Don't Test This (Data) |
|---------------------|------------------------|
| Popup appears when triggered | Specific items in the popup |
| Filtering reduces visible items | Which specific items remain |
| Selection inserts reference | Exact text of the reference |
| Keyboard navigation works | Order of items in list |
| Error state displays | Exact error message text |
| Form submits successfully | Specific form field values |

**Rule of thumb**: If changing a hardcoded array or config would break your E2E test, you're testing data, not behavior. Refactor the test to verify the interaction pattern instead.

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

### ❌ E2E Tests That Verify Specific Data Content

```bash
# DON'T: Test specific file names/items from hardcoded arrays
if echo "$SNAPSHOT" | grep -q "guidelines.pdf"; then
if echo "$SNAPSHOT" | grep -q "underwriting-manual.docx"; then
# This couples tests to data that may change
# If you update the array, the test breaks
```

### ✅ E2E Tests That Verify UI Behavior

```bash
# DO: Test that the popup appears with items (any items)
# Test that filtering reduces visible items
# Test that selection inserts something into input
# Test keyboard/mouse interactions work

# Example: Verify popup has items (behavior), not which items (data)
ITEM_COUNT=$(echo "$SNAPSHOT" | grep -c "listitem")
if [ "$ITEM_COUNT" -gt 0 ]; then
    echo "PASS: Popup displays items"
fi

# Example: Verify filtering works (behavior), not specific filtered results
BEFORE_COUNT=$(get_item_count)
browser_cmd type "$INPUT_REF" "filter-text"
AFTER_COUNT=$(get_item_count)
if [ "$AFTER_COUNT" -lt "$BEFORE_COUNT" ]; then
    echo "PASS: Filtering reduces item count"
fi
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
