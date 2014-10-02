Shreds::Application.config.feedjira = {
  :ssl_verify_peer => ENV.key?('ssl_verify')
}
