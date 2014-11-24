require 'redis-namespace'

module EventPool
  def init(ns, rconf)
    connsize = rconf[:connections].to_i
    timeout = rconf[:timeout].to_i
    connsize = 10 if connsize == 0
    timeout = 30 if timeout == 0
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

  def pipelined
    @pool.with { |conn| conn.pipelined { yield conn } }
  end

  def remove(key)
    @pool.with { |conn| conn.del(key) }
  end

  def wrap
    yield @pool
  end

  module_function :init, :add, :find, :pipelined, :remove, :wrap
end
