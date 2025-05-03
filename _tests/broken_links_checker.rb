#!/usr/bin/env ruby
# broken_links_checker.rb - A utility script to check for broken links on remote Jekyll builds only.

require 'optparse'
require 'colorize'
require 'html-proofer'

SITE_DIR = "_site"

# Enforce usage with --remote only
unless ARGV.include?('--remote')
  puts "\n❌ This script is intended to be run only with '--remote'.".red
  puts "   Example: ruby broken_links_checker.rb --remote".yellow
  exit 1
end

# Load remote config
def load_remote_config
  puts "🔧 Using config: _config.remote.yml"
  puts "🔧 Using Gemfile: Gemfile.remote"
  ENV['BUNDLE_GEMFILE'] = 'Gemfile.remote'
  require 'bundler/setup'
end

def print_banner
  puts "\n" + "="*80
  puts "REMOTE BROKEN LINKS CHECKER".center(80)
  puts "="*80
  puts "This script checks your deployed site for broken links.\n\n"
end

def check_jekyll_site
  unless Dir.exist?(SITE_DIR)
    puts "\n❌ Error: _site directory not found!".red
    puts "Please build the site first (e.g., from a CI runner).".yellow
    exit 1
  end
end

def run_remote_check
  options = {
    assume_extension: true,
    allow_hash_href: true,
    check_html: true,
    disable_external: true,
    internal_domains: ["sednabcn.github.io"],
    log_level: :info
  }

  begin
    HTMLProofer.check_directory(SITE_DIR, options).run
    puts "\n✅ Remote check passed. No broken links found.".green
  rescue StandardError => e
    if e.is_a?(HTMLProofer::Checker::FailedCheck)
      puts "\n❌ Broken links were found. See details above.".red
    else
      puts "\n❌ Error: #{e.message}".red
    end
  end
end

def main
  load_remote_config
  print_banner
  check_jekyll_site
  run_remote_check
end

main
