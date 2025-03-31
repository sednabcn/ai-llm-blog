require 'faraday'
require 'faraday/retry'

conn = Faraday.new(url: 'https://sednabcn.github.io/ai-llm-blog') do |faraday|
  faraday.request :retry, max: 5, interval: 0.5, backoff_factor: 2
  faraday.adapter Faraday.default_adapter
end

response = conn.get('/')
puts response.status
puts response.body
