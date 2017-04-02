# frozen_string_literal: true

require 'message_bus'
require 'shreds/authentication'

if Rails.env.test?
  MessageBus.configure backend: :memory
else
  MessageBus.redis_config = $redis_config.merge(db: ENV.fetch('redis_db', '15').to_i)
end

MessageBus.user_id_lookup do |env|
  req = Rack::Request.new(env)
  req.session[Shreds::Auth::USER_TOKEN] if req.session
end
