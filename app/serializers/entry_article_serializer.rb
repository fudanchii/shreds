class EntryArticleSerializer < ApplicationSerializer
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

  def id
    object.article.id
  end

  def title
    object.article.title
  end

  def author
    object.article.author
  end

  def content
    object.article.content
  end

  def summary
    object.article.summary
  end

  def published
    object.article.published
  end

  def url
    object.article.permalink
  end

  def path
    feed_article_path object.feed, object.article
  end
end
