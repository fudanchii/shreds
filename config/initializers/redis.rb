require 'event_pool'

EventPool.init('shreds:events', driver: :hiredis,
                                host: (ENV['redis_host'] || 'localhost'),
                                port: (ENV['redis_port'] || '6379'))
