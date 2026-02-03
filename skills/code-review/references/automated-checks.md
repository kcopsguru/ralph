# Automated Checks

Run project's automated checks before manual review.

## Detection

| Project Type | Detection | Commands |
|-------------|-----------|----------|
| Node.js | `package.json` | `npm run typecheck && npm run lint && npm run build && npm test` |
| Python | `pyproject.toml` | `make lint && make typecheck && pytest` |
| Go | `go.mod` | `go build ./... && go test ./... && go vet ./...` |
| Rust | `Cargo.toml` | `cargo build && cargo test && cargo clippy` |

If no build system detected, ask user for commands.

## On Failure

**Skip manual review.** Convert failures directly to Critical fix stories, then proceed to interactive review.

## On Success

Proceed to manual code review.
