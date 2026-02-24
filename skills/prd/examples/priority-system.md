# PRD: Task Priority System

## Introduction

Add priority levels to tasks so users can focus on what matters most. Tasks can be marked as high, medium, or low priority, with visual indicators and filtering to help users manage their workload effectively.

## Goals

- Allow assigning priority (high/medium/low) to any task
- Provide clear visual differentiation between priority levels
- Enable filtering and sorting by priority
- Default new tasks to medium priority

## User Stories

### US-001: Persist task priority
**Description:** As a developer, I need to store task priority so it persists across sessions.

**Acceptance Criteria:**
- [ ] Task priority persists after page refresh
- [ ] New tasks default to medium priority
- [ ] Priority values are limited to: high, medium, low
- [ ] All checks pass: `npm run lint && npm run build && npm test`

### US-002: Display priority indicator on task cards
**Description:** As a user, I want to see task priority at a glance so I know what needs attention first.

**Acceptance Criteria:**
- [ ] Each task card shows colored priority badge (red=high, yellow=medium, gray=low)
- [ ] Priority visible without hovering or clicking
- [ ] Write e2e test scripts using /agent-browser skill
- [ ] All checks pass: `npm run lint && npm run build && npm test`

### US-003: Add priority selector to task edit
**Description:** As a user, I want to change a task's priority when editing it.

**Acceptance Criteria:**
- [ ] Priority dropdown in task edit modal
- [ ] Shows current priority as selected
- [ ] Saves immediately on selection change
- [ ] Write e2e test scripts using /agent-browser skill
- [ ] All checks pass: `npm run lint && npm run build && npm test`

### US-004: Filter tasks by priority
**Description:** As a user, I want to filter the task list to see only high-priority items when I'm focused.

**Acceptance Criteria:**
- [ ] Filter dropdown with options: All | High | Medium | Low
- [ ] Filter persists in URL params
- [ ] Empty state message when no tasks match filter
- [ ] Write e2e test scripts using /agent-browser skill
- [ ] All checks pass: `npm run lint && npm run build && npm test`

### US-005: Final Verification and Documentation
**Description:** As a developer, I want to verify all features work together and update documentation before merging.

**Acceptance Criteria:**
- [ ] Add any missing e2e tests for new functionality
- [ ] All checks pass: `npm run lint && npm run build && npm test && npm run test:e2e`
- [ ] README updated with priority feature usage
- [ ] API docs updated if priority endpoints added

## Technical Considerations

- Priority values: 'high' | 'medium' | 'low' (default: 'medium')
- Priority is persisted in database, not computed dynamically
- Filter state should be shareable via URL
- **Fast checks (each story):** `npm run lint && npm run build && npm test`
- **Full checks (final story):** `npm run test:e2e` (Playwright browser tests)

## Non-Goals

- No priority-based notifications or reminders
- No automatic priority assignment based on due date
- No priority inheritance for subtasks

## Success Metrics

- Users can change priority in under 2 clicks
- High-priority tasks immediately visible at top of lists
- No regression in task list performance

## Documentation Updates

- README: Add section explaining priority feature and how to use it
- API docs: Document priority field in task endpoints (if applicable)

## Open Questions

- Should priority affect task ordering within a column?
- Should we add keyboard shortcuts for priority changes?
