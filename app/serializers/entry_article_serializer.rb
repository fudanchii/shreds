# frozen_string_literal: true

class EntryArticleSerializer < ApplicationSerializer
  include Rails.application.routes.url_helpers

  attributes :id,
             :title,
             :author,
             :content,
             :published,
             :path,
             :url,
             :unread,
             :next_path,
             :prev_path

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
    object.article.content || object.article.summary
  end

  def published
    object.article.published
  end

  def url
    object.article.permalink
  end

  def path
    feed_article_url object.feed, object.article, only_path: true
  end

  def next_path
    feed_article_url(object.feed, object.article.next, only_path: true) if object.article.next
  end

  def prev_path
    feed_article_url(object.feed, object.article.prev, only_path: true) if object.article.prev
  end
end
