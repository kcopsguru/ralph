---
name: prd
description: "Generates Product Requirements Documents (PRDs) for new features. Use when planning features, starting projects, or when users ask to create requirements, spec out functionality, or write a PRD."
disable-model-invocation: true
---

# PRD Generator

Create detailed Product Requirements Documents that are clear, actionable, and suitable for implementation.

## Contents

- [Workflow](#workflow)
- [Clarifying Questions](#step-1-clarifying-questions)
- [PRD Structure](#step-2-prd-structure)
- [Self-Review](#self-review)

**References:**
- [Example PRD](examples/priority-system.md)
- [Acceptance Criteria Guide](references/acceptance-criteria.md)
- [Project Checks Guide](references/project-checks.md)

---

## Workflow

Copy this checklist and track progress:

```
PRD Progress:
- [ ] Step 1: Ask clarifying questions (with lettered options)
- [ ] Step 2: Discover project checks (categorize fast vs slow)
- [ ] Step 3: Generate PRD with all sections
- [ ] Step 4: Save to tasks/prd-[feature-name].md
- [ ] Step 5: Self-review (validate ACs and technical considerations)
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
- **Acceptance criteria must describe observable behavior, not implementation details.** If an AC mentions a specific class, method, file path, or design pattern, rewrite it as observable behavior. See the table below for examples.
- **Do not specify exact UI text/copy** (e.g., error messages, button labels, placeholder text)—these are implementation details that lead to brittle tests. Instead, describe the behavior: "Display a user-friendly error message" not "Display error message 'Something went wrong'".
- **For any story with UI changes:** Always include "Write e2e test scripts using /agent-browser skill" as acceptance criteria. Write and verify the new e2e test works, but don't run the full e2e suite—that happens in the final story.
- **Use fast checks for implementation stories:** Run lint, typecheck, build, and unit tests on every story to maintain TDD discipline. See [references/project-checks.md](references/project-checks.md).
- **Always add a final verification story:** Add a dedicated user story at the END of the story list. This story runs all checks (including e2e if the project has them), adds any missing e2e tests, and updates documentation before merge.
- **NEVER use arbitrary numeric targets** like "reduce to X lines" or "under X KB" as acceptance criteria to avoid over-optimization. Instead, describe the *functional outcome* you want (e.g., "Remove X, Y, Z logic from source file" rather than "Reduce to under 50 lines").
- **Each acceptance criterion should have only one possible interpretation:** If two developers could reasonably implement an AC differently, it's too ambiguous. For example, use specific verbs (add, remove, change, replace) instead of "update".

**For examples of good vs bad acceptance criteria:** See [references/acceptance-criteria.md](references/acceptance-criteria.md)

### Discovering Project Checks

Before writing acceptance criteria, discover what automated checks the project uses. See [references/project-checks.md](references/project-checks.md) for detailed guidance on categorizing fast vs slow checks.

### 4. Technical Considerations
Document technical constraints and context that implementers need to know. This section provides guidance without dictating implementation.

**What to include:**
- API contracts and response formats
- Environment/configuration requirements
- Performance constraints or SLAs
- External dependencies and integration points
- Security or compliance requirements

**What NOT to include:**
- Class names, method names, or file paths
- Specific design patterns to use
- Internal architecture decisions
- How components should communicate

The implementation details should emerge from following good coding principles (e.g., low coupling, high cohesion, SOLID). Do not prescribe architecture in the PRD.

### 5. Non-Goals (Out of Scope)
What this feature will NOT include. Critical for managing scope.

### 6. Design Considerations (Optional)
- UI/UX requirements
- Link to mockups if available
- Relevant existing components to reuse

### 7. Success Metrics
How will success be measured?
- "Reduce time to complete X by 50%"
- "Increase conversion rate by 10%"

### 8. Documentation Updates
Identify what documentation needs to be updated:
- README.md changes (new features, usage examples, CLI flags)
- API docs, inline comments, or other relevant docs

**Important:** Always include a user story for documentation updates when the feature changes user-facing behavior, APIs, or commands.

### 9. Open Questions
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

## Self-Review

After generating the PRD, review the entire document and revise if needed:

- [ ] **Introduction/Overview:** Clearly states the problem and solution
- [ ] **Goals:** Specific and measurable, not vague
- [ ] **User Stories:** Small enough to complete in one focused session
- [ ] **Acceptance Criteria:** Describe observable behavior, not implementation details
  - No class names, method names, file paths, or design patterns
  - Each AC has only one possible interpretation
- [ ] **Technical Considerations:** Provide context without dictating architecture
  - No internal implementation details (class relationships, injection patterns)
  - Does not violate coding principles (low coupling, high cohesion, SOLID)
- [ ] **Non-Goals:** Clearly defines what's out of scope
- [ ] **Documentation Updates:** Included if feature changes user-facing behavior
- [ ] **Final story:** Includes full checks and documentation updates
- [ ] **Project checks:** Each implementation story ends with fast checks; final story uses full checks
- [ ] **Overall:** PRD matches user's requirements—nothing more, nothing less

---

## Example PRD

See [examples/priority-system.md](examples/priority-system.md) for a complete example demonstrating all sections, user story format, and check categorization.
