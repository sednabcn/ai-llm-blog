require 'open3'

module Jekyll
  class LastModifiedGenerator < Generator
    priority :low

    def generate(site)
      site.posts.docs.each { |doc| inject_lastmod(doc) }
      site.pages.each { |page| inject_lastmod(page) }
    end

    private

    def inject_lastmod(doc)
      return if doc.data.key?('lastmod')

      path = doc.path
      return unless File.exist?(path)

      git_date = git_last_modified(path)
      doc.data['lastmod'] = git_date if git_date
    end

    def git_last_modified(path)
      cmd = "git log -1 --format=\"%Y-%m-%d\" -- #{path}"
      stdout, _stderr, status = Open3.capture3(cmd)
      status.success? ? stdout.strip : nil
    end
  end
end
