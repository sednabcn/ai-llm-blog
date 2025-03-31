
#!/bin/bash

# Typical Feature Branch Workflow

# 1. Start from main branch
git checkout master
git pull origin master

# 2. Create feature branch
git checkout -b feature/new-functionality

# 3. Work on the feature
# Make changes, commit frequently
git add .
git commit -m "Add specific feature description"

# 4. Push feature branch to remote
git push -u origin feature/new-functionality

# Merging Process

# 5. Prepare for merge
# Ensure main branch is up-to-date
git checkout master
git pull origin master

# 6. Merge feature branch
# Option 1: Merge locally
git merge feature/new-functionality

# Option 2: Create Pull Request on GitHub
# - Allows code review
# - Enables discussion
# - Provides merge validation

# 7. Delete feature branch after merge
git branch -d feature/new-functionality
git push origin --delete feature/new-functionality

# Merge Strategies
# 1. Merge Commit
#    • Creates a new commit combining branches 
#    • Preserves entire feature branch history 

git merge feature/new-functionality

# 2. Squash Merge
#    • Condenses all feature branch commits 
#    • Creates single, clean commit in main branch 

git merge --squash feature/new-functionality
# 3. Rebase
#    • Moves feature branch commits to tip of main branch 
#    • Creates linear history 

git checkout feature/new-functionality
git rebase master
