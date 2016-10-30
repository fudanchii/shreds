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
    nodes = Nokogiri::HTML::DocumentFragment.parse(text.to_s[0..512])
    if nodes.children.length > 1
      nodes.children = nodes.children[0..-2]
    elsif nodes.children.first.children.length > 1
      nodes.children.first.children = nodes.children.first.children[0..-2]
    end
    nodes.to_html
  end

  def url
    object.permalink
  end

  def path
    feed_article_path object.feed, object
  end
end
