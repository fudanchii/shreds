class ArticleSerializer < ApplicationSerializer
  include Rails.application.routes.url_helpers

  attributes :id,
             :title,
             :author,
             :content,
             :summary,
             :published,
             :path,
             :url,
             :unread
  def url
    object.permalink
  end

  def path
    feed_article_path object.feed, object
  end
end
