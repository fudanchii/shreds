# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!

RactiveAssets::Config.compiler_path = File.dirname(Rails.application.assets.resolve('ractive/ractive'))
