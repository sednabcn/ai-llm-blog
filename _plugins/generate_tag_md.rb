# generate_tag_pages.rb

require 'fileutils'

tags_dir = "tags"
layout = "tag"  # Make sure this matches your layout file name (tag.html)

# Create the folder if it doesn't exist
FileUtils.mkdir_p(tags_dir)

# Load all posts
Dir["_posts/*.md"].each do |filename|
  tags = []

  File.read(filename).each_line do |line|
    if line.strip.start_with?("tags:")
      # Capture inline or list-style tags
      if line.include?("[")
        tags = eval(line.split(":")[1].strip)
      else
        # Multiline tags: collect in next lines
        tags = []
        next_lines = File.read(filename).lines.drop_while { |l| l != line }.drop(1)
        next_lines.each do |l|
          break unless l =~ /^\s*-\s+/
          tags << l.strip.sub("- ", "")
        end
      end
      break
    end
  end

  tags.each do |tag|
    tag_slug = tag.downcase.strip.gsub(" ", "-")
    tag_file = File.join(tags_dir, "#{tag_slug}.md")
    next if File.exist?(tag_file)

    File.open(tag_file, "w") do |f|
      f.puts "---"
      f.puts "layout: #{layout}"
      f.puts "title: #{tag}"
      f.puts "tag: #{tag}"
      f.puts "permalink: /tags/#{tag_slug}/"
      f.puts "---"
      f.puts "Posts tagged with **#{tag}**."
    end
    puts "Created: #{tag_file}"
  end
end
