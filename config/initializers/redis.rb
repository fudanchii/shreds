require 'event_pool'

EventPool.init('shreds:events', Redis.new(driver: :hiredis))
