#!/usr/bin/env ruby
# File: ./tests/send_email_smtp.rb
# This script sends email notifications when broken links are found

require 'net/smtp'
require 'date'

# Get environment variables
smtp_username = ENV['SMTP_USERNAME']
smtp_password = ENV['SMTP_PASSWORD']
smtp_host = ENV['SMTP_HOST'] || 'smtp.gmail.com'
smtp_port = ENV['SMTP_PORT'] || '587'
to_email = ENV['TO_EMAIL']

# Validate required environment variables
if smtp_username.nil? || smtp_password.nil? || to_email.nil?
  puts "Error: Missing required environment variables for email notification"
  puts "Make sure SMTP_USERNAME, SMTP_PASSWORD, and TO_EMAIL are set"
  exit 1
end

# Email content
from = smtp_username
to = to_email
subject = "⚠️ Broken Links Found in AI-LLM Blog"
date = DateTime.now.strftime("%a, %d %b %Y %H:%M:%S %z")
repo_name = ENV['GITHUB_REPOSITORY'] || "sednabcn/ai-llm-blog"
run_id = ENV['GITHUB_RUN_ID'] || "unknown"
actions_url = "https://github.com/#{repo_name}/actions/runs/#{run_id}"

# Try to read the broken links log if available
broken_links_content = ""
if File.exist?('broken-links.log')
  broken_links_content = File.read('broken-links.log')
else
  broken_links_content = "Detailed broken links log not available."
end

# Limit the content to avoid email size issues
if broken_links_content.length > 1500
  broken_links_content = broken_links_content[0..1500] + "\n...(truncated, see full log in GitHub Actions)"
end

# Construct the email message
message = <<MESSAGE_END
From: AI-LLM Blog Checker <#{from}>
To: Site Admin <#{to}>
Subject: #{subject}
Date: #{date}
Content-Type: text/plain; charset=UTF-8

Broken links were detected in the AI-LLM Blog during the latest automated check.

GitHub Actions Run: #{actions_url}

Please review the broken links and fix them as soon as possible:

#{broken_links_content}

This is an automated message from the GitHub Actions workflow.
MESSAGE_END

puts "Sending email notification to #{to_email}..."

begin
  # Set up SMTP client
  smtp = Net::SMTP.new(smtp_host, smtp_port.to_i)
  smtp.enable_starttls if smtp.respond_to?(:enable_starttls)
  
  # Send the email
  smtp.start('localhost', smtp_username, smtp_password, :login) do |smtp|
    smtp.send_message(message, from, to)
  end
  
  puts "Email notification sent successfully!"
rescue => e
  puts "Error sending email: #{e.message}"
  exit 1
end
