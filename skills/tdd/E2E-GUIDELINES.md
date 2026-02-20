# E2E Test Guidelines

E2E tests are expensive (slow, flaky, hard to maintain). Focus them on **critical UI workflows**, not data verification.

## What to Test

**Test UI behavior:**
- UI components appear/disappear correctly
- User interactions work (click, type, keyboard navigation)
- Navigation flows complete successfully
- Error states display appropriately

**Don't test data content:**
- Specific data values (file names, item counts, exact text from arrays)
- Implementation details that may change
- Every item in a list - just verify the list appears

## Scope Guidelines

| Test This (Behavior) | Don't Test This (Data) |
|---------------------|------------------------|
| Popup appears when triggered | Specific items in the popup |
| Filtering reduces visible items | Which specific items remain |
| Selection inserts reference | Exact text of the reference |
| Keyboard navigation works | Order of items in list |
| Error state displays | Exact error message text |
| Form submits successfully | Specific form field values |

**Rule of thumb**: If changing a hardcoded array or config would break your E2E test, you're testing data, not behavior.

## Example: Good E2E Test

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
```

## Example: Bad E2E Test

```typescript
// DON'T: Test specific data content
test('verify specific items in list', async ({ page }) => {
  // Breaks when data changes - tests implementation, not behavior
  await expect(page.getByText('specific-file.pdf')).toBeVisible()
  await expect(page.getByText('another-item.docx')).toBeVisible()
})
```

## Selector Best Practices

```typescript
// ❌ Brittle - breaks easily
await page.click('.css-class-xyz')

// ✅ Resilient to changes
await page.click('button:has-text("Submit")')
await page.click('[data-testid="submit-button"]')
```
