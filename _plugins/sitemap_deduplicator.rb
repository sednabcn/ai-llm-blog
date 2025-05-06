module Jekyll
  class SitemapDeduplicator < Jekyll::Generator
    safe true

    def generate(site)
      # Hash to store unique URLs and their corresponding pages
      seen_urls = {}

      # Define unwanted paths to exclude from sitemap (e.g., 404 pages, assets, etc.)
      unwanted_paths = [
        "/404.html", "/assets/", "/tags/", "/categories/", "/help/", "/favicon.ico", "/sitemap.xml", "/feed.xml"
      ]

      # Iterate through all pages in the site
      site.pages.each do |page|
        # Skip unwanted paths
        next if unwanted_paths.any? { |path| page.url.include?(path) }

        # Skip pages without a URL (e.g., non-page objects like collections)
        next if page.url.nil? || page.url.empty?

        # Skip if the URL is already in the seen_urls hash (deduplication step)
        if seen_urls.key?(page.url)
          Jekyll.logger.info("Skipping duplicate URL:", page.url)
          next
        end

        # Ensure the lastmod field is added (using page's modified date or current date)
        lastmod = page.data["lastmod"] || page.date || Time.now

        # Format the lastmod in ISO 8601 format for better SEO
        formatted_lastmod = lastmod.strftime("%Y-%m-%dT%H:%M:%S%z")

        # Log the URL and lastmod for debugging purposes
        Jekyll.logger.info("Including URL:", page.url)
        Jekyll.logger.info("Lastmod:", formatted_lastmod)

        # Add the URL and its corresponding page to the seen_urls hash
        seen_urls[page.url] = { url: page.url, lastmod: formatted_lastmod }
      end

      # Create or overwrite the sitemap.xml file with deduplicated URLs and lastmod
      sitemap_file = site.in_source_dir("sitemap.xml")
      File.open(sitemap_file, "w") do |file|
        file.puts('<?xml version="1.0" encoding="UTF-8"?>')
        file.puts('<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">')

        seen_urls.each do |url, data|
          file.puts("<url>")
          file.puts("<loc>#{site.url}#{url}</loc>")
          file.puts("<lastmod>#{data[:lastmod]}</lastmod>")
          file.puts("</url>")
        end

        file.puts('</urlset>')
      end

      Jekyll.logger.info("Sitemap generated with #{seen_urls.length} URLs")
    end
  end
end
