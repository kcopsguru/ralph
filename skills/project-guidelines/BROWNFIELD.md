# Brownfield Project Workflow

For existing projects with source code. Analyze codebase to identify tech stack, then research best practices for that stack.

**Output:** Same format as greenfield projects. See [TEMPLATE.md](TEMPLATE.md).

## Progress Checklist

Copy and track:

```
Brownfield Guidelines Progress:
- [ ] Step 1: Analyze structure
- [ ] Step 2: Identify tech stack
- [ ] Step 3: Research best practices for stack
- [ ] Step 4: Document architecture
- [ ] Step 5: Define code patterns
- [ ] Step 6: Define testing strategy
- [ ] Step 7: Document deployment
- [ ] Step 8: Define critical rules
- [ ] Step 9: Review and finalize
```

## Step 1: Analyze Structure

List top-level directories and identify project type by marker files:
- `package.json` → Node.js/JavaScript
- `pyproject.toml` / `requirements.txt` → Python
- `Cargo.toml` → Rust
- `go.mod` → Go
- `pom.xml` / `build.gradle` → Java

## Step 2: Identify Tech Stack

Examine dependency files to determine:
- **Frontend**: Framework, bundler, CSS approach
- **Backend**: Language, framework, database drivers
- **Database**: Type and ORM
- **Infrastructure**: Cloud provider, containerization
- **Testing**: Frameworks, coverage tools

## Step 3: Research Best Practices for Stack

Use web search or Context7 MCP to find current best practices for the identified stack.

**Research checklist:**
- [ ] Official project structure recommendations
- [ ] Type safety and validation patterns
- [ ] Error handling conventions
- [ ] Authentication patterns (if applicable)
- [ ] Testing frameworks and strategies
- [ ] Deployment best practices

**Example queries:**
- `[Framework] recommended project structure`
- `[Framework] best practices production`
- `[Framework] + [ORM] patterns`
- `[Framework] error handling patterns`

**Document findings with sources.**

## Step 4: Document Architecture

Create ASCII diagram showing services and data flow:

```
┌─────────────────────────────────────────────────────────────┐
│                         [Layer Name]                        │
│  [Technology] + [Framework]                                 │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
```

Use the actual project structure, but organize the diagram following best practices.

## Step 5: Define Code Patterns

For each pattern, combine research with codebase analysis:

1. **Research**: What does the official documentation recommend?
2. **Codebase**: Does the project have existing patterns to reference?
3. **Document**: The best practice pattern (from research)

**Patterns to define:**
- File/folder naming conventions
- Component/module structure
- API response format
- Error handling
- Data validation
- State management (if applicable)

**Include code examples** - prefer examples from official docs or well-known projects.

## Step 6: Define Testing Strategy

**Analyze existing test setup:**
- Test frameworks in dependencies (Jest, Pytest, Go test, etc.)
- Test file locations and naming conventions
- Test scripts in package.json, Makefile, etc.
- CI/CD test configuration
- Coverage tools and thresholds

**Research best practices** for the identified test frameworks.

**Document the testing strategy:**
- Test file location and naming conventions
- Unit testing framework and approach
- Integration testing strategy
- E2E testing (if applicable)
- Coverage goals

**Provide example test structure** - use existing tests as reference if they follow best practices, otherwise use examples from official docs.

## Step 7: Document Deployment

Document from CI/CD configs and research:
- Build commands
- Deploy commands
- Required environment variables (names only, no values)
- CI/CD pipeline best practices for this stack

## Step 8: Define Critical Rules

Establish 5-8 rules based on best practices research:
- Code style requirements
- Testing requirements
- Error handling standards
- Security practices

**Rules should reflect best practices**, not just current project state.

## Step 9: Review and Finalize

Verify:
- [ ] Architecture diagram reflects project structure
- [ ] Code patterns are based on official best practices
- [ ] Testing strategy matches industry standards
- [ ] Critical rules are specific and enforceable
- [ ] No sensitive values included

---

## Quality Checklist

Before finalizing:
- [ ] Tech stack accurately identified
- [ ] Best practices research documented with sources
- [ ] Code patterns cite official docs or known projects
- [ ] Testing strategy matches industry standards
- [ ] Critical rules are specific and enforceable
- [ ] No hardcoded secrets or sensitive values
