#!/usr/bin/env ruby
# frozen_string_literal: true

require 'nokogiri'
require 'uri'
require 'net/http'
require 'open-uri'
require 'set'

class SitemapBrokenLinksChecker
  def initialize(base_url)
    @base_url = base_url
    @checked_urls = Set.new
    @to_check = {}
    @results = []
    @internal_domain = URI.parse(@base_url).host
    @sitemap_urls = []
  end

  def scan
    puts "Starting scan of #{@base_url}..."
    sitemap_url = find_sitemap_url(@base_url)

    if sitemap_url
      puts "Found sitemap at: #{sitemap_url}"
      process_sitemap(sitemap_url)
      puts "Found #{@sitemap_urls.size} URLs in sitemap"
    else
      puts "No sitemap.xml found. Using base URL."
      @to_check[@base_url] = nil  # No source for the base page
    end

    # Add the sitemap URLs to the to_check list
    @sitemap_urls.each { |url| @to_check[url] = nil }

    puts "Checking #{@to_check.size} URLs..."
    while !@to_check.empty? && @checked_urls.size < 500
      current_url, source_url = @to_check.shift
      next if @checked_urls.include?(current_url)

      @checked_urls.add(current_url)
      puts "Checking #{@checked_urls.size}: #{current_url}"
      check_url(current_url, source_url)
    end

    report_results
  end

  private

  def find_sitemap_url(base_url)
    candidates = [
      "#{base_url}/sitemap.xml",
      "#{base_url}/sitemap_index.xml",
      "#{base_url}/sitemap-index.xml"
    ]

    begin
      robots_url = "#{base_url}/robots.txt"
      response = safe_fetch(URI.parse(robots_url))
      if response.code.to_i == 200
        response.body.lines.grep(/^Sitemap:/i).each do |line|
          candidates.unshift(line.split(':', 2)[1].strip)
        end
      end
    rescue => e
      puts "robots.txt error: #{e.message}"
    end

    candidates.each do |url|
      begin
        response = safe_fetch(URI.parse(url))
        if response.code.to_i == 200 && response.body =~ /<urlset|<sitemapindex/
          return url
        end
      rescue => e
        puts "Sitemap check failed: #{url} (#{e.message})"
      end
    end

    nil
  end

  def process_sitemap(sitemap_url)
    response = safe_fetch(URI.parse(sitemap_url))
    return unless response.code.to_i == 200

    xml = Nokogiri::XML(response.body)

    if xml.at_xpath('//xmlns:sitemapindex', 'xmlns' => 'http://www.sitemaps.org/schemas/sitemap/0.9')
      xml.xpath('//xmlns:sitemap/xmlns:loc', 'xmlns' => 'http://www.sitemaps.org/schemas/sitemap/0.9').each do |loc|
        process_sitemap(loc.content.strip)
      end
    else
      xml.xpath('//xmlns:url/xmlns:loc', 'xmlns' => 'http://www.sitemaps.org/schemas/sitemap/0.9').each do |loc|
        @sitemap_urls << loc.content.strip
      end
    end
  end

  def check_url(url, source_url = nil)
    uri = URI.parse(url)
    is_internal = (uri.host == @internal_domain)

    begin
      response = safe_fetch(uri)
      status = response.code.to_i

      @results << {
        url: url,
        source: source_url,
        type: is_internal ? 'Internal' : 'External',
        status: status,
        status_text: status_text(status)
      }

      if is_internal && status < 400 && html_content?(response)
        extract_links(url, response.body)
      end
    rescue => e
      @results << {
        url: url,
        source: source_url,
        type: is_internal ? 'Internal' : 'External',
        status: 0,
        status_text: "Error: #{e.message[0..50]}"
      }
    end
  end

  def safe_fetch(uri, retries = 3)
    fetch_url(uri)
  rescue => e
    retries > 0 ? (sleep 1; safe_fetch(uri, retries - 1)) : raise(e)
  end

  def fetch_url(uri, limit = 3)
    raise 'Too many HTTP redirects' if limit == 0

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = (uri.scheme == 'https')
    http.open_timeout = 10
    http.read_timeout = 10

    request = Net::HTTP::Get.new(uri.request_uri)
    request['User-Agent'] = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113 Safari/537.36'
    request['Accept'] = '*/*'
    request['Accept-Language'] = 'en-US,en;q=0.9'

    response = http.request(request)

    case response
    when Net::HTTPRedirection
      new_uri = URI.join(uri, response['location'])
      fetch_url(new_uri, limit - 1)
    else
      response
    end
  end

  def html_content?(response)
    content_type = response['content-type']
    content_type && content_type.include?('text/html')
  end

  def extract_links(base_url, html)
    doc = Nokogiri::HTML(html)

    doc.css('a[href]').each do |link|
      href = link['href']
      next if href.nil? || href.empty? || href.start_with?('#', 'mailto:', 'javascript:', 'tel:')

      absolute_url = URI.join(base_url, href).to_s
      uri = URI.parse(absolute_url)

      if uri.host == @internal_domain
        @to_check[absolute_url] = base_url unless @checked_urls.include?(absolute_url) || @to_check.key?(absolute_url)
      end
    end
  end

  def status_text(code)
    case code
    when 200..299 then 'OK'
    when 300..399 then 'Redirect'
    when 400..499 then 'Client Error'
    when 500..599 then 'Server Error'
    else 'Unknown'
    end
  end

  def report_results
    puts "\n====== SCAN COMPLETE ======"
    puts "Total URLs checked: #{@checked_urls.size}"
    puts "Broken links found: #{@results.count { |r| r[:status] >= 400 || r[:status] == 0 }}"
    puts "\n====== BROKEN LINKS ======"

    broken_links = @results.select { |r| r[:status] >= 400 || r[:status] == 0 }

    if broken_links.empty?
      puts "No broken links found! 🎉"
    else
      puts "SOURCE PAGE".ljust(80) + "BROKEN URL".ljust(80) + "Type".ljust(10) + "Status".ljust(8) + "Details"
      puts "-" * 120
      broken_links.each do |link|
        puts (link[:source] || '[Sitemap]').ljust(80) + 
             link[:url].ljust(80) + 
             link[:type].ljust(10) + 
             link[:status].to_s.ljust(8) + 
             link[:status_text]
      end
      export_to_file(broken_links)
    end
  end

  def export_to_file(broken_links)
    filename = "broken_links_#{Time.now.strftime('%Y%m%d_%H%M%S')}.txt"
    File.open(filename, 'w') do |file|
      file.puts "BROKEN LINKS REPORT"
      file.puts "Website: #{@base_url}"
      file.puts "Date: #{Time.now}"
      file.puts "Total URLs checked: #{@checked_urls.size}"
      file.puts "Broken links found: #{broken_links.size}"
      file.puts "\n"

      file.puts "SOURCE PAGE".ljust(80) + "BROKEN URL".ljust(80) + "Type".ljust(10) + "Status".ljust(8) + "Details"
      file.puts "-" * 120
      broken_links.each do |link|
        file.puts (link[:source] || '[Sitemap]').ljust(80) + 
                  link[:url].ljust(80) + 
                  link[:type].ljust(10) + 
                  link[:status].to_s.ljust(8) + 
                  link[:status_text]
      end
    end
    puts "\nReport saved to #{filename}"
  end
end

# Run the checker
if __FILE__ == $0
  url = ARGV[0] || "https://sednabcn.github.io/ai-llm-blog/"
  SitemapBrokenLinksChecker.new(url).scan
end
