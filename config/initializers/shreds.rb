# frozen_string_literal: true

Shreds::Application.config.feedjira = {
  ssl_verify_peer: Settings.ssl_verify
}

require 'shreds/exceptions'
