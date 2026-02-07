# Greenfield Project Workflow

For new projects without existing code. Interview the user and research best practices.

**Output:** Same format as existing projects. See [TEMPLATE.md](TEMPLATE.md).

## Progress Checklist

Copy and track:

```
Greenfield Guidelines Progress:
- [ ] Step 1: Interview - Project goals
- [ ] Step 2: Interview - Tech stack
- [ ] Step 3: Research best practices
- [ ] Step 4: Propose architecture
- [ ] Step 5: Define code patterns
- [ ] Step 6: Establish testing strategy
- [ ] Step 7: Plan deployment
- [ ] Step 8: Define critical rules
- [ ] Step 9: Review and finalize
```

## Step 1: Interview - Project Goals

Ask these questions conversationally. **Wait for response before Step 2.**

1. "What does your project do?"
2. "Who are the users? (internal tool, public web app, API service, etc.)"
3. "Target scale? (prototype, small team, enterprise)"
4. "Constraints? (regulatory, performance, budget)"

## Step 2: Interview - Tech Stack

Guide selection based on project description. **Wait for response before Step 3.**

**Frontend** (if needed):
- Framework: React, Vue, Svelte, Next.js, etc.
- Styling: Tailwind, CSS Modules, styled-components

**Backend**:
- Language/runtime: Node.js, Python, Go, Rust, Java
- Framework: Express, FastAPI, Gin, Actix, Spring
- API style: REST, GraphQL, gRPC, tRPC

**Data**:
- Database: PostgreSQL, MySQL, MongoDB, SQLite
- ORM: Prisma, Drizzle, SQLAlchemy, GORM
- Caching: Redis, in-memory, none

**Infrastructure**:
- Deployment: Vercel, AWS, GCP, self-hosted
- Containerization: Docker, none
- CI/CD: GitHub Actions, GitLab CI

## Step 3: Research Best Practices

Use web search or Context7 MCP to find current best practices for chosen stack.

**Research checklist:**
- [ ] Official project structure recommendations
- [ ] Type safety and validation patterns
- [ ] Error handling conventions
- [ ] Authentication patterns (if applicable)
- [ ] Testing frameworks for this stack
- [ ] Deployment best practices

**Example queries:**
- `[Framework] recommended project structure`
- `[Framework] best practices production`
- `[Framework] + [ORM] patterns`

**Document findings with sources before proposing architecture.**

## Step 4: Propose Architecture

Present to user for approval:

1. ASCII architecture diagram
2. Recommended directory structure
3. Key decisions with rationale
4. Trade-offs considered

**Example format:**

```
Proposed Architecture:

┌─────────────────────────────────────────────────────────────┐
│  Frontend: Next.js 14 + TypeScript + Tailwind              │
└─────────────────────────────────────────────────────────────┘
                              │ tRPC
                              ▼
┌─────────────────────────────────────────────────────────────┐
│  Backend: Node.js + tRPC + Zod                             │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│  Database: PostgreSQL + Prisma                             │
└─────────────────────────────────────────────────────────────┘
```

**Ask:** "Does this work for you? Any changes?"

## Step 5: Define Code Patterns

For each pattern provide:
1. Name and purpose
2. Code example (from official docs or known projects)
3. When to use
4. Source link

**Patterns to define:**
- File/folder naming
- Component/module structure
- API response format
- Error handling
- Data validation
- State management (if applicable)

## Step 6: Establish Testing Strategy

**Define:**
- Test location and naming: `__tests__/`, `*.test.ts`, etc.
- Unit testing framework and approach
- Integration testing strategy
- E2E testing (if applicable)
- Coverage goals

**Provide example test structure for chosen stack.**

## Step 7: Plan Deployment

**Define:**
- Development environment setup
- Build commands
- Environment variables needed
- CI/CD pipeline structure
- Monitoring approach

## Step 8: Define Critical Rules

Establish 5-8 non-negotiable rules. Be specific and enforceable.

**Example rules:**
1. "All API endpoints must validate input with Zod"
2. "Every feature requires unit tests before merge"
3. "Use Result pattern for all async operations"
4. "Database queries must use parameterized statements"
5. "No secrets in code; use environment variables"

## Step 9: Review and Finalize

**Present complete document and ask:**
- "Does this capture your needs?"
- "Any patterns to add or remove?"
- "Ready to create the final document?"

**If changes requested:** Update and present again. Iterate until approved.

---

## Quality Checklist

Before finalizing:
- [ ] User confirmed project goals
- [ ] Tech stack choices have documented rationale
- [ ] Best practices research includes sources
- [ ] Code patterns cite official docs or known projects
- [ ] Testing strategy matches industry standards
- [ ] Critical rules are specific and enforceable
- [ ] User approved final document
