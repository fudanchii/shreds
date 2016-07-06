class NavigationListSerializer < ApplicationSerializer
  attributes :categories

  def categories
    ActiveModel::Serializer::CollectionSerializer
      .new(object, serializer: NavigationItemSerializer)
  end
end
