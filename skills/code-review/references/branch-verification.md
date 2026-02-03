# Branch Verification

Verify before reviewing:

```bash
git branch --show-current        # Must not be main/master
cat .ralph/.last-branch          # Must match current branch
jq -r '.branchName' .ralph/prd.json  # Must match current branch
```

All three must be consistent. Stop with error if not.
