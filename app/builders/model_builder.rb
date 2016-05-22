class ModelBuilder
  class << self
    def builder_attr(*attrs)
      @@attrs = attrs
    end
  end

  def initialize
    @@attrs.each {|attr| instance_variable_set "@#{attr}", nil }
  end

  def method_missing(name, *args, &block)
    if @@attrs.include? name
      instance_variable_set "@#{name}", args.first
    end
    self
  end
end
