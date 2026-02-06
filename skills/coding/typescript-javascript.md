# TypeScript & JavaScript Standards

## Naming

```typescript
// Variables: descriptive, clear intent
const marketSearchQuery = 'election'
const isUserAuthenticated = true

// Functions: verb-noun pattern
async function fetchMarketData(marketId: string) { }
function isValidEmail(email: string): boolean { }
```

## Immutability (Critical)

Always create new objects instead of mutating:

```typescript
// Good: Spread operator
const updatedUser = { ...user, name: 'New Name' }
const updatedArray = [...items, newItem]

// Bad: Direct mutation
user.name = 'New Name'
items.push(newItem)
```

## Type Safety

```typescript
// Good: Explicit types, unions for known values
interface Market {
  id: string
  name: string
  status: 'active' | 'resolved' | 'closed'
}

// Bad: Using 'any'
function getMarket(id: any): Promise<any> { }
```

## Async/Await

```typescript
// Good: Parallel when independent
const [users, markets] = await Promise.all([
  fetchUsers(),
  fetchMarkets()
])

// Bad: Sequential when unnecessary
const users = await fetchUsers()
const markets = await fetchMarkets()
```

## Error Handling

```typescript
async function fetchData(url: string) {
  try {
    const response = await fetch(url)
    if (!response.ok) {
      throw new Error(`HTTP ${response.status}: ${response.statusText}`)
    }
    return await response.json()
  } catch (error) {
    console.error('Fetch failed:', error)
    throw new Error('Failed to fetch data')
  }
}
```

## Input Validation

```typescript
import { z } from 'zod'

const CreateMarketSchema = z.object({
  name: z.string().min(1).max(200),
  description: z.string().min(1).max(2000),
  endDate: z.string().datetime()
})

const validated = CreateMarketSchema.parse(input)
```

## API Response Format

```typescript
// Consistent response structure
interface ApiResponse<T> {
  success: boolean
  data?: T
  error?: string
}

// Success: { success: true, data: markets }
// Error: { success: false, error: 'Invalid request' }
```

## Common Mistakes

```typescript
// Bad: Assumes nested properties exist
const name = user.profile.name
// Good: Optional chaining with fallback
const name = user?.profile?.name ?? 'Unknown'

// Bad: Unhandled rejection
fetchData().then(process)
// Good: Handle errors
try {
  const data = await fetchData()
} catch (error) {
  handleError(error)
}

// Bad: Mutating parameter
array.push(item)
// Good: Return new array
return [...array, item]
```

## File Naming

```
components/Button.tsx     # PascalCase for components
hooks/useAuth.ts          # camelCase with 'use' prefix
lib/formatDate.ts         # camelCase for utilities
types/market.types.ts     # .types suffix for type files
```
