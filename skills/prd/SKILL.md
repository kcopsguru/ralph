---
name: prd
description: "Generate a Product Requirements Document (PRD) for a new feature. Use when planning a feature, starting a new project, or when asked to create a PRD. Triggers on: create a prd, write prd for, plan this feature, requirements for, spec out."
disable-model-invocation: true
---

# PRD Generator

Create detailed Product Requirements Documents that are clear, actionable, and suitable for implementation.

## Contents

- [Workflow](#workflow)
- [Clarifying Questions](#step-1-clarifying-questions)
- [PRD Structure](#step-2-prd-structure)
- [Discovering Project Checks](#discovering-project-checks)
- [Final Verification](#final-verification)
- [Example PRD](examples/priority-system.md)

---

## Workflow

Copy this checklist and track progress:

```
PRD Progress:
- [ ] Step 1: Ask clarifying questions (with lettered options)
- [ ] Step 2: Discover project checks (categorize fast vs slow)
- [ ] Step 3: Generate PRD with all sections
- [ ] Step 4: Save to tasks/prd-[feature-name].md
```

**Important:** Do NOT start implementing. Just create the PRD.

---

## Step 1: Clarifying Questions

Ask only critical questions where the initial prompt is ambiguous. Focus on:

- **Problem/Goal:** What problem does this solve?
- **Core Functionality:** What are the key actions?
- **Scope/Boundaries:** What should it NOT do?
- **Success Criteria:** How do we know it's done?

### Format Questions Like This:

```
1. What is the primary goal of this feature?
   A. Improve user onboarding experience
   B. Increase user retention
   C. Reduce support burden
   D. Other: [please specify]

2. Who is the target user?
   A. New users only
   B. Existing users only
   C. All users
   D. Admin users only

3. What is the scope?
   A. Minimal viable version
   B. Full-featured implementation
   C. Just the backend/API
   D. Just the UI
```

This lets users respond with "1A, 2C, 3B" for quick iteration.

---

## Step 2: PRD Structure

Generate the PRD with these sections:

### 1. Introduction/Overview
Brief description of the feature and the problem it solves.

### 2. Goals
Specific, measurable objectives (bullet list).

### 3. User Stories
Each story needs:
- **Title:** Short descriptive name
- **Description:** "As a [user], I want [feature] so that [benefit]"
- **Acceptance Criteria:** Verifiable checklist of what "done" means

Each story should be small enough to implement in one focused session.

**Format for implementation stories:**
```markdown
### US-001: [Title]
**Description:** As a [user], I want [feature] so that [benefit].

**Acceptance Criteria:**
- [ ] Specific verifiable criterion
- [ ] Another criterion
- [ ] **[UI stories only]** Write e2e test scripts using /agent-browser skill
- [ ] All checks pass: `[fast check command]`
```

**Format for final story (always include as the last story):**
```markdown
### US-XXX: Final Verification and Documentation
**Description:** As a developer, I want to verify all features work together and update documentation before merging.

**Acceptance Criteria:**
- [ ] Add any missing e2e tests for new functionality (if project has e2e)
- [ ] All checks pass: `[full check command]`
- [ ] Documentation updated (README, API docs, etc.)
```

**Important:**
- When writing acceptance criteria, only include deliverables the user explicitly requested. If you believe additional deliverables are needed (scripts, documentation, tooling), ask the user first—do not add them to the PRD.
- Acceptance criteria must be verifiable, not vague. "Works correctly" is bad. "Button shows confirmation dialog before deleting" is good.
- Acceptance criteria should focus on functional behaviors, not implementation details. **Do not specify exact UI text/copy** (e.g., error messages, button labels, placeholder text)—these are implementation details that lead to brittle tests. Instead, describe the behavior: "Display a user-friendly error message" not "Display error message 'Something went wrong'".
- **For any story with UI changes:** Always include "Write e2e test scripts using /agent-browser skill" as acceptance criteria. Write and verify the new e2e test works, but don't run the full e2e suite—that happens in the final story.
- **Use fast checks for implementation stories:** Run lint, typecheck, build, and unit tests on every story to maintain TDD discipline. See "Discovering Project Checks" below.
- **Always add a final verification story:** Add a dedicated user story at the END of the story list. This story runs all checks (including e2e if the project has them), adds any missing e2e tests, and updates documentation before merge.
- **NEVER use arbitrary numeric targets** like "reduce to X lines" or "under X KB" as acceptance criteria to avoid over-optimization. Instead, describe the *functional outcome* you want (e.g., "Remove X, Y, Z logic from source file" rather than "Reduce to under 50 lines").
- **Each acceptance criterion should have only one possible interpretation:** If two developers could reasonably implement an AC differently, it's too ambiguous. For example, use specific verbs (add, remove, change, replace) instead of "update".

### Discovering Project Checks

Before writing acceptance criteria, discover what automated checks the project uses and categorize them by execution time. This ensures fast iteration during development while maintaining full test coverage.

**Where to look:** CI config first (`.github/workflows/*.yml`), then package manager scripts (`package.json`, `Makefile`, etc.). Look for combined scripts like `check`, `ci`, `validate` that run everything.

**Categorizing checks by speed:**

Classify discovered checks into two categories:

| Category | Examples | When to Run |
|----------|----------|-------------|
| **Fast checks** | `lint`, `typecheck`, `build`, `test` (unit tests) | Every user story |
| **Slow checks** | `test:e2e`, `test:integration`, `cypress`, `playwright`, `e2e`, `integration` | Final story only |

**How to identify slow checks:**
- Script names containing: `e2e`, `integration`, `cypress`, `playwright`, `selenium`, `puppeteer`
- Scripts that launch browsers or external services
- Scripts with significantly longer timeouts in CI config
- Any test that requires a running server or database setup

**Constructing the check commands:**

1. **Fast check command** - Combine lint, typecheck, build, and unit tests:
   - If project has `check:fast` or similar → use that
   - Otherwise → combine: `npm run lint && npm run build && npm test` (excluding e2e)
   - For Go: `go vet ./... && go build ./... && go test ./...`
   - For Python: `ruff check . && pytest -m "not e2e"`

2. **Full check command** - Include everything (fast + slow):
   - If project has `check`, `ci`, or `validate` that runs all → use that
   - Otherwise → combine all: `npm run lint && npm run build && npm test && npm run test:e2e`

3. If nothing found → ask the user what checks should pass

**Example classification:**

For a project with these scripts in package.json:
```json
{
  "scripts": {
    "lint": "eslint .",
    "build": "tsc",
    "test": "vitest",
    "test:e2e": "playwright test",
    "check": "npm run lint && npm run build && npm test && npm run test:e2e"
  }
}
```

- **Fast checks:** `npm run lint && npm run build && npm test`
- **Full checks:** `npm run check`

Use fast checks in each implementation story. Use full checks in the final e2e story.

### 4. Functional Requirements
Numbered list of specific functionalities:
- "FR-1: The system must allow users to..."
- "FR-2: When a user clicks X, the system must..."

Be explicit and unambiguous, but avoid specifying exact UI copy (error messages, labels, etc.). Describe the behavior, not the exact text.

### 5. Non-Goals (Out of Scope)
What this feature will NOT include. Critical for managing scope.

### 6. Design Considerations (Optional)
- UI/UX requirements
- Link to mockups if available
- Relevant existing components to reuse

### 7. Technical Considerations (Optional)
- Known constraints or dependencies
- Integration points with existing systems
- Performance requirements

### 8. Success Metrics
How will success be measured?
- "Reduce time to complete X by 50%"
- "Increase conversion rate by 10%"

### 9. Documentation Updates
Identify what documentation needs to be updated:
- README.md changes (new features, usage examples, CLI flags)
- API docs, inline comments, or other relevant docs

**Important:** Always include a user story for documentation updates when the feature changes user-facing behavior, APIs, or commands.

### 10. Open Questions
Remaining questions or areas needing clarification.

---

## Writing for Junior Developers

The PRD reader may be a junior developer or AI agent. Therefore:

- Be explicit and unambiguous
- Avoid jargon or explain it
- Provide enough detail to understand purpose and core logic
- Number requirements for easy reference
- Use concrete examples where helpful

---

## Output

- **Format:** Markdown (`.md`)
- **Location:** `tasks/`
- **Filename:** `prd-[feature-name].md` (kebab-case)

---

---

## Final Verification

Before saving, verify:

- [ ] User stories are small (completable in one focused session)
- [ ] Implementation stories use fast checks only (no e2e)
- [ ] Final verification story added as the last story
- [ ] Functional requirements are numbered and unambiguous
- [ ] Non-goals section defines clear boundaries
- [ ] Documentation updates included (if feature changes user-facing behavior)
- [ ] PRD matches user's requirements—nothing more, nothing less

---

## Example PRD

See [examples/priority-system.md](examples/priority-system.md) for a complete example demonstrating all sections, user story format, and check categorization.
