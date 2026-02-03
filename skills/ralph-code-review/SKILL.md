---
name: ralph-code-review
description: "Review code changes against PRD requirements and add fix stories to prd.json. Use when feature implementation is complete and needs review. Triggers on: review code, ralph code review, check implementation, validate against prd."
disable-model-invocation: true
---

# Ralph Code Review

Review all code changes on a feature branch against PRD requirements and project documentation. Identify issues and add them as new user stories to `.ralph/prd.json`.

---

## The Job

1. Gather reference documentation
2. Verify branch setup
3. Run automated checks
4. Identify code changes
5. Review changes against requirements
6. Present issues interactively
7. Add confirmed issues as stories to `.ralph/prd.json`

---

## Step 1: Gather Reference Files

Gather all relevant documentation before starting the review. This provides context for validating implementation against requirements.

### Required Files

1. **`.ralph/prd.json`** - Read for user stories and acceptance criteria
   - Contains the structured list of stories to validate against
   - Each story has `acceptanceCriteria` that must be verified

2. **Original PRD** - Read from the `reference` field in `.ralph/prd.json`
   - Example: if `"reference": "tasks/prd-my-feature.md"`, read that file
   - Provides detailed context, goals, and functional requirements

### Optional Files

3. **`README.md`** - Read if present in project root
   - Provides project context and existing conventions

4. **`docs/` folder** - Check if exists in project root
   - If present, scan for relevant documentation files
   - Read files that may inform the review (architecture, API docs, etc.)

### If No docs/ Folder

If the `docs/` folder doesn't exist, prompt the user:

```
No docs/ folder found. Are there additional documentation files 
I should review for context?

Please provide paths to any relevant documentation, or type 
"none" to proceed with .ralph/prd.json and README.md only.
```

### Reference Files Checklist

- [ ] Read `.ralph/prd.json`
- [ ] Read original PRD from `reference` field
- [ ] Read `README.md` if present
- [ ] Check for `docs/` folder and read relevant files
- [ ] If no `docs/` folder, ask user for additional documentation paths

---

## Step 2: Verify Branch

Before reviewing code, verify you're on the correct feature branch. Code review should never run on `main`.

### Verification Steps

1. **Verify not on main branch**
   ```bash
   git branch --show-current
   ```
   If the result is `main` or `master`, stop with error:
   ```
   ERROR: Cannot run code review on main branch.
   Please checkout your feature branch first.
   ```

2. **Verify branch matches `.ralph/.last-branch`**
   ```bash
   # Read .ralph/.last-branch content
   cat .ralph/.last-branch
   # Compare with current branch
   git branch --show-current
   ```
   If they differ, stop with error:
   ```
   ERROR: Branch mismatch.
   Current branch: [current]
   Expected branch (.ralph/.last-branch): [expected]
   
   Please checkout the correct branch or update .ralph/.last-branch.
   ```

3. **Verify branch matches `branchName` in `.ralph/prd.json`**
   ```bash
   # Get branchName from prd.json (using jq or parse manually)
   jq -r '.branchName' .ralph/prd.json
   # Compare with current branch
   git branch --show-current
   ```
   If they differ, stop with error:
   ```
   ERROR: Branch mismatch.
   Current branch: [current]
   Expected branch (prd.json branchName): [expected]
   
   Please checkout the correct branch or update .ralph/prd.json.
   ```

### Why This Matters

- Prevents accidentally reviewing code on `main` (which has no feature changes)
- Ensures consistency between Ralph's state files and git state
- Catches configuration drift early before wasting time on a wrong-branch review

### Branch Verification Checklist

- [ ] Not on `main` or `master` branch
- [ ] Current branch matches `.ralph/.last-branch`
- [ ] Current branch matches `branchName` in `.ralph/prd.json`
- [ ] All three values are consistent

---

## Step 3: Run Automated Checks

<!-- TODO: Document automated checks execution (US-004) -->

---

## Step 4: Identify Changed Files

<!-- TODO: Document git diff for code review scope (US-005) -->

---

## Step 5: Review and Identify Issues

<!-- TODO: Document issue identification process (US-006) -->

---

## Step 6: Convert Issues to Stories

<!-- TODO: Document issue-to-story conversion format (US-007) -->

---

## Step 7: Interactive Review

<!-- TODO: Document interactive review workflow (US-008) -->

---

## Step 8: Update prd.json

<!-- TODO: Document prd.json modification rules (US-009) -->

---

## Step 9: Complete Review

<!-- TODO: Document review completion and re-invocation (US-010) -->

---

## Checklist

Before completing the review:

- [ ] Reference files gathered
- [ ] Branch verified
- [ ] Automated checks run
- [ ] Changed files identified
- [ ] Issues reviewed with user
- [ ] Stories added to `.ralph/prd.json`
