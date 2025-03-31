#!/bin/bash


echo "cleaningand swapping the _site"
bundle clean --force
rm -rf _site/

# Install dependencies

echo "Install dependencies"

bundle install


# Build with remote configuration

echo "Build with remote configuration "

JEKYLL_ENV=production bundle exec jekyll build \
    --config _config.yml,_config.remote.yml \
    --trace

# Optional: Test server launch

echo "Test server launch"

bundle exec jekyll serve \
    --config _config.yml,_config.remote.yml \
    --port 4000
