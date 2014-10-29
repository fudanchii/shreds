require 'redis-namespace'

module EventPool
  def init(ns, rconf)
    connsize = rconf[:connections].to_i || 10
    timeout = rconf[:timeout].to_i || 30
    @pool ||= ConnectionPool.new(size: connsize, timeout: timeout) do
      Redis::Namespace.new ns, rconf
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

  def wrap
    yield @pool
  end

  module_function :init, :add, :find, :remove, :wrap
end
