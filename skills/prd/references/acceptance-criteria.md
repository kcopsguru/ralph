# Acceptance Criteria Guide

## Good vs Bad Examples

| Bad (Implementation Details) | Good (Observable Behavior) |
|------------------------------|---------------------------|
| Create a new service class in the services folder | Data is fetched from the API when the page loads |
| Add a method to parse the filename from the message | Filenames with spaces are correctly extracted from user messages |
| Store the response in a class property for caching | Subsequent requests return cached data without additional API calls |
| Call ServiceA from ServiceB to get the ID | The correct ID is sent to the API based on the selected item |
| Use a regex pattern to match filenames ending in .pdf | Filenames ending in .pdf are recognized in user input |
| Add error handling that returns an empty array | When the API is unavailable, the feature degrades gracefully |

**Rule of thumb:** If the AC mentions a class name, method name, file path, or design pattern, rewrite it to describe the observable outcome instead.

## Key Principles

- **Describe observable behavior, not implementation details**
- **Each AC should have only one possible interpretation** - if two developers could implement it differently, it's too ambiguous
- **Use specific verbs** (add, remove, change, replace) instead of vague ones like "update"
- **Do not specify exact UI text/copy** - describe the behavior instead ("Display a user-friendly error message" not "Display error message 'Something went wrong'")
- **Avoid arbitrary numeric targets** like "reduce to X lines" - describe the functional outcome instead
