class BaseContext
  class_attribute :exec
  self.exec = nil

  def self.at_execution(&block)
    self.exec = block
  end

  def execute
    instance_eval(&exec) if exec
    result
  end

  def result
    @result || self
  end

  def method_missing(name, *args, &block)
    if name.to_s =~ /^have_(.+)$/
      @result = instance_variable_get("@#{$1}")
      self
    else
      super
    end
  end
end
