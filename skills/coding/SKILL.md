---
name: coding
description: Senior software development skill with expertise in Test-Driven Development (TDD) and Clean Code principles. Enforces coding standards and best practices for clean, maintainable code. Use when writing, reviewing, or refactoring code.
disable-model-invocation: true
---

## Coding Standards

### Test-Driven Development (TDD)
1. **Red** - Write a failing test first
2. **Green** - Write minimal code to make it pass
3. **Refactor** - Clean up while keeping tests green

### Clean Code (Robert C. Martin)
- **Meaningful Names** - Variables, functions, classes should reveal intent
- **Small Functions** - Do one thing, do it well
- **DRY** - Don't Repeat Yourself
- **SOLID Principles** - Single responsibility, Open/closed, Liskov substitution, Interface segregation, Dependency inversion
- **Comments** - Code should be self-documenting; comments explain "why", not "what"

### Your Standards
- **Coding Style** - Perfer functional over imperative, less code is better, DO NOT OVERENGINEER!!!
- **Maintainability** - High cohesion, low coupling,
- **Edge Cases** - Always consider boundary conditions, null/undefined, empty collections
- **Security** - Validate inputs, sanitize outputs, principle of least privilege
- **Scalability** - Consider performance implications, avoid N+1 queries, think about concurrent access
- **Pragmatism** - Perfect is the enemy of good; ship working code

## File Organization

- 200-400 lines typical, 800 max
- Organize by feature/domain, not by type

## Pre-Implementation Checklist

Before writing new code:

- [ ] Check for existing configuration patterns (environment files, config services)
- [ ] Check how similar features handle the same concern (API URLs, constants, state management)
- [ ] Don't introduce new patterns when established ones exist
- [ ] Scan for existing utilities that solve the same problem

## Code Quality Checklist

Before completing work:

- [ ] Functions < 100 lines
- [ ] Files < 800 lines
- [ ] No nesting > 4 levels (use early returns)
- [ ] No magic numbers (use named constants)
- [ ] No hardcoded values (use environment config for URLs, API keys, etc.)
- [ ] Errors handled with context
- [ ] Input validated at boundaries

## Error Handling

- Fail fast at system boundaries
- Catch specific errors, not generic
- Add context when re-throwing
- Log details internally, return safe messages externally
- Never swallow errors silently

## Comments

- Do not reference user story IDs (i.e. this logic is intended for US-001)

## Language & Framework Guidelines

| Language/Framework | File |
|--------------------|------|
| TypeScript, JavaScript | [typescript-javascript.md](typescript-javascript.md) |
| React | [react.md](react.md) |

For testing patterns, see the `tdd` skill.
