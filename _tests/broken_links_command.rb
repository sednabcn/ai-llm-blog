# _plugins/broken_links_command.rb
require 'jekyll'
require 'html-proofer'

module Jekyll
  class CheckLinksCommand < Command
    def self.init_with_program(prog)
      prog.command(:check_links) do |c|
        c.syntax 'check_links [--remote]'
        c.description 'Run HTMLProofer to check for broken links in _site.'

        c.option '--remote', 'Use _config.remote.yml and Gemfile.remote'

        c.action do |args, options|
          config_file = options.remote ? '_config.remote.yml' : '_config.yml'
          gemfile = options.remote ? 'Gemfile.remote' : 'Gemfile'
          site_dir = '_site'

          puts "🔍 Using config: #{config_file}"
          puts "🔧 Using Gemfile: #{gemfile}"

          # Ensure site is built
          unless Dir.exist?(site_dir)
            puts "🚫 _site directory not found. Please build your site first:"
            puts "   bundle exec jekyll build --config #{config_file}"
            exit 1
          end

          # Check links
          puts "🔗 Checking links in #{site_dir}..."
          options = {
            assume_extension: true,
            check_html: true,
            allow_hash_href: true,
            enforce_https: false,
            disable_external: false
          }

          begin
            HTMLProofer.check_directory(site_dir, options).run
            puts "✅ No broken links found."
          rescue HTMLProofer::Checker::FailedCheck => e
            puts "❌ Broken links detected."
            exit 2
          rescue StandardError => e
            puts "💥 Unexpected error: #{e.message}"
            exit 3
          end
        end
      end
    end
  end
end
