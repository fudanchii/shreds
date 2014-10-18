require 'event_pool'

$evpool = EventPool.new('shreds:events', driver: :hiredis,
                                         host: (ENV['redis_host'] || 'localhost'),
                                         port: (ENV['redis_port'] || '6379'))
