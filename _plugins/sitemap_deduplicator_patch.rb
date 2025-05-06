require 'open3'
require 'time'

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
        inject_lastmod(item)
        unique_pages << item
      end

      site.pages.replace(unique_pages.select { |p| p.is_a?(Jekyll::Page) })
      site.posts.docs.replace(unique_pages.select { |p| p.is_a?(Jekyll::Document) })
    end

    private

    def inject_lastmod(item)
      return if item.data.key?('lastmod')
      return unless File.exist?(item.path)

      lastmod = git_last_modified(item.path) || file_last_modified(item.path)
      item.data['lastmod'] = lastmod if lastmod
    end

    def git_last_modified(filepath)
      cmd = "git log -1 --format=\"%Y-%m-%d\" -- #{filepath}"
      stdout, _stderr, status = Open3.capture3(cmd)
      status.success? ? stdout.strip : nil
    end

    def file_last_modified(filepath)
      Time.at(File.mtime(filepath)).strftime("%Y-%m-%d")
    rescue
      nil
    end
  end
end
