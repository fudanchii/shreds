class FeedsIndexSerializer < ActiveModel::Serializer::CollectionSerializer
  def initialize(resources, options = {})
    super(resources, options.merge(serializer: FeedArticlesSerializer))
  end
end
