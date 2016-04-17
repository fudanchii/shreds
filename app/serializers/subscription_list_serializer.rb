class SubscriptionListSerializer < ApplicationSerializer
  has_one :category
  has_one :feed, serializer: BasicFeedSerializer
end
