require 'message_bus'

if Rails.env.test?
  MessageBus.configure backend: :memory
else
  MessageBus.redis_config = $redis_config.merge(db: ENV.fetch('redis_db', '15').to_i)
end
