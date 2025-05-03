# Main Rakefile in project root
require 'jekyll'

desc "Build site"
task :build do
  Jekyll::Commands::Build.process({})
end

# Import all tasks from _tests/Rakefile
import '_tests/Rakefile'


# Add to your Rakefile
desc "Check for broken links"
task :check_links, [:option] do |t, args|
  option = args[:option] || 6  # Default to real-world example
  ruby "_plugins/broken_links_checker.rb #{option}"
end

# Add convenience tasks that ensure the site is built first
namespace :check do
  desc "Check internal links only"
  task :internal => [:build, 'test:internal']
  
  desc "Check all links"
  task :all => [:build, 'test:all']
  
  desc "Check specific directory"
  task :dir, [:dir] => :build do |t, args|
    Rake::Task['test:dir'].invoke(args[:dir])
  end
end
