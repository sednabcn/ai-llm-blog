#!/bin/bash
# post_deploy_check.sh

# Check site availability
curl -f https://sednabcn.github.io/ai-llm-blog

# Check for specific page
curl -f https://sednabcn.github.io/ai-llm-blog/_posts/2025-03-10-advancing-formula-discovery.md

# Optional: Run link checker
bundle exec htmlproofer ./_site
