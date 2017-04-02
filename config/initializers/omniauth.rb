# frozen_string_literal: true

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer unless Rails.env.production?
  provider :twitter, ENV['twitter_key'], ENV['twitter_secret']
end

OmniAuth.config.full_host = ENV['app_host']
