class FeedArticlesSerializer < ApplicationSerializer
  attributes :id, :title, :url, :articles

  def articles
    ArticlesIndexSerializer.new(object.articles)
  end
end
