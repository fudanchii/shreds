class FeedArticlesSerializer < ApplicationSerializer
  include Rails.application.routes.url_helpers

  attributes :id,
             :category_id,
             :subscription_id,
             :title,
             :path,
             :url,
             :articles

  delegate :category_id, to: :object

  delegate :subscription_id, to: :object

  def path
    feed_path object
  end

  def articles
    ArticlesIndexSerializer.new(object.articles)
  end
end
