---
name: creating-project-guidelines
description: Creates project-guidelines documents capturing architecture, patterns, and workflows. Use for existing codebases (analyzes current code) or greenfield projects (interviews user, researches best practices). Triggers on "document this project", "create project guidelines", "set up guidelines for new project", or architecture documentation requests.
---

# Creating Project Guidelines

## Determine Project Type

Check for existing source code:
1. Look for `src/`, `app/`, `lib/` directories with code files
2. Check for substantive `.ts`, `.py`, `.go`, `.rs`, `.java` files (not just config)

**Has code?** → Use [Brownfield Workflow](BROWNFIELD.md)

**No code?** → Use [Greenfield Workflow](GREENFIELD.md)

## Output

Both workflows produce the same document format. See [TEMPLATE.md](TEMPLATE.md).

Both workflows research best practices via web search. The difference:

| Workflow | How Tech Stack is Determined |
|----------|------------------------------|
| Brownfield | Analyze existing code and dependencies |
| Greenfield | Interview user about requirements |

Guidelines should reflect **best practices for the tech stack**, not just current code state.

## Adaptation

- **Monorepos**: Add services overview section
- **Microservices**: Document service boundaries and communication protocols
- **Event-driven**: Document message brokers, event schemas, and async patterns
- **Libraries**: Focus on API docs and usage examples
- **CLI tools**: Document commands and configuration
