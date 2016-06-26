class FeedPreviewSerializer < ApplicationSerializer
  attributes :id,
             :feed_id,
             :feed_title,
             :feed_url,
             :category_id,
             :unread_count,
             :latest_article

  def feed_url
    object.feed.url
  end

  def feed_title
    object.feed.title
  end

  def latest_article
    obj = object.articles.order('published desc, id asc').first
    ArticlePreviewSerializer.new(obj)
  end
end
