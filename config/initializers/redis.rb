uri = ENV["REDISTOGO_URL"] || "redis://localhost:6379/"
REDIS = Redis.new(:url => uri)

Sidekiq.configure_server do |config|
  config.redis = { url: "redis://localhost:6379/" }
end

Sidekiq.configure_client do |config|
  config.redis = { url: "redis://localhost:6379/" }
end