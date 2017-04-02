# frozen_string_literal: true

class FeedsIndexSerializer < ApplicationSerializer
  attributes :feeds, :next_path, :prev_path

  def feeds
    ActiveModel::Serializer::CollectionSerializer
      .new(object.with_articles, serializer: FeedArticlesSerializer)
  end

  def next_path
    File.join(root_path, 'page', object.next_page.to_s) if object.next_page
  end

  def prev_path
    File.join(root_path, 'page', object.prev_page.to_s) if object.prev_page
  end

  def root_path
    Rails.application.config.relative_url_root
  end
end
