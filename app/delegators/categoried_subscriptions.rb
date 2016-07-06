class CategoriedSubscriptions < SimpleDelegator
  attr_reader :subscriptions

  def initialize(category, subscriptions)
    super(category)
    @subscriptions = subscriptions
  end
end
