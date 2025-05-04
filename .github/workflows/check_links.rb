#!/usr/bin/env ruby
# _plugins/check_links.rb

require 'html-proofer'

module Jekyll
  class LinkChecker < Jekyll::Generator
    def generate(site)
      # Don't run during regular site generation
    end
    
    def self.check_links(site_dir = "./_site", options = {})
      default_options = {
        assume_extension: true,
        allow_hash_href: true,
        check_html: true,
        check_img_http: true,
        empty_alt_ignore: true,
        enforce_https: true,
        internal_domains: ['sednabcn.github.io'],
        url_ignore: [/linkedin\.com/], # Add URLs to ignore
        verbose: true,
        typhoeus: {
          followlocation: true,
          headers: {
            'User-Agent' => 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36'
          }
        }
      }
      
      merged_options = default_options.merge(options)
      puts "Running HTMLProofer on #{site_dir}..."
      HTMLProofer.check_directory(site_dir, merged_options).run
    end
  end
end

# Allow running this file directly
if __FILE__ == $0
  Jekyll::LinkChecker.check_links
end
