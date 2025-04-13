# Place this in /_plugins/tag_pages.rb

module Jekyll
  class TagPage < Page
    def initialize(site, base, dir, tag)
      @site = site
      @base = base
      @dir = dir
      @name = 'index.html'

      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), 'tag.html')
      self.data['tag'] = tag
      self.data['tag_normalized'] = tag.downcase
      self.data['title'] = "Tag: #{tag}"  # Keep original case for display
      self.data['permalink'] = "/tags/#{tag.downcase}/"
    end
  end

  class TagPageGenerator < Generator
    safe true

    def generate(site)
      if site.layouts.key? 'tag'
        dir = 'tags'
        site.tags.each_key do |tag|
          # Create normalized URL path
          tag_path = File.join(dir, tag.downcase)
          site.pages << TagPage.new(site, site.source, tag_path, tag)
        end
      end
    end
  end
end
