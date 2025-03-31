#!/bin/bash
echo "Remove the _site"
rm -rf _site/

# Install dependencies
echo "Install dependencies"
bundle install --gemfile=Gemfile.remote

# Build with only remote configuration
echo "Build with only remote configuration"
JEKYLL_ENV=production BUNDLE_GEMFILE=Gemfile.remote bundle exec jekyll build \
    --config _config.remote.yml \
    --trace

# Test server launch with only remote configuration
echo "Test server launch with remote configuration only"
BUNDLE_GEMFILE=Gemfile.remote bundle exec jekyll serve \
    --config _config.remote.yml \
    --port 5000 2>/dev/null

