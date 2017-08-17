# frozen_string_literal: true

Sidekiq.configure_client do |config|
  config.redis = $redis_pool
end

Sidekiq.configure_server do |config|
  config.redis = $redis_pool
end

Sidekiq.logger = nil if Rails.env.test?
