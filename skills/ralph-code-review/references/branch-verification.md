# Branch Verification

Verify branch setup before reviewing code.

## Checks

Run these commands and verify all match:

```bash
# 1. Must not be on main/master
git branch --show-current

# 2. Must match .ralph/.last-branch
cat .ralph/.last-branch

# 3. Must match branchName in prd.json
jq -r '.branchName' .ralph/prd.json
```

## Error Messages

**On main branch:**
```
ERROR: Cannot run code review on main branch.
Please checkout your feature branch first.
```

**Branch mismatch:**
```
ERROR: Branch mismatch.
Current branch: [current]
Expected branch: [expected]

Please checkout the correct branch or update the configuration.
```

All three values must be consistent before proceeding.
