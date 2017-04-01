require 'redis-namespace'

redis_default = '127.0.0.1:6379'

redis_conns = ENV['redis_conns'].to_i <= 0 ?
                10 :
                ENV['redis_conns'].to_i

redis_timeout = ENV['redis_timeout'].to_i <= 0 ?
                  30 :
                  ENV['redis_timeout'].to_i

redis_host = ENV.fetch('redis_host') do
  ENV.fetch('cache_servers', redis_default).split(',').first
     .split(':').first
end

redis_port = ENV.fetch('redis_port') do
  ENV.fetch('cache_servers', redis_default).split(',').first
     .split(':').last.to_i || 6379
end

$redis_config = {
  driver: :hiredis,
  host: redis_host,
  port: redis_port,
  password: ENV['redis_password']
}

$redis_pool = ConnectionPool.new(size: redis_conns, timeout: redis_timeout) do
  Redis::Namespace.new 'shreds', $redis_config
end
