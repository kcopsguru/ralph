#!/bin/bash
# Ralph Wiggum - Long-running AI agent loop
# Usage: ./ralph.sh [--prompt <file>] [--max-iterations <n>]

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Defaults
MAX_ITERATIONS=10
PROMPT_FILE="$SCRIPT_DIR/prompt.md"

# Help function
show_help() {
  cat << EOF
Ralph Wiggum - Long-running AI agent loop

Usage: ./ralph.sh [OPTIONS]

Options:
  --prompt <file>         Path to prompt file (default: prompt.md in script directory)
  --max-iterations <n>    Maximum number of iterations (default: 10)
  -h, --help              Show this help message and exit

Examples:
  ./ralph.sh                                    # Use defaults
  ./ralph.sh --max-iterations 5                 # Run max 5 iterations
  ./ralph.sh --prompt custom.md                 # Use custom prompt file
  ./ralph.sh --prompt /path/to/file.md --max-iterations 20
EOF
}

# Parse named flags
while [[ $# -gt 0 ]]; do
  case $1 in
    -h|--help)
      show_help
      exit 0
      ;;
    --prompt)
      PROMPT_FILE="$2"
      shift 2
      ;;
    --max-iterations)
      MAX_ITERATIONS="$2"
      shift 2
      ;;
    *)
      echo "Error: Unknown option: $1" >&2
      exit 1
      ;;
  esac
done

# Validate max-iterations is a positive integer
if ! [[ "$MAX_ITERATIONS" =~ ^[1-9][0-9]*$ ]]; then
  echo "Error: --max-iterations must be a positive integer, got: $MAX_ITERATIONS" >&2
  exit 1
fi

# Validate prompt file exists
if [ ! -f "$PROMPT_FILE" ]; then
  echo "Error: Prompt file not found: $PROMPT_FILE" >&2
  exit 1
fi
echo "Starting Ralph - Max iterations: $MAX_ITERATIONS"

for i in $(seq 1 $MAX_ITERATIONS); do
  echo ""
  echo "═══════════════════════════════════════════════════════"
  echo "  Ralph Iteration $i of $MAX_ITERATIONS"
  echo "═══════════════════════════════════════════════════════"
  
  # Run amp with the ralph prompt
  OUTPUT=$(cat "$PROMPT_FILE" | amp --dangerously-allow-all 2>&1 | tee /dev/stderr) || true
  
  # Check for completion signal
  if echo "$OUTPUT" | grep -q "<promise>COMPLETE</promise>"; then
    echo ""
    echo "Ralph completed all tasks!"
    echo "Completed at iteration $i of $MAX_ITERATIONS"
    exit 0
  fi
  
  echo "Iteration $i complete. Continuing..."
  sleep 2
done

echo ""
echo "Ralph reached max iterations ($MAX_ITERATIONS) without completing all tasks."
echo "Check progress.txt for status."
exit 1
