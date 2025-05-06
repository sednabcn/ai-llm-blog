module Jekyll
  class SitemapDeduplicator < Generator
    priority :highest

    def generate(site)
      seen_urls = {}
      unique_pages = []

      all_items = site.pages + site.posts.docs
      all_items.each do |item|
        url = item.url
        next if seen_urls.key?(url)

        seen_urls[url] = true
        unique_pages << item
      end

      # Replace pages and posts with deduplicated versions for plugins like jekyll-sitemap
      site.pages.replace(unique_pages.select { |p| p.is_a?(Jekyll::Page) })
      site.posts.docs.replace(unique_pages.select { |p| p.is_a?(Jekyll::Document) })
    end
  end
end
