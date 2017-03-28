# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment', __FILE__)

if defined? PhusionPassenger
  run Shreds::Application
else
  ENV["RAILS_RELATIVE_URL_ROOT"] ||= "/"

  map ENV["RAILS_RELATIVE_URL_ROOT"] do
    run Shreds::Application
  end
end
