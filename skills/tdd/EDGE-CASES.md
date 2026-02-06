# Edge Cases Checklist

Comprehensive list of edge cases that must be tested for robust code.

## Input Validation

### Null/Undefined

```typescript
it('handles null input', () => {
  expect(() => processData(null)).toThrow('Input required')
})

it('handles undefined input', () => {
  expect(() => processData(undefined)).toThrow('Input required')
})
```

### Empty Values

```typescript
it('handles empty string', () => {
  expect(processText('')).toBe('')
})

it('handles empty array', () => {
  expect(calculateAverage([])).toBe(0)
})

it('handles empty object', () => {
  expect(validateConfig({})).toEqual({ valid: false, errors: ['Config is empty'] })
})
```

### Invalid Types

```typescript
it('handles wrong type - string instead of number', () => {
  expect(() => calculate('not a number')).toThrow(TypeError)
})

it('handles wrong type - array instead of object', () => {
  expect(() => processConfig([1, 2, 3])).toThrow('Expected object')
})
```

## Boundary Values

### Numeric Boundaries

```typescript
it('handles zero', () => {
  expect(divide(10, 0)).toThrow('Division by zero')
})

it('handles negative numbers', () => {
  expect(calculateScore(-5)).toBe(0) // Clamped to minimum
})

it('handles maximum value', () => {
  expect(calculateScore(Number.MAX_SAFE_INTEGER)).toBe(100) // Clamped to maximum
})

it('handles floating point precision', () => {
  expect(add(0.1, 0.2)).toBeCloseTo(0.3)
})
```

### Array Boundaries

```typescript
it('handles single element array', () => {
  expect(findMedian([5])).toBe(5)
})

it('handles two element array', () => {
  expect(findMedian([1, 3])).toBe(2)
})

it('handles large array', () => {
  const largeArray = Array.from({ length: 10000 }, (_, i) => i)
  expect(findMedian(largeArray)).toBe(4999.5)
})
```

### String Boundaries

```typescript
it('handles single character', () => {
  expect(capitalize('a')).toBe('A')
})

it('handles very long string', () => {
  const longString = 'a'.repeat(10000)
  expect(truncate(longString, 100)).toHaveLength(103) // 100 + '...'
})
```

## Special Characters

### Unicode

```typescript
it('handles unicode characters', () => {
  expect(slugify('Привет мир')).toBe('privet-mir')
})

it('handles emojis', () => {
  expect(countCharacters('Hello 👋')).toBe(7)
})

it('handles RTL text', () => {
  expect(processText('مرحبا')).toBeDefined()
})
```

### SQL Injection Prevention

```typescript
it('escapes SQL special characters', () => {
  const malicious = "'; DROP TABLE users; --"
  expect(sanitizeInput(malicious)).not.toContain(';')
})
```

### XSS Prevention

```typescript
it('escapes HTML in user input', () => {
  const malicious = '<script>alert("xss")</script>'
  expect(escapeHtml(malicious)).toBe('&lt;script&gt;alert("xss")&lt;/script&gt;')
})
```

## Error Conditions

### Network Errors

```typescript
it('handles network timeout', async () => {
  jest.spyOn(global, 'fetch').mockRejectedValue(new Error('Network timeout'))
  
  const result = await fetchWithRetry('/api/data')
  
  expect(result.error).toBe('Network timeout')
  expect(result.retries).toBe(3)
})

it('handles 500 server error', async () => {
  jest.spyOn(global, 'fetch').mockResolvedValue({
    ok: false,
    status: 500,
    statusText: 'Internal Server Error'
  })
  
  await expect(fetchData()).rejects.toThrow('Server error')
})
```

### Database Errors

```typescript
it('handles connection failure', async () => {
  jest.spyOn(db, 'query').mockRejectedValue(new Error('Connection refused'))
  
  const result = await getUserSafe(1)
  
  expect(result).toEqual({ error: 'Database unavailable', user: null })
})

it('handles record not found', async () => {
  jest.spyOn(db, 'findById').mockResolvedValue(null)
  
  await expect(getUser(999)).rejects.toThrow('User not found')
})
```

### File System Errors

```typescript
it('handles file not found', async () => {
  await expect(readConfig('/nonexistent/path')).rejects.toThrow('ENOENT')
})

it('handles permission denied', async () => {
  jest.spyOn(fs, 'readFile').mockRejectedValue({ code: 'EACCES' })
  
  await expect(readConfig('/etc/shadow')).rejects.toThrow('Permission denied')
})
```

## Race Conditions

### Concurrent Operations

```typescript
it('handles concurrent updates safely', async () => {
  const counter = createCounter()
  
  // Simulate 100 concurrent increments
  await Promise.all(
    Array.from({ length: 100 }, () => counter.increment())
  )
  
  expect(counter.value).toBe(100)
})
```

### Stale Data

```typescript
it('prevents stale updates with optimistic locking', async () => {
  const record = await getRecord(1) // version: 1
  
  // Another process updates the record
  await updateRecord(1, { data: 'other', version: 1 })
  
  // Our update should fail due to version mismatch
  await expect(
    updateRecord(1, { data: 'ours', version: 1 })
  ).rejects.toThrow('Conflict: record was modified')
})
```

## Date/Time Edge Cases

```typescript
it('handles timezone conversions', () => {
  const utc = new Date('2024-01-01T00:00:00Z')
  expect(formatLocalDate(utc, 'America/New_York')).toBe('2023-12-31')
})

it('handles daylight saving time', () => {
  // Spring forward - 2:00 AM doesn't exist
  const dst = new Date('2024-03-10T02:30:00')
  expect(isValidTime(dst, 'America/New_York')).toBe(false)
})

it('handles leap year', () => {
  expect(isValidDate(2024, 2, 29)).toBe(true)
  expect(isValidDate(2023, 2, 29)).toBe(false)
})

it('handles year 2038 problem', () => {
  const farFuture = new Date('2040-01-01')
  expect(formatDate(farFuture)).toBe('2040-01-01')
})
```

## Performance Edge Cases

```typescript
it('handles large datasets efficiently', async () => {
  const startTime = Date.now()
  
  const largeDataset = generateItems(100000)
  await processItems(largeDataset)
  
  const duration = Date.now() - startTime
  expect(duration).toBeLessThan(5000) // Should complete within 5 seconds
})

it('handles memory-intensive operations', () => {
  // This should not cause out-of-memory
  const result = processLargeFile(createMockStream(1_000_000_000))
  expect(result.processed).toBe(true)
})
```

## Checklist Summary

For every function, verify handling of:

- [ ] Null input
- [ ] Undefined input
- [ ] Empty string/array/object
- [ ] Invalid types
- [ ] Zero values
- [ ] Negative numbers
- [ ] Maximum values
- [ ] Floating point precision
- [ ] Single element collections
- [ ] Very large inputs
- [ ] Unicode characters
- [ ] Special characters (SQL, HTML)
- [ ] Network failures
- [ ] Database errors
- [ ] File system errors
- [ ] Concurrent access
- [ ] Timezone handling
- [ ] Date edge cases
- [ ] Performance with large data
