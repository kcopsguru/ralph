---
name: jira-acli
description: Manage Jira issues, sprints, and projects using the acli command line tool. Use when the user asks to create, view, edit, search, or transition Jira issues, manage sprints, or interact with Jira boards. Covers workitem CRUD, JQL searches, status transitions, comments, and project management.
---

# Jira Management with acli

## Overview

The `acli jira` CLI provides commands for managing Jira Cloud issues, sprints, projects, and boards directly from the terminal.

**Always use `--json` flag** for machine-readable output.

**Self-discovery**: Use `--help` to explore commands:
```bash
acli jira --help
acli jira workitem --help
acli jira workitem create --help
```

**Documentation**: https://developer.atlassian.com/cloud/acli/reference/commands/jira/

## Configuration

Configuration is split between project-specific and user-specific settings.

### Project config: `.ralph/.env`

Contains project-specific settings. See [env.sample](env.sample).

```bash
JIRA_SITE=mycompany.atlassian.net
JIRA_PROJECT_KEY=PROJ
```

### User config: `~/.config/acli/auth/<site-name>`

Contains user credentials for each Jira site. The filename is the site name (e.g., `~/.config/acli/auth/mycompany.atlassian.net`). See [user-config.sample](user-config.sample).

```bash
JIRA_EMAIL=user@example.com
JIRA_API_TOKEN=your-api-token
```

### Loading Configuration

```bash
# Load project config
source .ralph/.env

# Load user config for the site
source ~/.config/acli/auth/$JIRA_SITE

# Now both JIRA_PROJECT_KEY and JIRA_EMAIL/JIRA_API_TOKEN are available
```

## Authentication

Before using acli, authenticate with your Jira instance.

### Check auth status

```bash
acli jira auth status
```

### Login (if not authenticated)

```bash
# Load configs first
source .ralph/.env
source ~/.config/acli/auth/$JIRA_SITE

# Login with API token
echo "$JIRA_API_TOKEN" | acli jira auth login \
  --site "$JIRA_SITE" \
  --email "$JIRA_EMAIL" \
  --token
```

### Switch accounts (if multiple)

```bash
acli jira auth switch
```

## Command Structure

```
acli jira <resource> <action> [flags]
```

Resources: `workitem`, `project`, `sprint`, `board`, `filter`, `field`, `dashboard`

## Common Workitem Operations

### View an issue

```bash
acli jira workitem view KEY-123 --json
acli jira workitem view KEY-123 --fields summary,status,assignee,comment --json
```

### Search issues with JQL

```bash
acli jira workitem search --jql "project = $JIRA_PROJECT_KEY" --json
acli jira workitem search --jql "project = $JIRA_PROJECT_KEY AND assignee = currentUser()" --json
acli jira workitem search --jql "project = $JIRA_PROJECT_KEY" --fields "key,summary,status" --json
acli jira workitem search --jql "project = $JIRA_PROJECT_KEY AND sprint in openSprints()" --limit 50 --json
acli jira workitem search --jql "project = $JIRA_PROJECT_KEY" --count --json
```

### Create an issue

```bash
acli jira workitem create --project "$JIRA_PROJECT_KEY" --type "Task" --summary "Implement feature X" --json
acli jira workitem create --project "$JIRA_PROJECT_KEY" --type "Bug" \
  --summary "Fix login issue" \
  --description "Users cannot log in with SSO" \
  --assignee "user@example.com" \
  --label "bug,urgent" --json

# Self-assign
acli jira workitem create --project "$JIRA_PROJECT_KEY" --type "Task" --summary "My task" --assignee "@me" --json

# Create subtask (use issue key, e.g., PROJ-123)
acli jira workitem create --project "$JIRA_PROJECT_KEY" --type "Sub-task" --summary "Subtask" --parent "${JIRA_PROJECT_KEY}-123" --json
```

### Edit issues

```bash
acli jira workitem edit --key "KEY-123" --summary "Updated summary" --json
acli jira workitem edit --key "KEY-123" --assignee "user@example.com" --json
acli jira workitem edit --key "KEY-123" --description "New description" --json
acli jira workitem edit --key "KEY-123" --labels "label1,label2" --json

# Bulk edit with JQL
acli jira workitem edit --jql "project = $JIRA_PROJECT_KEY AND status = Open" --assignee "@me" --yes --json

# Remove assignee
acli jira workitem edit --key "KEY-123" --remove-assignee --json
```

### Transition status

```bash
acli jira workitem transition --key "KEY-123" --status "In Progress" --json
acli jira workitem transition --key "KEY-123" --status "Done" --json

# Bulk transition
acli jira workitem transition --jql "assignee = currentUser() AND status = 'In Review'" --status "Done" --yes --json
```

### Comments

```bash
# Add comment
acli jira workitem comment create --key "KEY-123" --body "This is my comment" --json

# List comments
acli jira workitem comment list --key "KEY-123" --json
```

### Other workitem actions

```bash
# Clone an issue
acli jira workitem clone --key "KEY-123" --json

# Assign issue
acli jira workitem assign --key "KEY-123" --assignee "user@example.com" --json
acli jira workitem assign --key "KEY-123" --assignee "@me" --json

# Delete issue
acli jira workitem delete --key "KEY-123" --yes --json

# Archive/unarchive
acli jira workitem archive --key "KEY-123" --json
acli jira workitem unarchive --key "KEY-123" --json
```

## Sprint Management

```bash
# List sprints for a board
acli jira board list-sprints --board-id 123 --json

# View sprint details
acli jira sprint view --sprint-id 456 --json

# List work items in sprint
acli jira sprint list-workitems --sprint-id 456 --json

# Create sprint
acli jira sprint create --board-id 123 --name "Sprint 5" --json

# Update sprint
acli jira sprint update --sprint-id 456 --name "Sprint 5 - Extended" --json
```

## Project Management

```bash
# List projects
acli jira project list --json

# View current project
acli jira project view --project "$JIRA_PROJECT_KEY" --json

# Create project
acli jira project create --name "New Project" --key "NEWP" --type "software" --json
```

## Board Operations

```bash
# Search boards
acli jira board search --name "Team Board" --json

# Get board details
acli jira board get --board-id 123 --json

# List projects on board
acli jira board list-projects --board-id 123 --json
```

## JQL Quick Reference

Common JQL patterns:
- `project = $JIRA_PROJECT_KEY` - Issues in current project
- `assignee = currentUser()` - My issues
- `status = "In Progress"` - By status
- `sprint in openSprints()` - Current sprint
- `created >= -7d` - Last 7 days
- `labels = "bug"` - By label
- `ORDER BY priority DESC` - Sort results

Combine with AND/OR:
```
project = $JIRA_PROJECT_KEY AND status != Done AND assignee = currentUser()
```

## Tips

1. **Always use `--json` flag** for machine-readable output
2. **Use `--yes` flag** for non-interactive bulk operations
3. **Use JQL for bulk operations** instead of listing individual keys
4. **Check available transitions** - status names must match exactly what's configured in the project workflow
