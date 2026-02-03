# Automated Checks

Run project's automated checks before manual review. If any fail, skip manual review and convert failures to fix stories.

## Detection

Detect project type and available scripts:

| Project Type | Detection | Common Commands |
|-------------|-----------|-----------------|
| Node.js | `package.json` | `npm run typecheck`, `npm run lint`, `npm run build`, `npm test` |
| Python | `pyproject.toml`, `Makefile` | `make lint`, `make typecheck`, `pytest` |
| Go | `go.mod` | `go build ./...`, `go test ./...`, `go vet ./...` |
| Rust | `Cargo.toml` | `cargo build`, `cargo test`, `cargo clippy` |

If no build system detected, ask the user for commands.

## Run Order

Execute in order, stop at first failure:

1. **Typecheck** - Type errors
2. **Lint** - Code style issues
3. **Build** - Compilation/bundling
4. **Test** - Automated tests

Example:
```bash
npm run typecheck && npm run lint && npm run build && npm test
```

## On Failure

Skip manual code review (Steps 4-5) and proceed directly to converting failures to fix stories:

```
AUTOMATED CHECKS FAILED - Skipping manual code review.

Failed checks:
- typecheck: 3 errors in src/utils.ts
- lint: 2 warnings treated as errors

Converting to fix stories...
```

Each failure becomes a Critical severity fix story.

## On Success

Proceed to manual code review (Step 4).
