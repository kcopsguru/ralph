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

**Prerequisite:** Automated checks passed (Step 3) and changed files identified (Step 4).

Review each changed file against the PRD requirements and code quality standards. Identify issues and categorize them for the interactive review.

### Issue Categories

Issues fall into three categories:

#### 1. Automated Check Failures

Build, test, lint, or typecheck failures caught in Step 3.

- **Always critical** - highest priority
- Build errors that prevent compilation
- Test failures
- Lint errors (when configured to error)
- Typecheck failures

> **Note:** If automated checks failed, you should have already handled them in Step 3 and not reached this step. This category is listed for completeness and for documenting any issues discovered during manual review that would cause automated checks to fail.

#### 2. Requirements Deviations

Implementation doesn't match PRD requirements or acceptance criteria.

- Acceptance criteria not fully met
- Missing functionality described in PRD
- Behavior differs from specification
- Edge cases not handled per requirements
- UI/UX doesn't match design requirements

#### 3. Code Quality Issues

Code works but violates quality standards.

- **DRY violations** - duplicated code that should be extracted
- **Overengineering** - unnecessary abstractions, premature optimization
- **Unnecessary code** - dead code, unused imports, commented-out code
- **High complexity** - functions too long, deeply nested logic
- **Unclear naming** - variables/functions that don't convey intent
- **Missing error handling** - unhanded edge cases, missing try/catch
- **Inconsistent patterns** - doesn't follow existing codebase conventions

### Severity Levels

Assign one of three severity levels to each issue:

| Severity | Description | Examples |
|----------|-------------|----------|
| **Critical** | Blocks functionality or fails automated checks | Build fails, tests fail, core feature broken, security vulnerability |
| **Major** | Significant quality issue that should be fixed | DRY violation affecting multiple files, missing error handling for user input, acceptance criteria partially met |
| **Minor** | Improvement opportunity, not blocking | Naming could be clearer, minor code smell, documentation missing |

### Priority Order

When identifying issues, prioritize in this order:

1. **Automated check failures** (always critical, highest priority)
2. **Other critical issues** (blocking functionality)
3. **Major issues** (significant quality problems)
4. **Minor issues** (improvement opportunities)

This ensures the most important issues are addressed first in subsequent dev loop iterations.

### Issue Identification Process

For each changed file:

1. **Compare against acceptance criteria** - Does the code satisfy each criterion for related stories?
2. **Check for requirements deviations** - Does behavior match PRD specification?
3. **Review code quality** - Are there DRY violations, overengineering, or unnecessary code?
4. **Note severity** - Is this critical, major, or minor?

### Examples

#### Example: Critical - Automated Check Failure

```
Category: Automated Check Failure
Severity: Critical
File: src/utils/parser.ts
Issue: TypeScript error - Property 'parse' does not exist on type 'undefined'
Related Story: US-005
```

#### Example: Critical - Requirements Deviation

```
Category: Requirements Deviation
Severity: Critical
File: src/components/LoginForm.tsx
Issue: Login form missing email validation per AC #3 of US-002
  "Form validates email format before submission"
Related Story: US-002, AC #3
```

#### Example: Major - Code Quality Issue

```
Category: Code Quality Issue
Severity: Major
File: src/api/users.ts, src/api/posts.ts
Issue: DRY violation - identical error handling logic duplicated in 5 API functions
  Consider extracting to shared handleApiError() utility
Related Story: N/A (code quality)
```

#### Example: Major - Requirements Deviation

```
Category: Requirements Deviation
Severity: Major
File: src/pages/Dashboard.tsx
Issue: Dashboard shows all items but PRD specifies pagination with 20 items per page
  "Display results with pagination (20 per page)" - US-007 AC #2
Related Story: US-007, AC #2
```

#### Example: Minor - Code Quality Issue

```
Category: Code Quality Issue
Severity: Minor
File: src/helpers/format.ts
Issue: Function 'doThing' has unclear naming - consider 'formatCurrency' or similar
Related Story: N/A (code quality)
```

#### Example: Minor - Code Quality Issue

```
Category: Code Quality Issue
Severity: Minor
File: src/components/Header.tsx
Issue: Unused import 'useState' - dead code
Related Story: N/A (code quality)
```

### Issue Documentation Format

Document each identified issue with:

```
Category: [Automated Check Failure | Requirements Deviation | Code Quality Issue]
Severity: [Critical | Major | Minor]
File: [path/to/file.ts]
Issue: [Clear description of the problem]
Related Story: [US-XXX, AC #N or N/A]
```

### Review and Identify Issues Checklist

- [ ] Reviewed each changed file from Step 4
- [ ] Compared implementation against acceptance criteria
- [ ] Checked for requirements deviations from PRD
- [ ] Identified code quality issues (DRY, overengineering, unnecessary code)
- [ ] Assigned severity to each issue (critical, major, minor)
- [ ] Documented issues in standard format
- [ ] Ready to proceed to Step 6 (Convert Issues to Stories)

---

## Step 6: Convert Issues to Stories

After the user confirms issues in Step 7 (Interactive Review), convert each confirmed issue into a new user story in `.ralph/prd.json` format.

### Story ID Sequencing

New story IDs continue from the existing sequence:

1. Find the last story ID in `.ralph/prd.json` (e.g., `US-010`)
2. Extract the numeric portion (e.g., `10`)
3. Increment for each new story (e.g., `US-011`, `US-012`, `US-013`)

Example:
```bash
# If .ralph/prd.json has stories US-001 through US-010
# New issues become: US-011, US-012, US-013, ...
```

### Story Title Format

Use issue type prefixes in story titles:

| Issue Category | Prefix | Example |
|---------------|--------|---------|
| Automated Check Failure | `[FIX]` | `[FIX] Resolve typecheck errors in parser.ts` |
| Requirements Deviation | `[FIX]` | `[FIX] Add email validation to login form` |
| Code Quality Issue | `[QUALITY]` | `[QUALITY] Extract duplicate error handling logic` |

### Story Format

Each confirmed issue becomes a story with this structure:

```json
{
  "id": "US-011",
  "title": "[FIX] Add email validation to login form",
  "description": "As a developer, I need to fix the login form to validate email format per the original requirements.",
  "acceptanceCriteria": [
    "Form validates email format before submission (See US-002 AC #3)",
    "Invalid email displays clear error message",
    "Form submission is blocked until email is valid"
  ],
  "priority": 1,
  "passes": false,
  "notes": ""
}
```

### Acceptance Criteria Guidelines

Acceptance criteria can:

1. **Reference existing criteria** - When the issue is about unmet requirements:
   ```
   "Form validates email format before submission (See US-002 AC #3)"
   ```

2. **Define new criteria** - When the issue is about code quality or new requirements:
   ```
   "Extract error handling to shared handleApiError() utility"
   "All API functions use the shared utility"
   "No duplicate try/catch blocks remain"
   ```

3. **Mix both approaches** - Reference what was missed, add specific fix criteria:
   ```
   "Implement pagination with 20 items per page (See US-007 AC #2)"
   "Add page navigation controls"
   "Display current page and total pages"
   ```

### Priority Assignment

Priority determines the order stories are worked on. Lower numbers = higher priority.

| Issue Severity | Priority Assignment |
|---------------|---------------------|
| Critical (automated check failures) | Lowest available numbers (run first) |
| Critical (other blocking issues) | Next lowest numbers |
| Major | Middle numbers |
| Minor | Highest numbers (run last) |

Example with 3 issues (starting after US-010):
- Critical typecheck failure → US-011, priority: 1
- Major DRY violation → US-012, priority: 2  
- Minor naming issue → US-013, priority: 3

### Complete Story Examples

#### Example: Critical - Automated Check Failure

```json
{
  "id": "US-011",
  "title": "[FIX] Resolve typecheck errors in src/utils/parser.ts",
  "description": "As a developer, I need to fix type errors so the build passes.",
  "acceptanceCriteria": [
    "Fix: Property 'parse' does not exist on type 'undefined' (line 45)",
    "Fix: Argument of type 'string' is not assignable to 'number' (line 72)",
    "npm run typecheck passes with no errors"
  ],
  "priority": 1,
  "passes": false,
  "notes": ""
}
```

#### Example: Critical - Requirements Deviation

```json
{
  "id": "US-012",
  "title": "[FIX] Add email validation to LoginForm",
  "description": "As a developer, I need to implement the missing email validation per US-002 requirements.",
  "acceptanceCriteria": [
    "Form validates email format before submission (See US-002 AC #3)",
    "Invalid email displays error: 'Please enter a valid email address'",
    "Submit button is disabled until email format is valid"
  ],
  "priority": 2,
  "passes": false,
  "notes": ""
}
```

#### Example: Major - Code Quality Issue

```json
{
  "id": "US-013",
  "title": "[QUALITY] Extract duplicate API error handling",
  "description": "As a developer, I need to consolidate duplicate error handling code to improve maintainability.",
  "acceptanceCriteria": [
    "Create shared handleApiError() utility in src/utils/api.ts",
    "Refactor all 5 API functions to use the shared utility",
    "Remove duplicate try/catch blocks from individual functions",
    "Error behavior remains identical (no functional changes)"
  ],
  "priority": 3,
  "passes": false,
  "notes": ""
}
```

#### Example: Minor - Code Quality Issue

```json
{
  "id": "US-014",
  "title": "[QUALITY] Rename unclear function 'doThing'",
  "description": "As a developer, I need clearer function naming to improve code readability.",
  "acceptanceCriteria": [
    "Rename 'doThing' to 'formatCurrency' in src/helpers/format.ts",
    "Update all call sites to use new function name",
    "Add JSDoc comment explaining the function's purpose"
  ],
  "priority": 4,
  "passes": false,
  "notes": ""
}
```

### Required Story Fields

All new stories MUST have:

| Field | Required Value |
|-------|---------------|
| `id` | Sequential from last existing (e.g., US-011) |
| `title` | Prefixed with `[FIX]` or `[QUALITY]` |
| `description` | "As a developer, I need to..." format |
| `acceptanceCriteria` | Array with specific, verifiable criteria |
| `priority` | Number based on severity (lower = higher priority) |
| `passes` | `false` (always) |
| `notes` | `""` (always empty) |

### Convert Issues to Stories Checklist

- [ ] Determined next story ID from existing sequence
- [ ] Used appropriate prefix (`[FIX]` or `[QUALITY]`) in title
- [ ] Wrote clear description in "As a developer..." format
- [ ] Created specific, verifiable acceptance criteria
- [ ] Referenced existing ACs where applicable (e.g., "See US-003 AC #2")
- [ ] Assigned priority based on severity (critical first, then major, then minor)
- [ ] Set `passes: false` and `notes: ""`
- [ ] Ready to proceed to Step 7 (Interactive Review)

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
