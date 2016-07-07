require 'nokogiri'

class ArticleSerializer < ApplicationSerializer
  include Rails.application.routes.url_helpers

  attributes :id,
             :title,
             :author,
             :summary,
             :published,
             :path,
             :url,
             :unread

  def summary
    text = object.summary || object.content
    Nokogiri::HTML::DocumentFragment
      .parse(text.to_s[0..432]).to_html
  end

  def url
    object.permalink
  end

  def path
    feed_article_path object.feed, object
  end
end
