Sidekiq.configure_client do |config|
  config.redis = $evpool.pool
end

Sidekiq.configure_server do |config|
  config.redis = $evpool.pool
end

Sidetiq.configure do |config|
  config.resolution = 20
end

Sidekiq.logger = nil if Rails.env.test?
