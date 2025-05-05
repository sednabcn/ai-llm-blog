#!/usr/bin/env ruby
# Updated SMTP email script compatible with newer Net::SMTP versions

require 'net/smtp'
require 'mail'

# Get configuration from environment variables
smtp_username = ENV['SMTP_USERNAME'] || abort('SMTP_USERNAME is required')
smtp_password = ENV['SMTP_PASSWORD'] || abort('SMTP_PASSWORD is required')
smtp_host = ENV['SMTP_HOST'] || abort('SMTP_HOST is required')
smtp_port = (ENV['SMTP_PORT'] || '587').to_i
to_email = ENV['TO_EMAIL'] || abort('TO_EMAIL is required')

from_email = smtp_username
subject = ENV['EMAIL_SUBJECT'] || 'Test Email'
body = ENV['EMAIL_BODY'] || 'This is a test email sent from Ruby script.'

puts "📧 Preparing to send email to #{to_email} via #{smtp_host}:#{smtp_port}..."

begin
  # Create a new Mail message
  message = Mail.new do
    from     from_email
    to       to_email
    subject  subject
    body     body
  end

  # Configure delivery method
  message.delivery_method :smtp, {
    address: smtp_host,
    port: smtp_port,
    user_name: smtp_username,
    password: smtp_password,
    authentication: 'plain',
    enable_starttls_auto: true
  }

  # Send the message
  message.deliver!
  puts "✅ Email sent successfully to #{to_email}"
rescue => e
  puts "❌ Error sending email: #{e.class} - #{e.message}"
  puts e.backtrace[0..5].join("\n") if ENV['DEBUG']
  exit 1
end
