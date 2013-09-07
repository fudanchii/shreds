Sidekiq.configure_server do |config|
    Sidetiq::Clock.start!
end

Sidetiq.configure do |config|
  config.resolution = 20
end
