# Test Patterns and Mocking

Detailed patterns for mocking external dependencies and writing effective tests.

## Mocking Databases

### Supabase

```typescript
jest.mock('@/lib/supabase', () => ({
  supabase: {
    from: jest.fn(() => ({
      select: jest.fn(() => ({
        eq: jest.fn(() => Promise.resolve({
          data: [{ id: 1, name: 'Test Market' }],
          error: null
        }))
      }))
    }))
  }
}))
```

### Prisma

```typescript
jest.mock('@/lib/prisma', () => ({
  prisma: {
    user: {
      findUnique: jest.fn(),
      create: jest.fn(),
      update: jest.fn(),
    },
    $transaction: jest.fn((callback) => callback(prisma)),
  }
}))

// In test
prisma.user.findUnique.mockResolvedValue({ id: 1, email: 'test@example.com' })
```

## Mocking Cache

### Redis

```typescript
jest.mock('@/lib/redis', () => ({
  redis: {
    get: jest.fn(),
    set: jest.fn(),
    del: jest.fn(),
  },
  searchByVector: jest.fn(() => Promise.resolve([
    { slug: 'test-1', similarity_score: 0.95 },
    { slug: 'test-2', similarity_score: 0.90 }
  ])),
  checkHealth: jest.fn(() => Promise.resolve({ connected: true }))
}))
```

## Mocking External APIs

### OpenAI

```typescript
jest.mock('@/lib/openai', () => ({
  generateEmbedding: jest.fn(() => Promise.resolve(
    new Array(1536).fill(0.1)
  )),
  createCompletion: jest.fn(() => Promise.resolve({
    choices: [{ message: { content: 'Mock response' } }]
  }))
}))
```

### Stripe

```typescript
jest.mock('stripe', () => ({
  __esModule: true,
  default: jest.fn(() => ({
    customers: {
      create: jest.fn(() => Promise.resolve({ id: 'cus_mock' })),
      retrieve: jest.fn(() => Promise.resolve({ id: 'cus_mock', email: 'test@example.com' })),
    },
    subscriptions: {
      create: jest.fn(() => Promise.resolve({ id: 'sub_mock', status: 'active' })),
    }
  }))
}))
```

### Fetch/HTTP

```typescript
// Mock global fetch
global.fetch = jest.fn(() =>
  Promise.resolve({
    ok: true,
    status: 200,
    json: () => Promise.resolve({ data: 'mock' }),
  })
) as jest.Mock

// Reset between tests
beforeEach(() => {
  (global.fetch as jest.Mock).mockClear()
})
```

## Mocking React Components

### Testing Library Setup

```typescript
import { render, screen, fireEvent, waitFor } from '@testing-library/react'
import userEvent from '@testing-library/user-event'

describe('Button Component', () => {
  it('renders with correct text', () => {
    render(<Button>Click me</Button>)
    expect(screen.getByText('Click me')).toBeInTheDocument()
  })
  
  it('calls onClick when clicked', async () => {
    const handleClick = jest.fn()
    render(<Button onClick={handleClick}>Click</Button>)
    
    await userEvent.click(screen.getByRole('button'))
    
    expect(handleClick).toHaveBeenCalledTimes(1)
  })
  
  it('is disabled when disabled prop is true', () => {
    render(<Button disabled>Click</Button>)
    expect(screen.getByRole('button')).toBeDisabled()
  })
})
```

### Mocking Hooks

```typescript
// Mock a custom hook
jest.mock('@/hooks/useAuth', () => ({
  useAuth: jest.fn(() => ({
    user: { id: 1, name: 'Test User' },
    isLoading: false,
    signIn: jest.fn(),
    signOut: jest.fn(),
  }))
}))

// Override in specific test
import { useAuth } from '@/hooks/useAuth'
const mockUseAuth = useAuth as jest.Mock

test('shows loading state', () => {
  mockUseAuth.mockReturnValue({ user: null, isLoading: true })
  render(<Profile />)
  expect(screen.getByText('Loading...')).toBeInTheDocument()
})
```

### Mocking Router

```typescript
// Next.js App Router
jest.mock('next/navigation', () => ({
  useRouter: jest.fn(() => ({
    push: jest.fn(),
    replace: jest.fn(),
    back: jest.fn(),
  })),
  usePathname: jest.fn(() => '/current-path'),
  useSearchParams: jest.fn(() => new URLSearchParams()),
}))
```

## Testing Async Operations

### Waiting for State Updates

```typescript
test('loads data on mount', async () => {
  render(<DataComponent />)
  
  // Wait for loading to finish
  await waitFor(() => {
    expect(screen.queryByText('Loading...')).not.toBeInTheDocument()
  })
  
  // Assert data is displayed
  expect(screen.getByText('Data loaded')).toBeInTheDocument()
})
```

### Testing Error States

```typescript
test('displays error when API fails', async () => {
  // Mock failure
  jest.spyOn(api, 'fetchData').mockRejectedValue(new Error('Network error'))
  
  render(<DataComponent />)
  
  await waitFor(() => {
    expect(screen.getByText('Error: Network error')).toBeInTheDocument()
  })
})
```

## Testing Fallback Behavior

```typescript
test('falls back to substring search when Redis unavailable', async () => {
  // Mock Redis failure
  jest.spyOn(redis, 'searchByVector').mockRejectedValue(new Error('Redis down'))
  
  const request = new NextRequest('http://localhost/api/search?q=test')
  const response = await GET(request, {})
  const data = await response.json()
  
  expect(response.status).toBe(200)
  expect(data.fallback).toBe(true)
})
```

## Snapshot Testing

```typescript
test('renders correctly', () => {
  const { container } = render(<Card title="Test" />)
  expect(container).toMatchSnapshot()
})
```

**Use sparingly** - snapshots are brittle. Prefer explicit assertions for behavior.

## Test Data Factories

```typescript
// factories/user.ts
export function createTestUser(overrides = {}) {
  return {
    id: 1,
    email: 'test@example.com',
    name: 'Test User',
    createdAt: new Date('2024-01-01'),
    ...overrides,
  }
}

// In tests
const user = createTestUser({ name: 'Custom Name' })
```

## Best Practices Summary

1. **Mock at boundaries** - mock external services, not internal functions
2. **Reset mocks between tests** - use `beforeEach` with `mockClear()`
3. **Mock return values, not implementations** - prefer `mockResolvedValue` over `mockImplementation`
4. **Use factories for test data** - avoid duplicating mock data
5. **Test behavior, not implementation** - focus on inputs and outputs
