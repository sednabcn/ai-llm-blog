#!/usr/bin/env ruby
# frozen_string_literal: true

require 'nokogiri'
require 'uri'
require 'net/http'
require 'open-uri'
require 'set'

class OnlineBrokenLinksChecker
  def initialize(base_url)
    @base_url = base_url
    @checked_urls = Set.new
    @to_check = Set.new([@base_url])
    @results = []
    @internal_domain = URI.parse(@base_url).host
  end

  def scan
    puts "Starting scan of #{@base_url}..."
    puts "This may take a while depending on the size of your site."
    
    while !@to_check.empty? && @checked_urls.size < 500 # Limit to avoid infinite crawling
      current_url = @to_check.first
      @to_check.delete(current_url)
      
      next if @checked_urls.include?(current_url)
      @checked_urls.add(current_url)
      
      puts "Checking #{@checked_urls.size}: #{current_url}"
      check_url(current_url)
    end
    
    report_results
  end
  
  private
  
  def check_url(url)
    begin
      uri = URI.parse(url)
      is_internal = (uri.host == @internal_domain)
      
      # Make HTTP request to check link status
      response = fetch_url(uri)
      status = response.code.to_i
      
      # Record the result
      @results << {
        url: url,
        type: is_internal ? 'Internal' : 'External',
        status: status,
        status_text: status_text(status)
      }
      
      # If it's an internal page and HTML, extract and queue its links
      if is_internal && status < 400 && html_content?(response)
        extract_links(url, response.body)
      end
      
    rescue => e
      @results << {
        url: url,
        type: uri.host == @internal_domain ? 'Internal' : 'External',
        status: 0,
        status_text: "Error: #{e.message[0..50]}"
      }
    end
  end
  
  def fetch_url(uri)
    http = Net::HTTP.new(uri.host, uri.port)
    http.open_timeout = 10
    http.read_timeout = 10
    http.use_ssl = (uri.scheme == 'https')
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    
    path = uri.path.empty? ? '/' : uri.path
    path = path + '?' + uri.query if uri.query
    
    http.get(path, {
      'User-Agent' => 'Mozilla/5.0 (compatible; BrokenLinkChecker/1.0)'
    })
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
      
      # Resolve relative URLs
      absolute_url = URI.join(base_url, href).to_s
      
      # Only queue internal links for further crawling
      uri = URI.parse(absolute_url)
      if uri.host == @internal_domain && !@checked_urls.include?(absolute_url)
        @to_check.add(absolute_url)
      elsif !@checked_urls.include?(absolute_url)
        # Just check external links but don't crawl them
        @to_check.add(absolute_url)
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
    
    # Count problems
    broken_links = @results.select { |r| r[:status] >= 400 || r[:status] == 0 }
    
    puts "Broken links found: #{broken_links.size}"
    puts "\n====== BROKEN LINKS ======"
    
    if broken_links.empty?
      puts "No broken links found! 🎉"
    else
      # Print broken links
      puts "URL".ljust(80) + "Type".ljust(10) + "Status".ljust(8) + "Details"
      puts "-" * 120
      
      broken_links.each do |link|
        puts link[:url].ljust(80) + 
             link[:type].ljust(10) + 
             link[:status].to_s.ljust(8) + 
             link[:status_text]
      end
      
      # Export to file
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
      
      file.puts "URL".ljust(80) + "Type".ljust(10) + "Status".ljust(8) + "Details"
      file.puts "-" * 120
      
      broken_links.each do |link|
        file.puts link[:url].ljust(80) + 
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
  OnlineBrokenLinksChecker.new(url).scan
end
