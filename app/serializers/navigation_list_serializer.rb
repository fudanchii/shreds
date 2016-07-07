class NavigationListSerializer < ActiveModelSerializers::SerializableResource
  def initialize(resource)
    super(resource, {
      serializer: ActiveModel::Serializer::CollectionSerializer,
      each_serializer: NavigationItemSerializer
    })
  end
end
