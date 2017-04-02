# frozen_string_literal: true

# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!

RactiveAssets::Config.compiler_path = File.dirname(Rails.application.assets.resolve('ractive/ractive'))
