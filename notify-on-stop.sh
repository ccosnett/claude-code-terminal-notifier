#!/bin/bash

INPUT=$(cat)
TRANSCRIPT_PATH=$(echo "$INPUT" | jq -r '.transcript_path')
PROJECT_NAME=$(basename "$(echo "$INPUT" | jq -r '.cwd')")

# Get the last assistant message text from the transcript
SUMMARY=$(jq -s '[.[] | select(.type == "assistant")] | last | .message.content | map(select(.type == "text")) | map(.text) | join(" ")' "$TRANSCRIPT_PATH" 2>/dev/null | head -c 200)

# Fallback if we couldn't extract a summary
if [ -z "$SUMMARY" ] || [ "$SUMMARY" = "null" ]; then
  SUMMARY="Finished responding"
fi

# Remove surrounding quotes from jq output
SUMMARY=$(echo "$SUMMARY" | sed 's/^"//;s/"$//')

# Truncate and add ellipsis if needed
if [ ${#SUMMARY} -gt 150 ]; then
  SUMMARY="${SUMMARY:0:147}..."
fi

afplay /System/Library/Sounds/Glass.aiff &
terminal-notifier -title "$PROJECT_NAME" -message "$SUMMARY" -sound Glass 2>/dev/null || true
