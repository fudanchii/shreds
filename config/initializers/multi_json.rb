require 'multi_json'

MultiJson.dump_options = { pretty: true } unless Rails.env.production?
