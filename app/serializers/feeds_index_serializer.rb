class FeedsIndexSerializer < ApplicationSerializer
  attributes :feeds, :next_path

  def feeds
    ActiveModel::Serializer::CollectionSerializer
      .new(object.with_articles, serializer: FeedArticlesSerializer)
  end

  def next_path
    "/page/#{object.next_page}" if object.next_page
  end
end
