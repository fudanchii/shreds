Sidetiq.configure do |config|
  config.resolution = 20
  Sidekiq.logger = nil if Rails.env.test?
end
