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

After branch verification passes, run the project's automated checks. **If any check fails, stop immediately** - do not proceed with manual code review.

### Detect Available Checks

Scan for project build tools and identify available scripts:

**1. Node.js projects (package.json)**
```bash
# Check for common scripts
cat package.json | jq '.scripts | keys[]' 2>/dev/null
```
Look for: `build`, `test`, `lint`, `typecheck`, `check`, `ci`

**2. Python projects**
- `Makefile` with targets like `test`, `lint`, `typecheck`
- `pyproject.toml` with tool configs (pytest, ruff, mypy)
- `setup.py` or `requirements.txt`

**3. Go projects**
```bash
go build ./...
go test ./...
go vet ./...
```

**4. Rust projects**
```bash
cargo build
cargo test
cargo clippy
```

### Run Checks in Order

Execute checks in this priority order (stop at first failure):

1. **Typecheck** - catches type errors early
2. **Lint** - catches code style and quality issues  
3. **Build** - ensures code compiles/bundles
4. **Test** - runs automated test suite

Example for Node.js project:
```bash
# Run in order, stop on failure
npm run typecheck && npm run lint && npm run build && npm test
```

### If Checks Pass

Proceed to Step 4 (Identify Changed Files) for manual code review.

### If Checks Fail

**Stop immediately.** Do NOT proceed with manual code review.

1. **Each failure is a critical issue** - automated check failures are always highest priority
2. **Create fix stories** for each distinct failure
3. **Prompt user** to run the developer agent loop to fix them first

Example prompt:
```
AUTOMATED CHECKS FAILED - Manual code review skipped.

The following checks failed:
- typecheck: 3 errors in src/utils.ts
- lint: 2 warnings treated as errors in src/App.tsx

I'll add these as critical fix stories to .ralph/prd.json.
After the developer agent loop fixes them, run /ralph-code-review again.

Proceed with adding fix stories? (yes/no)
```

### Fix Story Format for Check Failures

When adding fix stories for automated check failures:

```json
{
  "id": "US-012",
  "title": "[FIX] Resolve typecheck errors in src/utils.ts",
  "description": "As a developer, I need to fix type errors so the build passes.",
  "acceptanceCriteria": [
    "Fix type error: Property 'foo' does not exist on type 'Bar'",
    "Fix type error: Argument of type 'string' is not assignable to 'number'",
    "npm run typecheck passes with no errors"
  ],
  "priority": 1,
  "passes": false,
  "notes": "Critical: blocks all other work"
}
```

### Why Automated Checks Run First

- **Fail fast:** Catch objective failures before spending time on subjective review
- **Clear priority:** Automated failures are always more critical than code quality suggestions
- **Efficient workflow:** Don't waste time reviewing code that won't build or pass tests
- **Objective evidence:** No debate needed - the check passed or failed

### Handling Different Build Systems

| Project Type | Detection | Common Commands |
|-------------|-----------|-----------------|
| Node.js | `package.json` exists | `npm run typecheck`, `npm run lint`, `npm run build`, `npm test` |
| Python | `pyproject.toml`, `Makefile` | `make lint`, `make typecheck`, `pytest` |
| Go | `go.mod` exists | `go build ./...`, `go test ./...`, `go vet ./...` |
| Rust | `Cargo.toml` exists | `cargo build`, `cargo test`, `cargo clippy` |
| General | `Makefile` exists | `make check`, `make test`, `make lint` |

If no standard build system is detected, ask the user:
```
I couldn't detect your project's build system. What commands should I run 
for automated checks?

Example: npm run typecheck && npm run lint && npm test
```

### Automated Checks Checklist

- [ ] Detected project type and available scripts
- [ ] Ran typecheck (if available)
- [ ] Ran lint (if available)
- [ ] Ran build (if available)
- [ ] Ran tests (if available)
- [ ] If all pass: proceed to Step 4
- [ ] If any fail: stop, add fix stories, prompt user to run dev loop

---

## Step 4: Identify Changed Files

**Prerequisite:** This step only runs if automated checks pass (Step 3). If automated checks failed, you should have already added fix stories and prompted the user to run the dev loop.

Identify all code changes between the feature branch and `main` to scope the manual review. Only changed files are reviewed—not the entire codebase.

### Get Changed Files

Use `git diff` with the three-dot syntax to compare the feature branch against `main`:

```bash
# List all files changed between main and current HEAD
git diff --name-only main...HEAD
```

This shows files that have been added, modified, or deleted on the feature branch since it diverged from `main`.

### Get Detailed Changes

To see the actual code changes for review:

```bash
# Show full diff of all changes
git diff main...HEAD

# Show diff for a specific file
git diff main...HEAD -- path/to/file.ts

# Show diff with more context lines (useful for understanding changes)
git diff -U10 main...HEAD
```

### Understanding the Three-Dot Syntax

- **`main...HEAD`** compares the feature branch to where it diverged from `main`
- This is different from **`main..HEAD`** (two dots) which would include changes in `main` that aren't in your branch
- Three-dot syntax ensures you review only the feature branch changes, not unrelated `main` commits

### Filter by File Type

If the project is large, you may want to focus on specific file types:

```bash
# Only TypeScript/JavaScript files
git diff --name-only main...HEAD -- '*.ts' '*.tsx' '*.js' '*.jsx'

# Only Python files
git diff --name-only main...HEAD -- '*.py'

# Exclude test files for initial review
git diff --name-only main...HEAD | grep -v '__tests__\|\.test\.\|\.spec\.'
```

### Check for Uncommitted Changes

Before reviewing, ensure all changes are committed:

```bash
# Check for uncommitted changes
git status --porcelain
```

If there are uncommitted changes, prompt the user:
```
WARNING: You have uncommitted changes. These won't be included in the review.

Do you want to:
1. Commit changes first (recommended)
2. Continue reviewing only committed changes
3. Cancel and address uncommitted changes

Choose (1/2/3):
```

### Why Only Changed Files

- **Focused review:** Reviewing the entire codebase would be overwhelming and inefficient
- **Relevant context:** Only files touched by the feature need validation against the PRD
- **Efficient iterations:** Each review cycle focuses on what changed, not everything
- **Clear scope:** Git provides an objective, reproducible list of changes

### Changed Files Checklist

- [ ] Automated checks passed (Step 3)
- [ ] Retrieved list of changed files with `git diff --name-only main...HEAD`
- [ ] Verified no uncommitted changes (or user acknowledged them)
- [ ] Ready to proceed to Step 5 (Review and Identify Issues)

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
