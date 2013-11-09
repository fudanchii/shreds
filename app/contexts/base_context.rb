class BaseContext
  class_attribute :result
  self.result = self

  def method_missing(name, *args, &block)
    if /^have_(.+)/ =~ name.to_s
      self.result = instance_variable_get("@#{$1}")
      self
    else
      super
    end
  end
end
