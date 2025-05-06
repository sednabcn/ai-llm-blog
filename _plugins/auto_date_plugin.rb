module Jekyll
  class AutoDateGenerator < Generator
    safe true
    priority :low

    def generate(site)
      # Loop through all pages and posts in the site
      site.pages.each do |page|
        # Skip pages that already have a 'date' or 'modified' field
        next if page.data['date'] || page.data['modified']

        # Add 'date' for pages based on file modification date
        if page.is_a?(Jekyll::Page)
          page.data['date'] = File.mtime(page.path)
        end

        # Optionally add 'modified' date if needed
        # If 'modified' is not already present, use 'date'
        page.data['modified'] ||= page.data['date']
      end

      # Handle posts separately if they are not handled above
      site.posts.each do |post|
        # Skip posts that already have a 'date' or 'modified' field
        next if post.data['date'] || post.data['modified']

        # Add 'date' for posts based on the post's front matter or file modification date
        post.data['date'] ||= post.date || File.mtime(post.path)

        # Add 'modified' date if it's missing
        post.data['modified'] ||= post.data['date']
      end
    end
  end
end
