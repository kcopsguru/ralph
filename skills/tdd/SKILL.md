---
name: tdd
description: Enforces test-driven development with 80%+ coverage. Use when implementing features, fixing bugs, refactoring, or adding API endpoints. Guides Red-Green-Refactor cycle.
disable-model-invocation: true
---

# Test-Driven Development

Ensures all code follows TDD principles with comprehensive test coverage.

## Contents

- [When to Use](#when-to-use)
- [Core Workflow](#core-workflow-red-green-refactor)
- [Coverage Requirements](#coverage-requirements)
- [Test Types](#test-types)
- [Anti-Patterns](#anti-patterns-to-avoid)
- [Quality Checklist](#quality-checklist)

## When to Use

- Implementing new features or functionality
- Fixing bugs (write test that reproduces bug first)
- Refactoring existing code
- Adding API endpoints or components

## Core Workflow: Red-Green-Refactor

```
RED → GREEN → REFACTOR → REPEAT
```

### Step 1: Write Test First (RED)

Write a failing test that defines expected behavior. Include edge cases.

### Step 2: Run Test - Verify FAIL

```bash
npm test  # Test should fail - implementation doesn't exist yet
```

### Step 3: Write Minimal Implementation (GREEN)

Write just enough code to make the test pass. No more.

### Step 4: Run Test - Verify PASS

```bash
npm test  # All tests should now pass
```

### Step 5: Refactor (IMPROVE)

Improve code quality while keeping tests green:
- Extract constants
- Improve naming
- Remove duplication

### Step 6: Verify Coverage

```bash
npm run test:coverage  # Verify 80%+ coverage achieved
```

## Coverage Requirements

**Minimum 80%** across branches, functions, lines, and statements.

**100% required** for:
- Financial calculations
- Authentication logic
- Security-critical code
- Core business logic

## Test Types

### Unit Tests (Required)

Test individual functions in isolation. Mock external dependencies.

### Integration Tests (Required)

Test API endpoints and database operations with realistic scenarios.

### E2E Tests (Critical Flows Only)

Test complete user journeys. See [E2E-GUIDELINES.md](E2E-GUIDELINES.md) for scope and best practices.

**Key principle**: Test UI behavior, not data content.

## Mocking and Edge Cases

- **Mocking patterns**: See [PATTERNS.md](PATTERNS.md) for database, cache, and API mocks
- **Edge cases**: See [EDGE-CASES.md](EDGE-CASES.md) for comprehensive checklist

## Anti-Patterns to Avoid

| Avoid | Do Instead |
|-------|------------|
| Testing internal state | Test user-visible behavior |
| Tests that depend on each other | Independent tests with own setup |
| Brittle CSS selectors | Semantic selectors (`data-testid`, button text) |
| Testing specific data content in E2E | Test UI behavior patterns |

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

## Troubleshooting

1. **Check test isolation** - ensure tests don't share state
2. **Verify mocks** - mock returns expected values
3. **Fix implementation, not tests** - unless tests are wrong
4. **Check async handling** - proper await/async usage

---

**Remember**: Tests are not optional. No code without tests.
