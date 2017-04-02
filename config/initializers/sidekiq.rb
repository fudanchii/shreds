# frozen_string_literal: true

Sidekiq.configure_client do |config|
  config.redis = $redis_pool
end

Sidekiq.configure_server do |config|
  config.redis = $redis_pool

  schedule_file = 'config/schedule.yml'
  if File.exist? schedule_file
    Sidekiq::Cron::Job.load_from_hash YAML.load_file(schedule_file)
  end
end

Sidekiq.logger = nil if Rails.env.test?
