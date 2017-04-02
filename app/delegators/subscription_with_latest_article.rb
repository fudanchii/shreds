# frozen_string_literal: true

class SubscriptionWithLatestArticle < SimpleDelegator
  attr_reader :latest_article

  def initialize(subscription, article)
    super(subscription)
    @latest_article = article
  end
end
