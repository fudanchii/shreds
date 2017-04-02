# frozen_string_literal: true

class FeedArticlesSerializer < ApplicationSerializer
  include Rails.application.routes.url_helpers

  attributes :id,
             :category_id,
             :subscription_id,
             :title,
             :path,
             :url,
             :articles,
             :next_path,
             :prev_path

  delegate :category_id, to: :object

  delegate :subscription_id, to: :object

  def path
    feed_url object, only_path: true
  end

  def articles
    ArticlesIndexSerializer.new(object.articles)
  end

  def next_path
    "#{path}/page/#{object.paginated_articles&.next_page}" if object.paginated_articles&.next_page
  end

  def prev_path
    "#{path}/page/#{object.paginated_articles&.prev_page}" if object.paginated_articles&.prev_page
  end
end
