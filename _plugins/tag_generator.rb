module Jekyll
  class TagPageGenerator < Generator
    safe true

    def generate(site)
      site.tags.each do |tag, posts|
        site.pages << TagPage.new(site, tag, posts)
      end
    end
  end

  class TagPage < Page
    def initialize(site, tag, posts)
      @site = site
      @base = site.source
      @dir = "tags"
      @name = "#{tag.to_s.downcase.gsub(' ', '-')}.html"

      self.process(@name)
      self.read_yaml(File.join(@base, '_layouts'), 'tags.html')
      
      # Set variables that will be available in the layout
      self.data['title'] = tag
      self.data['description'] = "All posts tagged with #{tag}"
      self.data['slug'] = tag.to_s.downcase.gsub(' ', '-')
      self.data['permalink'] = "/tags/#{tag.to_s.downcase.gsub(' ', '-')}/"
    end
  end
end
