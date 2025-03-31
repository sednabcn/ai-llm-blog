
#!/bin/bash

# Build your Jekyll site
bundle exec jekyll build

# Switch to gh-pages branch
git checkout gh-pages

# Copy build contents
cp -R _site/* .

# Commit and push
git add .
git commit -m "Update GitHub Pages"
git push origin gh-pages
