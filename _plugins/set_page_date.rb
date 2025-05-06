# _plugins/set_page_date.rb
module Jekyll
  class SetPageDate < Generator
    safe true
    priority :low

    def generate(site)
      site.pages.each do |page|
        # Add 'date' if it's missing
        page.data["date"] ||= Time.now
      end
    end
  end
end
