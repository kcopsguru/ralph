# Project Agent Instructions

This file provides instructions for AI agents working on this codebase. It works with Claude Code, Cursor, Amp, and other AI coding assistants.

## Skills

Skills are reusable workflows and guidelines. Agents should load relevant skills when working on specific tasks.

**Skill locations:**
- Claude Code: `.claude/skills/`
- Cursor: `.cursor/skills/`

| Skill | When to Use |
|-------|-------------|
| `coding` | Writing, reviewing, or refactoring code |
| `tdd` | Implementing features, fixing bugs, adding tests |

**Ralph-specific skills** (for autonomous workflows):
| Skill | When to Use |
|-------|-------------|
| `prd` | Creating a Product Requirements Document |
| `ralph` | Converting PRD to prd.json for Ralph execution |
| `code-review` | Reviewing completed work against requirements |

Agents auto-detect relevant skills based on the task, or you can reference them by name.

## Project Context

Before starting work, read these files to understand the project:

| File | Purpose |
|------|---------|
| `README.md` | Project overview, setup, and available commands |
| `docs/` | Additional documentation (if exists) |
| `package.json` / `Makefile` / `pyproject.toml` | Available scripts and dependencies |
| `.env.example` | Required environment variables |

Discover quality check commands from CI config (`.github/workflows/`) or package manager scripts.

## Development Guidelines

Load the `coding` skill for code quality standards and the `tdd` skill for testing requirements.

For git workflow, follow the project's existing conventions (check recent commit history with `git log --oneline -20`).

## Success Criteria

Work is complete when:
- All quality checks pass (lint, typecheck, build, test)
- Code follows existing patterns in the codebase
- Changes are focused and minimal
