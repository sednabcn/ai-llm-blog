Jekyll::Hooks.register :site, :post_write do |site|
  # Delete unwanted files after site generation
  File.delete(File.join(site.dest, "robots.txt")) if File.exist?(File.join(site.dest, "robots.txt"))
  File.delete(File.join(site.dest, "sitemap.xml")) if File.exist?(File.join(site.dest, "sitemap.xml"))
  Jekyll.logger.info "Cleanup:", "Removed robots.txt and sitemap.xml"
end
