class NavigationListSerializer < ApplicationSerializer
  has_many :categories
  has_many :subscriptions, serializer: FeedPreviewSerializer
end
