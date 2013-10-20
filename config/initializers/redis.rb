require 'event_pool'

$redis = Redis.new(:driver => :hiredis)

EventPool.init('shreds:events', $redis)
