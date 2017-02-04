class FeedsIndexSerializer < ApplicationSerializer
  attributes :feeds, :next_path, :prev_path

  def feeds
    ActiveModel::Serializer::CollectionSerializer
      .new(object.with_articles, serializer: FeedArticlesSerializer)
  end

  def next_path
    "/page/#{object.next_page}" if object.next_page
  end

  def prev_path
    "/page/#{object.prev_page}" if object.prev_page
  end
end
