# Project Guidelines Template

Use this structure for the output document. The template is the same for greenfield and existing projects - only the data gathering method differs.

---

```markdown
# Project Guidelines

Brief one-line description of what this project does.

---

## Architecture Overview

**Tech Stack:**
- **Frontend**: [Framework], [Language], [UI Library]
- **Backend**: [Framework] ([Language]), [Validation]
- **Database**: [Type] + [ORM]
- **Deployment**: [Platform]
- **Testing**: [Frameworks]

**Architecture:**

[ASCII diagram showing services and data flow]

```
┌─────────────────────────────────────────────────────────────┐
│                         [Layer]                             │
│  [Technology] + [Framework]                                 │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
```

---

## File Structure

[Directory tree with brief descriptions]

```
project/
├── src/
│   ├── components/    # UI components
│   ├── services/      # Business logic
│   └── utils/         # Shared utilities
├── tests/             # Test files
└── config/            # Configuration
```

---

## Code Patterns

### [Pattern Name]

**Purpose:** [What this pattern solves]

**Example:**
```[language]
[Code example]
```

**When to use:** [Guidance on when to apply this pattern]

---

## Testing

**Structure:**
- Unit tests: `[location and naming convention]`
- Integration tests: `[location and naming convention]`
- E2E tests: `[location and naming convention]`

**Commands:**
```bash
[test commands]
```

**Coverage:** [Coverage expectations or targets]

---

## Deployment

**Pre-Deployment Checklist:**
- [ ] [Check 1]
- [ ] [Check 2]
- [ ] [Check 3]

**Build:**
```bash
[build commands]
```

**Deploy:**
```bash
[deploy commands]
```

**Environment Variables:**
| Variable | Description |
|----------|-------------|
| `VAR_NAME` | [What it's for] |

---

## Critical Rules

1. [Specific, enforceable rule]
2. [Specific, enforceable rule]
3. [Specific, enforceable rule]
4. [Specific, enforceable rule]
5. [Specific, enforceable rule]

---

## Getting Started

**Setup:**
```bash
[setup commands]
```

**Development workflow:**
1. [Step 1]
2. [Step 2]
3. [Step 3]

---

## References

- [Link to relevant documentation]
- [Link to style guides or ADRs]
```

---

## Section Guidelines

### Code Patterns
- Include 3-5 key patterns
- Show the "right way" to do common tasks
- Code examples should be copy-paste ready

### Critical Rules
- 5-8 rules maximum
- Specific and enforceable
- Avoid vague guidance like "write good code"

### Getting Started
- Commands should be runnable as-is
- Cover the typical developer onboarding flow
