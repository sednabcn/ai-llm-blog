module Jekyll
  class SitemapGenerator < Jekyll::Generator
    safe true
    priority :low  # Run this plugin after lastmod_injector
    
    def generate(site)
      # Hash to store unique URLs and their corresponding metadata
      sitemap_entries = {}
      
      # Define unwanted paths to exclude from sitemap
      unwanted_paths = [
        "/404.html", "/assets/", "/favicon.ico", "/sitemap.xml", "/feed.xml", 
        "/robots.txt", "/css/", "/js/"
      ]
      
      # Process posts first (they have proper dates by default)
      site.posts.docs.each do |post|
        process_item(post, site, sitemap_entries, unwanted_paths)
      end
      
      # Process pages
      site.pages.each do |page|
        process_item(page, site, sitemap_entries, unwanted_paths)
      end
      
      # Process collections
      site.collections.each do |name, collection|
        next if name == "posts"  # Skip posts as we've already processed them
        collection.docs.each do |doc|
          process_item(doc, site, sitemap_entries, unwanted_paths)
        end
      end
      
      # Create the sitemap.xml file
      write_sitemap(site, sitemap_entries)
      
      Jekyll.logger.info("SitemapGenerator:", "Generated sitemap.xml with #{sitemap_entries.size} URLs")
    end
    
    private
    
    def process_item(item, site, sitemap_entries, unwanted_paths)
      # Get URL from the item
      url = item.url
      
      # Skip if URL is nil or empty
      return if url.nil? || url.empty?
      
      # Skip unwanted paths
      return if unwanted_paths.any? { |path| url.include?(path) }
      
      # Skip if the URL is already in the sitemap_entries hash (deduplication)
      if sitemap_entries.key?(url)
        Jekyll.logger.debug("SitemapGenerator:", "Skipping duplicate URL: #{url}")
        return
      end
      
      # Get the lastmod date (already injected by LastModifiedGenerator)
      lastmod = item.data["lastmod"]
      
      # If lastmod is still missing, fall back to date or current time
      if lastmod.nil?
        if item.respond_to?(:date) && item.date
          lastmod = item.date
        elsif item.data["date"]
          lastmod = item.data["date"]
        else
          lastmod = Time.now
        end
      end
      
      # Format the lastmod in ISO 8601 format for better SEO
      formatted_lastmod = lastmod.strftime("%Y-%m-%dT%H:%M:%S%z")
      
      # Determine priority based on URL depth (shorter URLs typically more important)
      priority = calculate_priority(url)
      
      # Determine change frequency based on content type
      changefreq = calculate_changefreq(item)
      
      # Add the URL and its metadata to the sitemap_entries hash
      sitemap_entries[url] = {
        url: url,
        lastmod: formatted_lastmod,
        priority: priority,
        changefreq: changefreq
      }
      
      Jekyll.logger.debug("SitemapGenerator:", "Added #{url} with lastmod: #{formatted_lastmod}")
    end
    
    def calculate_priority(url)
      # Assign higher priority to home and top-level pages
      segments = url.split('/').reject(&:empty?)
      case segments.size
      when 0
        "1.0"  # Homepage
      when 1
        "0.8"  # Top-level pages
      when 2
        "0.6"  # Second-level pages
      else
        "0.4"  # Deeper pages
      end
    end
    
    def calculate_changefreq(item)
      # Determine change frequency based on content type or path
      if item.respond_to?(:collection) && item.collection
        case item.collection.label
        when "posts"
          "monthly"  # Blog posts rarely change
        else
          "weekly"   # Other collections change more often
        end
      else
        # For regular pages, use the path to guess
        if item.url == "/"
          "daily"    # Homepage changes frequently
        elsif item.url.include?("/tutorials/")
          "monthly"  # Tutorials are more stable
        else
          "weekly"   # Default for other pages
        end
      end
    end
    
    def write_sitemap(site, sitemap_entries)
      # Create or overwrite the sitemap.xml file
      sitemap_file = site.in_source_dir("sitemap.xml")
      
      File.open(sitemap_file, "w") do |file|
        file.puts('<?xml version="1.0" encoding="UTF-8"?>')
        file.puts('<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">')
        
        sitemap_entries.each do |_, data|
          file.puts("<url>")
          file.puts("  <loc>#{site.config['url']}#{data[:url]}</loc>")
          file.puts("  <lastmod>#{data[:lastmod]}</lastmod>")
          file.puts("  <changefreq>#{data[:changefreq]}</changefreq>")
          file.puts("  <priority>#{data[:priority]}</priority>")
          file.puts("</url>")
        end
        
        file.puts('</urlset>')
      end
    end
  end
end
