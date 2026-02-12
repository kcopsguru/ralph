---
name: browser-debugging
description: Interactive browser debugging using agent-browser CLI. Use for manual testing, visual inspection, and debugging web applications during development or code review. NOT for creating e2e tests.
disable-model-invocation: true
---

# Browser Debugging

Interactive browser debugging using the `agent-browser` CLI tool for testing and debugging web applications.

**Important**: This skill is for interactive debugging only. Do NOT use it to create automated e2e tests.

## Setup

### macOS

Use system Chrome to avoid detection issues and leverage existing browser profiles.

### Linux

Use Playwright's built-in browser (install once):

```bash
npx agent-browser install
```

## Core Workflow

### 1. Start a Browser Session

**macOS** (always use `--executable-path` with system Chrome):
```bash
npx agent-browser --executable-path "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" open <url>

# With --headed to see the browser window
npx agent-browser --executable-path "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" --headed open <url>

# Named session for isolation
npx agent-browser --executable-path "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" --session my-debug open <url>
```

**Linux** (no `--executable-path` needed):
```bash
npx agent-browser open <url>

# With --headed to see the browser window
npx agent-browser --headed open <url>

# Named session for isolation
npx agent-browser --session my-debug open <url>
```

### 2. Inspect the Page

```bash
# Get accessibility tree with element refs (primary debugging tool)
npx agent-browser snapshot --json

# Interactive elements only (cleaner output)
npx agent-browser snapshot -i --json

# Compact view (removes empty structural elements)
npx agent-browser snapshot -ic --json

# Scope to specific area
npx agent-browser snapshot -s "#main-content" --json
```

### 3. Interact with Elements

Use `@ref` notation from snapshot output (e.g., `@e2`, `@e15`):

```bash
# Click
npx agent-browser click @e2
npx agent-browser click "button.submit"

# Type text (appends)
npx agent-browser type @e3 "hello world"

# Fill (clears first, then types)
npx agent-browser fill @e3 "test@example.com"

# Press keys
npx agent-browser press Enter
npx agent-browser press Tab
npx agent-browser press Control+a

# Check/uncheck
npx agent-browser check @e5
npx agent-browser uncheck @e5

# Select dropdown
npx agent-browser select @e4 "option-value"
```

### 4. Navigate

```bash
npx agent-browser open "https://example.com/new-page"
npx agent-browser back
npx agent-browser forward
npx agent-browser reload
```

### 5. Get Information

```bash
# Get text content
npx agent-browser get text @e1 --json

# Get HTML
npx agent-browser get html @e1 --json

# Get input value
npx agent-browser get value @e3 --json

# Get attribute
npx agent-browser get attr href @e2 --json

# Get page title/URL
npx agent-browser get title --json
npx agent-browser get url --json

# Count matching elements
npx agent-browser get count ".list-item" --json
```

### 6. Check State

```bash
npx agent-browser is visible @e1 --json
npx agent-browser is enabled @e2 --json
npx agent-browser is checked @e3 --json
```

### 7. Capture Evidence

```bash
# Screenshot current viewport
npx agent-browser screenshot

# Full page screenshot
npx agent-browser screenshot --full

# Save to specific path
npx agent-browser screenshot ./debug-screenshot.png
```

### 8. Debug Issues

```bash
# View console logs
npx agent-browser console --json

# View page errors
npx agent-browser errors --json

# Highlight element (visual debugging)
npx agent-browser highlight @e1

# Run JavaScript
npx agent-browser eval "document.title" --json
npx agent-browser eval "localStorage.getItem('token')" --json
```

### 9. Close Session

```bash
npx agent-browser close
```

## Common Debugging Scenarios

### Form Validation Testing

```bash
# macOS (with system Chrome)
npx agent-browser --headed --executable-path "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" open "http://localhost:3000/login"

# Linux (with Playwright browser)
npx agent-browser --headed open "http://localhost:3000/login"

# Then interact (same on both platforms)
npx agent-browser snapshot -i --json
npx agent-browser fill @email ""
npx agent-browser click @submit
npx agent-browser snapshot -i --json  # Check for validation messages
npx agent-browser screenshot ./validation-error.png
```

### API Response Inspection

```bash
npx agent-browser eval "window.__APP_STATE__" --json
npx agent-browser console --json  # Check for API errors
```

### Responsive Testing

```bash
# Set viewport size
npx agent-browser set viewport 375 667  # iPhone SE
npx agent-browser snapshot -i --json
npx agent-browser screenshot ./mobile-view.png

npx agent-browser set viewport 1920 1080  # Desktop
npx agent-browser snapshot -i --json
npx agent-browser screenshot ./desktop-view.png
```

### Authentication Flow

```bash
# macOS (with system Chrome)
npx agent-browser --headed --executable-path "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" open "http://localhost:3000"

# Linux (with Playwright browser)
npx agent-browser --headed open "http://localhost:3000"

# Then interact (same on both platforms)
npx agent-browser snapshot -i --json
npx agent-browser fill @username "testuser"
npx agent-browser fill @password "testpass"
npx agent-browser click @login-button
npx agent-browser wait 2000  # Wait for redirect
npx agent-browser get url --json  # Verify redirect
```

## Environment Variables

Optional session name to avoid repeating `--session`:

```bash
export AGENT_BROWSER_SESSION="debug"
```

## Best Practices

1. **macOS**: Always use `--executable-path` flag with system Chrome path
2. **Linux**: Run `npx agent-browser install --with-deps` once before first use
3. **Use `--json`** for machine-readable output (easier to parse)
4. **Use `--headed`** when you need to see the browser visually
5. **Use `snapshot -i --json`** as your primary inspection tool
6. **Take screenshots** to document bugs or verify fixes
7. **Check console/errors** when something doesn't work
8. **Use named sessions** (`--session`) when debugging multiple scenarios
9. **Close sessions** when done to free resources
