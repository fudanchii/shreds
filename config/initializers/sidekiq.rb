Sidekiq.configure_client do |config|
  EventPool.wrap { |pool| config.redis = pool }
end

Sidekiq.configure_server do |config|
  EventPool.wrap { |pool| config.redis = pool }

  schedule_file = 'config/schedule.yml'
  if File.exist? schedule_file
    Sidekiq::Cron::Job.load_from_hash YAML.load_file(schedule_file)
  end
end

Sidekiq.logger = nil if Rails.env.test?
