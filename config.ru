# This file is used by Rack-based servers to start the application.
ENV['RAILS_RELATIVE_URL_ROOT'] ||= '/'

require ::File.expand_path('../config/environment', __FILE__)

if defined? PhusionPassenger
  run Shreds::Application
else
  map ENV['RAILS_RELATIVE_URL_ROOT'] do
    run Shreds::Application
  end
end
