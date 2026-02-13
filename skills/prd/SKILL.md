---
name: prd
description: "Generate a Product Requirements Document (PRD) for a new feature. Use when planning a feature, starting a new project, or when asked to create a PRD. Triggers on: create a prd, write prd for, plan this feature, requirements for, spec out."
disable-model-invocation: true
---

# PRD Generator

Create detailed Product Requirements Documents that are clear, actionable, and suitable for implementation.

---

## The Job

1. Receive a feature description from the user
2. Ask 3-5 essential clarifying questions (with lettered options)
3. Generate a structured PRD based on answers
4. Save to `tasks/prd-[feature-name].md`

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

**Format:**
```markdown
### US-001: [Title]
**Description:** As a [user], I want [feature] so that [benefit].

**Acceptance Criteria:**
- [ ] Specific verifiable criterion
- [ ] Another criterion
- [ ] **[UI stories only]** Write e2e test scripts using /agent-browser skill
- [ ] All checks pass: `[discovered check command]`
```

**Important:**
- When writing acceptance criteria, only include deliverables the user explicitly requested. If you believe additional deliverables are needed (scripts, documentation, tooling), ask the user first—do not add them to the PRD.
- Acceptance criteria must be verifiable, not vague. "Works correctly" is bad. "Button shows confirmation dialog before deleting" is good.
- **For any story with UI changes:** Always include "Write e2e test scripts using /agent-browser skill" as acceptance criteria. This ensures visual verification of frontend work.
- **Use project-specific checks:** Discover what checks the project actually uses and include the exact command. See "Discovering Project Checks" below.
- **NEVER use arbitrary numeric targets** like "reduce to X lines" or "under X KB" as acceptance criteria to avoid over-optimization. Instead, describe the *functional outcome* you want (e.g., "Remove X, Y, Z logic from source file" rather than "Reduce to under 50 lines").
- **Each acceptance criterion should have only one possible interpretation:** If two developers could reasonably implement an AC differently, it's too ambiguous. For example, use specific verbs (add, remove, change, replace) instead of "update".

### Discovering Project Checks

Before writing acceptance criteria, discover what automated checks the project uses. Do NOT use generic "typecheck passes" - use the actual commands.

**Where to look (in priority order):**

1. **CI Configuration** - If a project has CI, it likely runs comprehensive checks. Prefer using the same commands CI uses:
   - `.github/workflows/*.yml` - Look for `run:` commands
   - `.gitlab-ci.yml`, `Jenkinsfile`, `.circleci/config.yml`

2. **Package Manager Scripts:**
   - `package.json` scripts (Node.js)
   - `Makefile` targets (Go, Python, C)
   - `pyproject.toml` (Python)
   - `Cargo.toml` (Rust)

3. **Common script names to look for:**
   - Combined checks (prefer these!): `check`, `ci`, `validate`, `verify`
   - Individual: `typecheck`, `lint`, `build`, `test`, `test:e2e`

**Selecting the right check command:**

1. If there's a `check`, `ci`, or `validate` script that runs everything → use that single command
2. If CI config has comprehensive commands → use those exact commands
3. Otherwise → combine relevant scripts: `npm run lint && npm run build && npm test`
4. If nothing found → ask the user what checks should pass

**Example:** For a project with `"check": "npm run lint && npm run build && npm run test"` in package.json, acceptance criteria should use `npm run check`.

### 4. Functional Requirements
Numbered list of specific functionalities:
- "FR-1: The system must allow users to..."
- "FR-2: When a user clicks X, the system must..."

Be explicit and unambiguous.

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

## Example PRD

```markdown
# PRD: Task Priority System

## Introduction

Add priority levels to tasks so users can focus on what matters most. Tasks can be marked as high, medium, or low priority, with visual indicators and filtering to help users manage their workload effectively.

## Goals

- Allow assigning priority (high/medium/low) to any task
- Provide clear visual differentiation between priority levels
- Enable filtering and sorting by priority
- Default new tasks to medium priority

## User Stories

### US-001: Add priority field to database
**Description:** As a developer, I need to store task priority so it persists across sessions.

**Acceptance Criteria:**
- [ ] Add priority column to tasks table: 'high' | 'medium' | 'low' (default 'medium')
- [ ] Generate and run migration successfully
- [ ] All checks pass: `npm run ci`

### US-002: Display priority indicator on task cards
**Description:** As a user, I want to see task priority at a glance so I know what needs attention first.

**Acceptance Criteria:**
- [ ] Each task card shows colored priority badge (red=high, yellow=medium, gray=low)
- [ ] Priority visible without hovering or clicking
- [ ] Write e2e test scripts using /agent-browser skill
- [ ] All checks pass: `npm run ci`

### US-003: Add priority selector to task edit
**Description:** As a user, I want to change a task's priority when editing it.

**Acceptance Criteria:**
- [ ] Priority dropdown in task edit modal
- [ ] Shows current priority as selected
- [ ] Saves immediately on selection change
- [ ] Write e2e test scripts using /agent-browser skill
- [ ] All checks pass: `npm run ci`

### US-004: Filter tasks by priority
**Description:** As a user, I want to filter the task list to see only high-priority items when I'm focused.

**Acceptance Criteria:**
- [ ] Filter dropdown with options: All | High | Medium | Low
- [ ] Filter persists in URL params
- [ ] Empty state message when no tasks match filter
- [ ] Write e2e test scripts using /agent-browser skill
- [ ] All checks pass: `npm run ci`

## Functional Requirements

- FR-1: Add `priority` field to tasks table ('high' | 'medium' | 'low', default 'medium')
- FR-2: Display colored priority badge on each task card
- FR-3: Include priority selector in task edit modal
- FR-4: Add priority filter dropdown to task list header
- FR-5: Sort by priority within each status column (high to medium to low)

## Non-Goals

- No priority-based notifications or reminders
- No automatic priority assignment based on due date
- No priority inheritance for subtasks

## Technical Considerations

- Reuse existing badge component with color variants
- Filter state managed via URL search params
- Priority stored in database, not computed
- **Project checks:** `npm run ci` (discovered from package.json - runs lint, build, and test)

## Success Metrics

- Users can change priority in under 2 clicks
- High-priority tasks immediately visible at top of lists
- No regression in task list performance

## Open Questions

- Should priority affect task ordering within a column?
- Should we add keyboard shortcuts for priority changes?
```

---

## Checklist

Before saving the PRD:

- [ ] Asked clarifying questions with lettered options
- [ ] Incorporated user's answers
- [ ] User stories are small and specific
- [ ] Acceptance criteria use project-specific check commands
- [ ] Functional requirements are numbered and unambiguous
- [ ] Non-goals section defines clear boundaries
- [ ] Documentation updates section included (or user story for docs)
- [ ] PRD content precisely matches to user's requirements, nothing more, nothing less
- [ ] Saved to `tasks/prd-[feature-name].md`
