#!/bin/bash
set -e

echo "📋 Fetching open 'test-comment' labeled issues..."

TEST_ISSUES=$(gh issue list --label "test-comment" --state open --json number,title --limit 100)
TEST_COUNT=$(echo "$TEST_ISSUES" | jq length)
echo "Found $TEST_COUNT issues"

declare -A seen_titles

echo "$TEST_ISSUES" | jq -c '.[]' | while read -r issue; do
  NUM=$(echo "$issue" | jq -r '.number')
  TITLE=$(echo "$issue" | jq -r '.title')

  if [[ -z "${seen_titles[$TITLE]}" ]]; then
    seen_titles["$TITLE"]=$NUM
    echo "✅ Keeping issue #$NUM: $TITLE"
  else
    echo "🗑️ Closing duplicate issue #$NUM: $TITLE"
    gh issue comment "$NUM" --body "This issue is a duplicate and will be closed."
    gh issue close "$NUM"
    gh issue lock "$NUM" --reason "duplicate"
  fi
done
