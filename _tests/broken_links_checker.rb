#!/usr/bin/env ruby
# Full Broken Links Checker – Sitemap + HTMLProofer + curl

require 'open-uri'
require 'rexml/document'
require 'fileutils'
require 'set'

# === Configuration ===
REMOTE_SITEMAP_URL  = "https://sednabcn.github.io/ai-llm-blog/sitemap.xml"
HTMLPROOFER_LOG     = "scripts/htmlproofer.log"
OUTPUT_FILE         = "scripts/broken_links_log.txt"
TIMEOUT_SECONDS     = 10

# === Helpers ===
def fetch_sitemap(url)
  puts "\n🌐 Fetching sitemap: #{url}"
  content = URI.open(url, read_timeout: TIMEOUT_SECONDS).read
  REXML::Document.new(content)
rescue => e
  puts "❌ Error fetching/parsing sitemap: #{e.message}"
  exit 1
end

def extract_sitemap_urls(xml)
  urls = []
  xml.elements.each('urlset/url/loc') { |loc| urls << loc.text.strip }
  puts "🔎 Found #{urls.size} URLs in sitemap."
  urls
end

def extract_links_from_htmlproofer(logfile)
  return [] unless File.exist?(logfile)
  puts "📄 Parsing additional links from #{logfile}..."
  urls = []
  File.readlines(logfile).each do |line|
    match = line.match(/(http[s]?:\/\/[^\s\)]+)/)
    urls << match[1] if match
  end
  puts "➕ Found #{urls.uniq.size} unique external links from htmlproofer log."
  urls.uniq
end

def check_url(url)
  cmd = "curl -o /dev/null -s -w \"%{http_code}\" --max-time #{TIMEOUT_SECONDS} #{url}"
  result = `#{cmd}`.strip
  status = result.to_i

  label = case status
          when 200 then "✅ 200 OK"
          when 301 then "↪️ 301 Moved"
          when 302 then "↪️ 302 Found"
          when 403 then "🚫 403 Forbidden"
          when 404 then "❌ 404 Not Found"
          when 0   then "⚠️ Timeout/Error"
          else          "❓ #{status} Unknown"
          end

  [url, status, label]
end

def write_results(results)
  FileUtils.mkdir_p(File.dirname(OUTPUT_FILE))
  File.open(OUTPUT_FILE, 'w') do |file|
    results.each { |url, code, label| file.puts("#{code} - #{label} - #{url}") }
  end
  puts "\n📝 Results written to #{OUTPUT_FILE}"
end

# === Main Execution ===
puts "=" * 80
puts "🔍 COMBINED BROKEN LINK CHECKER — SITEMAP + HTMLPROOFER + CURL".center(80)
puts "=" * 80

# Step 1: Collect URLs
sitemap_xml = fetch_sitemap(REMOTE_SITEMAP_URL)
sitemap_links = extract_sitemap_urls(sitemap_xml)
htmlproofer_links = extract_links_from_htmlproofer(HTMLPROOFER_LOG)

all_links = Set.new
all_links.merge(sitemap_links)
all_links.merge(htmlproofer_links)

puts "\n🔗 Total unique links to check: #{all_links.size}\n\n"

# Step 2: Check with curl
results = all_links.to_a.map.with_index do |url, idx|
  sleep 0.1  # Be nice to servers
  url, code, label = check_url(url)
  puts "#{label.ljust(20)} (#{idx + 1}/#{all_links.size}) → #{url}"
  [url, code, label]
end

# Step 3: Write logs
write_results(results)

# Step 4: Summarize broken links
broken = results.select { |_, code, _| code.to_i != 200 }

puts "\n✅ Done! Checked #{results.size} links."
puts "❌ #{broken.size} broken links detected." unless broken.empty?
puts "🎉 All good!" if broken.empty?

puts "\n" + "-" * 80
if broken.any?
  puts "❌ Summary of Broken Links:\n\n"
  puts "%-6s %-20s %s" % ["Code", "Status", "URL"]
  puts "-" * 80
  broken.each do |url, code, label|
    puts "%-6s %-20s %s" % [code, label, url]
  end
else
  puts "🎉 All good! No broken links found."
end
puts "-" * 80
