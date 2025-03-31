#!/bin/bash

# Check _config.remote.yml
echo "Verifying _config.remote.yml..."
if [ -f "_config.remote.yml" ]; then
    echo "File exists. Checking contents:"
    cat _config.remote.yml
    
    # Validate YAML syntax
    echo -e "\nValidating YAML syntax:"
    ruby -e "require 'yaml'; YAML.load_file('_config.remote.yml')"
    
    # Check specific key configurations
    echo -e "\nChecking key configurations:"
    grep -E "url:|baseurl:|environment:" _config.remote.yml
else
    echo "ERROR: _config.remote.yml not found!"
fi

# Check Gemfile.remote
echo -e "\n\nVerifying Gemfile.remote..."
if [ -f "Gemfile.remote" ]; then
    echo "File exists. Checking contents:"
    cat Gemfile.remote
    
    # Check gem sources
    echo -e "\nChecking gem sources:"
    grep "source " Gemfile.remote
    
    # List gems
    echo -e "\nListing gems:"
    grep "gem " Gemfile.remote
else
    echo "ERROR: Gemfile.remote not found!"
fi

# Test remote build
echo -e "\n\nTesting remote build..."
bundle config set path 'vendor/bundle'
bundle install
JEKYLL_ENV=production bundle exec jekyll build --config _config.yml,_config.remote.yml 2>/dev/null
