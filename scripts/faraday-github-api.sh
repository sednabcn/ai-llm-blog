require 'faraday'
require 'json'

GITHUB_API = "https://api.github.com/repos/sednabcn/ai-llm-blog"

conn = Faraday.new(url: GITHUB_API) do |faraday|
  faraday.adapter Faraday.default_adapter
end

response = conn.get

if response.success?
  repo_data = JSON.parse(response.body)
  puts "Repository Name: #{repo_data['name']}"
  puts "Owner: #{repo_data['owner']['login']}"
  puts "Stars: #{repo_data['stargazers_count']}"
  puts JSON.pretty_generate(repo_data)
else
  puts "Failed to fetch repository details. Status: #{response.status}"
end
