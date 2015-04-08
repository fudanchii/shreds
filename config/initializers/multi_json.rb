require 'multi_json'
unless Rails.env.production?
    MultiJson.dump_options = { pretty: true }
end
