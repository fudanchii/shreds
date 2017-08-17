# frozen_string_literal: true

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer unless Rails.env.production?
  provider :twitter, Settings.twitter.key, Settings.twitter.secret
end

OmniAuth.config.full_host = Settings.app.host
