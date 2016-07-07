class FeedArticlesSerializer < ApplicationSerializer
  include Rails.application.routes.url_helpers

  attributes :id,
             :category_id,
             :subscription_id,
             :title,
             :path,
             :url,
             :articles

  def category_id
    object.category_id
  end

  def subscription_id
    object.subscription_id
  end

  def path
    feed_path object
  end

  def articles
    ArticlesIndexSerializer.new(object.articles)
  end
end
