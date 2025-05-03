# _tests/test_helpers.rb
require 'html-proofer'

module Tests
  class LinkChecker
    def self.check_links(site_dir = "./_site", options = {})
      default_options = {
        assume_extension: true,
        allow_hash_href: true,
        check_html: true,
        check_img_http: true,
        empty_alt_ignore: true,
        enforce_https: true,
        internal_domains: ['sednabcn.github.io'],
        url_ignore: [/linkedin\.com/],
        verbose: true
      }
      
      merged_options = default_options.merge(options)
      puts "Running HTMLProofer on #{site_dir}..."
      HTMLProofer.check_directory(site_dir, merged_options).run
    end
  end
end
