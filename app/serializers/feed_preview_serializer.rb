class FeedPreviewSerializer < ApplicationSerializer
  include Rails.application.routes.url_helpers

  attributes :id,
             :active,
             :feed_id,
             :feed_title,
             :feed_icon,
             :path,
             :category_id,
             :unread_count,
             :latest_article

  def active
    ''
  end

  def feed_title
    object.feed.title
  end

  def feed_icon
    object.feed.favicon
  end

  def path
    feed_path object.feed
  end

  def latest_article
    ArticlePreviewSerializer.new(object.latest_article.first)
  end
end
