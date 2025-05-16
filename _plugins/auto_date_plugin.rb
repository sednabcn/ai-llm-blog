module Jekyll
  class AutoDateGenerator < Generator
    safe true
    priority :low  # Run after other generators
    
    def generate(site)
      # Process regular pages
      site.pages.each do |page|
        # Skip processing if this is a category page definition
        next if page.path.start_with?('_pages/categories/')
        add_date_to_page(site, page)
      end

      # Process posts
      site.posts.docs.each do |post|
        add_date_to_page(site, post)
      end
    end

    def add_date_to_page(site, page)
      # Skip if page already has a date
      return if page.data['date']

      # Get source file path
      source_path = page.path

      begin
        # For pages with a physical source file
        if File.exist?(source_path)
          page.data['date'] = File.mtime(source_path)
        else
          # For generated pages without a direct source file
          # Try to find an associated source file if possible
          # Otherwise use current time
          page.data['date'] = Time.now
        end
      rescue => e
        # Handle any errors by setting current time
        Jekyll.logger.warn("AutoDatePlugin:", "Error processing #{source_path}: #{e.message}")
        page.data['date'] = Time.now
      end
    end
  end
end
