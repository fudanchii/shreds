# frozen_string_literal: true

class CategoriedSubscriptions < SimpleDelegator
  attr_reader :subscriptions

  def initialize(category, subscriptions)
    super(category)
    @subscriptions = subscriptions
  end

  def self.model_name
    'category'
  end
end
