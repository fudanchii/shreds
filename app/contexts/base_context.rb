class BaseContext
  class_attribute :exec
  self.exec = nil

  def self.at_execution(*args, &block)
    self.exec = block_given? ? block : args.first.to_sym
  end

  def execute
    instance_eval(&exec) if exec.respond_to? :call
    send exec if exec.is_a? Symbol
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
