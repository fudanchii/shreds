class NavigationItemSerializer < ApplicationSerializer
  attributes :id,
             :name

  has_many :subscriptions, serializer: FeedPreviewSerializer

  def subscriptions
    object.subscriptions
  end
end
