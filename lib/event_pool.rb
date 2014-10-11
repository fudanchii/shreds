require 'redis-namespace'

class EventPool
  @redis = nil
  def self.init(ns, redis)
    @redis = Redis::Namespace.new(ns, redis: redis)
  end

  def self.add(key, value, ex = 60)
    @redis.set(key, value.to_json, ex: ex)
  end

  def self.find(*keys)
    @redis.mget(*keys)
  end

  def self.remove(key)
    @redis.del(key)
  end

  def self.method_missing(cmd, *args, &block)
    if @redis.respond_to? cmd
      @redis.send(cmd, *args, &block)
    else
      super
    end
  end
end
