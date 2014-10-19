Sidekiq.configure_client do |config|
  EventPool.wrap { |pool| config.redis = pool }
end

Sidekiq.configure_server do |config|
  EventPool.wrap { |pool| config.redis = pool }
end

Sidetiq.configure do |config|
  config.resolution = 20
end

Sidekiq.logger = nil if Rails.env.test?
