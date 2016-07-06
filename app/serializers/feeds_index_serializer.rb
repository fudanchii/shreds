class FeedsIndexSerializer < ApplicationSerializer
  attributes :feeds

  def feeds
    ActiveModel::Serializer::CollectionSerializer
      .new(object, serializer: FeedArticlesSerializer)
  end
end
