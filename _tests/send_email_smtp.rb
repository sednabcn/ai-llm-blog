require 'net/smtp'
require 'openssl'

# Read environment variables
from_email = ENV['SMTP_USERNAME']
to_email   = ENV['TO_EMAIL'] || from_email
smtp_host  = ENV['SMTP_HOST']
smtp_port  = ENV['SMTP_PORT'] || '465'
smtp_pass  = ENV['SMTP_PASSWORD']

# Compose email
subject = "Broken Links Detected in Jekyll Site"
body = <<~EMAIL
  Dear User,

  ❌ Broken links were detected during your Jekyll site deployment.

  🔍 Check the logs:
  https://github.com/#{ENV['GITHUB_REPOSITORY']}/actions/runs/#{ENV['GITHUB_RUN_ID']}

  Best,
  GitHub Actions
EMAIL

message = <<~MSG
  From: #{from_email}
  To: #{to_email}
  Subject: #{subject}

  #{body}
MSG

# Create a secure TLS connection for port 465
smtp = Net::SMTP.new(smtp_host, smtp_port.to_i)
smtp.enable_tls(OpenSSL::SSL::VERIFY_PEER)

smtp.start('localhost', from_email, smtp_pass, :login) do |smtp_conn|
  smtp_conn.send_message message, from_email, to_email
end

puts "✅ Secure email sent to #{to_email} via TLS (port 465)"
