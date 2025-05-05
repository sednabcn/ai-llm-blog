#!/usr/bin/env ruby
require 'mail'
require 'logger'

# Setup logging
logger = Logger.new(STDOUT)
logger.level = Logger::INFO

begin
  # Get environment variables
  smtp_username = ENV['SMTP_USERNAME']
  smtp_password = ENV['SMTP_PASSWORD']
  smtp_host = ENV['SMTP_HOST']
  smtp_port = ENV['SMTP_PORT'] || '587'
  to_email = ENV['TO_EMAIL']
  
  # Check if required variables are set
  if [smtp_username, smtp_password, smtp_host, to_email].any?(&:nil?)
    logger.error "Missing required environment variables for email notification"
    exit 1
  end

  run_id = ENV['GITHUB_RUN_ID'] || 'unknown'
  repo = ENV['GITHUB_REPOSITORY'] || 'unknown'
  
  logger.info "📧 Preparing to send email to #{to_email} via #{smtp_host}:#{smtp_port}..."
  
  # Configure Mail with a timeout
  Mail.defaults do
    delivery_method :smtp, {
      address: smtp_host,
      port: smtp_port.to_i,
      user_name: smtp_username,
      password: smtp_password,
      authentication: 'plain',
      enable_starttls_auto: true,
      open_timeout: 10,   # 10 seconds timeout for opening connections
      read_timeout: 10,   # 10 seconds timeout for reading operations
      ssl_timeout: 10,    # 10 seconds timeout for SSL operations
      # Common SMTP troubleshooting settings
      tls: true,          # Try explicit TLS
      ssl: true,          # Try SSL connection
      verify_mode: OpenSSL::SSL::VERIFY_NONE  # For troubleshooting, change to VERIFY_PEER in production
    }
  end
  
  # Create the email
  mail = Mail.new do
    from     smtp_username
    to       to_email
    subject  "⚠️ Broken Links Detected - #{repo}"
    
    text_part do
      body "Broken links were detected during the Jekyll site deployment.\n\nPlease check the logs at: https://github.com/#{repo}/actions/runs/#{run_id}"
    end
    
    html_part do
      content_type 'text/html; charset=UTF-8'
      body "<h2>⚠️ Broken Links Detected</h2><p>Broken links were detected during the Jekyll site deployment.</p><p><a href='https://github.com/#{repo}/actions/runs/#{run_id}'>View the complete logs</a></p>"
    end
  end
  
  # Send the email with error handling
  begin
    Timeout::timeout(30) do  # Overall timeout of 30 seconds for the send operation
      mail.deliver!
      logger.info "✅ Email notification sent successfully!"
    end
  rescue Timeout::Error
    logger.error "❌ Email sending timed out after 30 seconds"
    exit 1
  rescue => e
    logger.error "❌ Error sending email: #{e.class} - #{e.message}"
    exit 1
  end

rescue => e
  logger.error "❌ Script error: #{e.class} - #{e.message}"
  exit 1
end
