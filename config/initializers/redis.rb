require 'event_pool'

EventPool.init('shreds:events', driver: :hiredis,
                                host: ENV['redis_host'],
                                port: ENV['redis_port'],
                                timeout: ENV['redis_timeout'],
                                connections: ENV['redis_conns'])
