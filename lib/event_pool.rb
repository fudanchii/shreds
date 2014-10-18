require 'redis-namespace'

class EventPool
  attr_reader  :pool
  def initialize(ns, rconf)
    @pool = ConnectionPool.new(size: 10, timeout: 30) do
      Redis.new rconf.dup
    end
  end

  def add(key, value, ex = 60)
    @pool.with { |conn| conn.set(key, value.to_json, ex: ex) }
  end

  def find(*keys)
    @pool.with { |conn| conn.mget(*keys) }
  end

  def remove(key)
    @pool.with { |conn| conn.del(key) }
  end

  def method_missing(cmd, *args, &block)
    @pool.with do |conn|
      if conn.respond_to? cmd
        conn.send(cmd, *args, &block)
      else
        super
      end
    end
  end
end
