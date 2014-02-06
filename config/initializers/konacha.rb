Konacha.configure do |config|
  require 'capybara/poltergeist'
  config.verbose      = true
  config.spec_dir     = "test/javascripts"
  config.spec_matcher = /_spec\.|_test\./
  config.stylesheets  = %w(application)
  config.driver       = :poltergeist
end if defined?(Konacha)
