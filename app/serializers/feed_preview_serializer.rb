class FeedPreviewSerializer < ApplicationSerializer
  attributes :id,
             :feed_id,
             :feed_title,
             :feed_url,
             :category_id

  attribute :latest_article, serializer: ArticlePreviewSerializer

  def feed_url
    object.feed.url
  end

  def feed_title
    object.feed.title
  end

  def latest_article
    object.articles.order('published desc, id asc').first
  end
end
