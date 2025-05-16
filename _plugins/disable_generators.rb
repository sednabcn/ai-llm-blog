module Jekyll
  class Site
    alias_method :original_generators, :generators
    
    def generators
      original_generators.reject do |generator|
        generator.class.name == 'Jekyll::SitemapGenerator' || 
        generator.class.name.include?('Sitemap') ||
        generator.class.name.include?('Robots')
      end
    end
  end
end
