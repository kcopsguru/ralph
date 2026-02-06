---
name: coding
description: Enforces coding standards and best practices for clean, maintainable code. Use when writing, reviewing, or refactoring code.
---

# Coding Standards

## Core Principles

Apply KISS, DRY, and YAGNI. Prioritize readability over cleverness.

## File Organization

- 200-400 lines typical, 800 max
- Organize by feature/domain, not by type
- High cohesion, low coupling

## Code Quality Checklist

Before completing work:

- [ ] Functions < 50 lines
- [ ] Files < 800 lines
- [ ] No nesting > 4 levels (use early returns)
- [ ] No magic numbers (use named constants)
- [ ] No hardcoded values
- [ ] Errors handled with context
- [ ] Input validated at boundaries

## Error Handling

- Fail fast at system boundaries
- Catch specific errors, not generic
- Add context when re-throwing
- Log details internally, return safe messages externally
- Never swallow errors silently

## Comments

- Comment the **why**, not the **what**. Prefer self-documenting code.
- Do not reference user story IDs (i.e. this logic is intended for US-001)

## Language & Framework Guidelines

| Language/Framework | File |
|--------------------|------|
| TypeScript, JavaScript | [typescript-javascript.md](typescript-javascript.md) |
| React | [react.md](react.md) |

For testing patterns, see the `tdd` skill.
