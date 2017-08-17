Config.setup do |config|
  config.const_name = 'Settings'
  config.use_env = true
  config.env_prefix = 'SHREDS'
  config.env_separator = '__'
  config.env_converter = :downcase
  config.env_parse_values = true
end
