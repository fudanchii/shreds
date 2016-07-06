class NavigationItemSerializer < ApplicationSerializer
  attributes :category_id,
             :category_name,
             :subscriptions

  def category_id
    object.id
  end

  def category_name
    object.name
  end

  def subscriptions
    ActiveModel::Serializer::CollectionSerializer
      .new(object.subscriptions, serializer: FeedPreviewSerializer)
  end
end
