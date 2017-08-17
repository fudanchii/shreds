# frozen_string_literal: true

require 'redis-namespace'

redis_default = ['127.0.0.1:6379']

redis_conns = if Settings.redis.conns.to_i <= 0
                10
              else
                Settings.redis.conns.to_i
              end

redis_timeout = if Settings.redis.timeout.to_i <= 0
                  30
                else
                  Settings.redis.timeout.to_i
                end

redis_host = Settings.redis.host ||
  (Settings.cache.servers || redis_default).first
     .split(':').first

redis_port = Settings.redis.port ||
  (Settings.cache.servers || redis_default).first
     .split(':').last.to_i || 6379

$redis_config = {
  driver: :hiredis,
  host: redis_host,
  port: redis_port,
  password: Settings.redis.password
}

$redis_pool = ConnectionPool.new(size: redis_conns, timeout: redis_timeout) do
  Redis::Namespace.new 'shreds', redis: Redis.new($redis_config)
end
