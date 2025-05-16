require 'open3'

module Jekyll
  class LastModifiedGenerator < Generator
    priority :high  # Run this plugin earlier
    
    def generate(site)
      # Process posts
      site.posts.docs.each { |doc| inject_lastmod(doc) }
      
      # Process pages
      site.pages.each { |page| inject_lastmod(page) }
      
      # Process collections
      site.collections.each do |_, collection|
        collection.docs.each { |doc| inject_lastmod(doc) }
      end
      
      Jekyll.logger.info("LastModifiedGenerator:", "Last modified dates injected into all content")
    end
    
    private
    
    def inject_lastmod(item)
      # Skip if lastmod is already set in front matter
      return if item.data.key?('lastmod')
      
      path = item.respond_to?(:path) ? item.path : nil
      return unless path && File.exist?(path)
      
      # Try to get git last modified date
      git_date = git_last_modified(path)
      
      if git_date
        item.data['lastmod'] = git_date
        Jekyll.logger.debug("LastModifiedGenerator:", "Git date #{git_date} added to #{path}")
      else
        # Fallback to file system date if git date is not available
        file_date = file_last_modified(path)
        item.data['lastmod'] = file_date
        Jekyll.logger.debug("LastModifiedGenerator:", "File date #{file_date} added to #{path}")
      end
    end
    
    def git_last_modified(path)
      cmd = "git log -1 --format=\"%Y-%m-%d\" -- #{path}"
      stdout, _stderr, status = Open3.capture3(cmd)
      
      if status.success? && !stdout.strip.empty?
        # Parse the git date and return it as a Time object
        date_str = stdout.strip
        begin
          return Time.parse(date_str)
        rescue
          return nil
        end
      end
      
      nil
    end
    
    def file_last_modified(path)
      File.mtime(path)
    end
  end
end


