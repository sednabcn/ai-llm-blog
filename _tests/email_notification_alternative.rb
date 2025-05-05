#!/usr/bin/env ruby
require 'net/http'
require 'uri'
require 'json'
require 'logger'

# Setup logging
logger = Logger.new(STDOUT)
logger.level = Logger::INFO

begin
  # Get environment variables
  webhook_url = ENV['EMAIL_WEBHOOK_URL'] # This should be a webhook URL for a service like Zapier, IFTTT, or custom endpoint

  if webhook_url.nil? || webhook_url.empty?
    logger.error "Missing EMAIL_WEBHOOK_URL environment variable"
    exit 1
  end

  run_id = ENV['GITHUB_RUN_ID'] || 'unknown'
  repo = ENV['GITHUB_REPOSITORY'] || 'unknown'
  workflow = ENV['GITHUB_WORKFLOW'] || 'unknown'
  
  logger.info "📧 Preparing to send notification via webhook..."
  
  # Prepare the data
  data = {
    subject: "⚠️ Broken Links Detected - #{repo}",
    message: "Broken links were detected during the Jekyll site deployment.",
    run_id: run_id,
    repository: repo,
    workflow: workflow,
    logs_url: "https://github.com/#{repo}/actions/runs/#{run_id}"
  }
  
  # Send the webhook request
  uri = URI.parse(webhook_url)
  http = Net::HTTP.new(uri.host, uri.port)
  
  # Use SSL if the webhook URL is https
  if uri.scheme == 'https'
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE # For testing only
  end
  
  # Set timeouts to avoid hanging
  http.open_timeout = 10
  http.read_timeout = 10
  
  request = Net::HTTP::Post.new(uri.request_uri)
  request['Content-Type'] = 'application/json'
  request.body = data.to_json
  
  logger.info "🔄 Sending webhook request..."
  response = http.request(request)
  
  if response.code.to_i >= 200 && response.code.to_i < 300
    logger.info "✅ Notification sent successfully! Response code: #{response.code}"
  else
    logger.warn "⚠️ Webhook returned non-success code: #{response.code}"
    logger.warn "Response body: #{response.body}"
  end

rescue => e
  logger.error "❌ Error sending notification: #{e.class} - #{e.message}"
  # Don't exit with error code to prevent workflow failure
  # Just log the error and continue
end

# Always exit with success to prevent workflow failure
exit 0
