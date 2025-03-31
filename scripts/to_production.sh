#!/bin/bash

echo "Moving Gemfile/_config.yml to LOCAL"
mv _config.yml _config.local.yml
mv Gemfile Gemfile.local

echo "Moving remote config to production"
mv _config.remote.yml _config.yml
mv Gemfile.remote Gemfile

# Ensure the backup directory exists
mkdir -p ./scripts/conf_backup

# Move local files to backup only if they exist
for file in _config.local.yml _config.remote.yml Gemfile.local Gemfile.remote; do
    if [ -f "$file" ]; then
        mv "$file" ./scripts/conf_backup/
    else
        echo "Warning: $file not found, skipping..."
    fi
done

echo "Configuration preparation completed."

