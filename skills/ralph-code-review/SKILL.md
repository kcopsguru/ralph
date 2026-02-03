---
name: ralph-code-review
description: "Review code changes against PRD requirements and add fix stories to prd.json. Use when feature implementation is complete and needs review. Triggers on: review code, ralph code review, check implementation, validate against prd."
---

# Ralph Code Review

Review code changes on a feature branch against PRD requirements. Identify issues and add them as new stories to `.ralph/prd.json`.

## Workflow

1. **Gather references** - Read files listed below
2. **Verify branch** - See [references/branch-verification.md](references/branch-verification.md)
3. **Run automated checks** - See [references/automated-checks.md](references/automated-checks.md)
4. **Review code** - See [references/review-process.md](references/review-process.md) (skip if checks failed)
5. **Convert issues to stories** - See [references/story-format.md](references/story-format.md)
6. **Interactive review** - See [references/interactive-review.md](references/interactive-review.md)
7. **Update prd.json** - Append confirmed stories, never modify existing ones

## Step 1: Gather Reference Files

Read these files before reviewing:

| File | Purpose |
|------|---------|
| `.ralph/prd.json` | User stories and acceptance criteria |
| Original PRD (from `reference` field) | Detailed requirements context |
| `README.md` | Project conventions |
| `docs/` folder (if exists) | Additional documentation |

If no `docs/` folder exists, ask:
```
No docs/ folder found. Are there additional documentation files I should review?
Type paths or "none" to proceed.
```

## Steps 2-7: Execute Workflow

Follow the reference files in order. Key decision points:

- **After Step 3**: If automated checks fail → skip Step 4, go directly to Step 5
- **After Step 6**: User confirms, modifies, or dismisses each issue
- **Step 7 rules**: Append only, sequential IDs, preserve existing fields, never modify original PRD

## Completion

```
## Code Review Complete

Added N stories to .ralph/prd.json:
- US-011: [FIX] ... (Critical)
- US-012: [QUALITY] ... (Major)

## Next Steps
1. Run developer agent loop to fix new stories
2. Run /ralph-code-review again
3. Repeat until no issues remain
```

**Exit conditions**:
- No issues found → feature ready to merge
- Issues added to `.ralph/prd.json` → run Ralph to fix, then review again
