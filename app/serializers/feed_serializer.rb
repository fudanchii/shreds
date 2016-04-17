class FeedSerializer < ActiveModel::Serializer
  attributes :id, :url, :latest_article
  has_many :articles

  def latest_article
    object.articles.order('published desc, id asc').take 1
  end
end
