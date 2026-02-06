# React Standards

## Component Structure

```typescript
// Define props with interface, use destructuring with defaults
interface ButtonProps {
  children: React.ReactNode
  onClick: () => void
  variant?: 'primary' | 'secondary'
}

export function Button({ children, onClick, variant = 'primary' }: ButtonProps) {
  return <button onClick={onClick} className={`btn-${variant}`}>{children}</button>
}
```

## State Updates

```typescript
// Good: Functional update for state based on previous value
setCount(prev => prev + 1)
setItems(prev => [...prev, newItem])

// Bad: Can be stale in async scenarios
setCount(count + 1)
```

## Conditional Rendering

```typescript
// Good: Clear conditions
{isLoading && <Spinner />}
{error && <ErrorMessage error={error} />}
{data && <DataDisplay data={data} />}

// Bad: Ternary hell
{isLoading ? <Spinner /> : error ? <ErrorMessage /> : <Data />}
```

## Memoization

```typescript
// Expensive computations
const sorted = useMemo(() => items.sort(compareFn), [items])

// Stable callback references
const handleSearch = useCallback((q: string) => setQuery(q), [])
```

Use when computation is expensive or reference stability matters. Don't overuse.

## Effects

```typescript
// Always clean up subscriptions
useEffect(() => {
  const sub = api.subscribe(handler)
  return () => sub.unsubscribe()
}, [])

// Include all dependencies
useEffect(() => {
  fetchData(userId, filter)
}, [userId, filter])
```

## Custom Hooks

Extract reusable stateful logic into `use*` functions. Keep hooks focused on a single responsibility.

## Common Mistakes

```typescript
// Bad: Index as key
{items.map((item, i) => <Item key={i} />)}
// Good: Unique identifier
{items.map(item => <Item key={item.id} />)}

// Bad: Effect for derived state
useEffect(() => setCount(items.length), [items])
// Good: Derive directly
const count = items.length

// Bad: Missing dependency array (runs every render)
useEffect(() => fetchData())
// Good: Explicit dependencies
useEffect(() => fetchData(), [])
```

## Lazy Loading

```typescript
const HeavyChart = lazy(() => import('./HeavyChart'))

<Suspense fallback={<Spinner />}>
  <HeavyChart />
</Suspense>
```

Use for large components, routes, or below-the-fold content.
